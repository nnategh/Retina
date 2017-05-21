classdef VizOutputs < handle
    %Visualize `true` and `predicted` outputs with `rmse` errors
    
    properties (Constant)
        % Properties
        % ----------
        % - dataDir: char vector
        %   Path of `data` directory
        % - errorsDir: char vector
        %   Path of `errors` directory
        % - netsDir: char vector
        %   Path of `nets` directory

        dataDir = './data';
        errorsDir = './errors';
        netsDir = './nets';
    end
    
    properties
        % Properties
        % ----------
        % - y: cell array of double vector
        %   True outputs
        % - y_: cell array of double vector
        %   Expected outputs
        % - e: double vector
        %   Root-Mean-Square-Error between `y` and `y_`
        % - indexes: struct(...
        %           'train', int vector, ...
        %           'val', int vector, ...
        %           'test', int vector ...
        %         )
        %   Contains `train`, `val` and `test` indexes
        % - figRMSE: Figure
        %   Handle of `RMSE` figure
        
        y
        y_
        e
        indexes
        figRMSE
    end
    
    methods
        function obj = VizOutputs(dbFilename)
            % Constructor
            %
            % Properties
            % ----------
            % - dbFilename: char vector
            %   Path of data-base file
            
            % load `db`
            db = load(dbFilename);
            % `y`, `y_`, `e` and `indexes`
            obj.y = db.y;
            obj.y_ = db.y_;
            obj.e = VizOutputs.rmse(obj.y, obj.y_);
            obj.indexes = db.indexes;
        end
        
        function gui(obj)
            % Grapical user interface
            % click on intended bin
            
            % first plot
            obj.plot(1);
            
            % data cursor mode
            dcm = datacursormode(gcf);
            dcm.Enable = 'on';
            
            % handle of current figure
            h = gcf();
            while true
                pause(0.1);
                if ~isvalid(h) || ~isvalid(dcm)
                    break;
                end
            
                cursorInfo = getCursorInfo(dcm);
                if ~isempty(cursorInfo) && strcmp(cursorInfo.Target.Type, 'bar')
                    % get bin number
                    binNumber = cursorInfo.Position(1);
                    % plot
                    obj.plot(binNumber);
                    clc();
                end
            end
        end
        
        function cli(obj)
            % Command line interface
            % Valid inputs: `integer`, `vector of integers`, `'min'`,
            % `'max'`, `'exit'`
            
            % parameters
            % - prompt text
            prompt = 'bin:   ';
            % - delay in seconds
            delay = 0.5;
            
            % number of bins, minimum and maximum error
            numberOfBins = numel(obj.e);
            minError = min(obj.e);
            maxError = max(obj.e);
            
            % first plot
            obj.plot(1);
            h = gcf();
            
            % print help
            VizOutputs.printHelp();
            
            % loop until input equls `'exit'`
            while true
                % get number of bins
                bins = input(prompt);
                
                % if `isSequence` is true then is shown frame by frame
                isSequence = true;
                
                % if input is string command
                if ischar(bins)
                    isSequence = false;
                    switch bins
                        case 'min' % bins with minimum errors
                            bins = find(obj.e == minError);
                        case 'max' % bins with maximum errors
                            bins = find(obj.e == maxError);
                        case 'end' % last bin
                            bins = numberOfBins;
                        case 'train' % training data
                            bins = obj.indexes.train;
                        case 'val' % validation data
                            bins = obj.indexes.val;
                        case 'test' % test data
                            bins = obj.indexes.test;
                        otherwise
                            bins = [];
                    end
                end
                
                % break if bins is empty or figure is closed
                if isempty(bins) || ~isvalid(h)
                    break;
                end
                
                % refine bins
                % - double to integer
                bins = floor(bins);
                % - minimum bin number is `1`
                bins = max(1, bins);
                % maximum bin number is `number of bins`
                bins = min(numberOfBins, bins);
                
                if isSequence
                    % plot for each bin number
                    for bin = bins
                        % plot
                        obj.plot(bin);
                        % pause
                        pause(delay);
                    end
                else
                    obj.plot(bins)
                end
            end
            
            % close figure
            if isvalid(h)
                close(h);
            end
        end
        
        function plot(obj, bins)
            % Helper method for `plotOutputRMSE` static function
            %
            % Parameters
            % ----------
            % - bins: int vectr
            %   Indexes of bins in bar plot of rmse

            % rmse figure
            if isempty(obj.figRMSE)
                obj.figRMSE = figure();
            end
            
            % index of bins with maximum error
            index = obj.getBinWithMaxError(bins);
            
            VizOutputs.plotOutputRMSE(...
                obj.y{index}, ...
                obj.y_{index}, ...
                obj.e, ...
                bins, ...
                index, ...
                obj.figRMSE ...
            );
        end
        
        function printRMSETable(obj)
            % Print RMES table
            %
            
            numberOfDigits = 3;
            
            items = {...
                'All', ...
                'Train', ...
                'Val', ...
                'Test' ...
            };
            meanValues = round([
                mean(obj.e)
                mean(obj.e(obj.indexes.train))
                mean(obj.e(obj.indexes.val))
                mean(obj.e(obj.indexes.test))
            ], numberOfDigits);
            stdValues = round([
                std(obj.e)
                std(obj.e(obj.indexes.train))
                std(obj.e(obj.indexes.val))
                std(obj.e(obj.indexes.test))
            ], numberOfDigits);
            numbers = [
                numel(obj.e)
                numel(obj.indexes.train)
                numel(obj.indexes.val)
                numel(obj.indexes.test)
            ];
            rmseTable = table(...
                meanValues, stdValues, numbers, ...
                'RowNames', items, ...
                'VariableNames', {'mean', 'std', 'numel'} ...
            );
            disp('Root-Mean-Square-Error:');
            disp(rmseTable);
        end
        
        function index = getBinWithMaxError(obj, bins)
            % Get index of bin in specified bins with maximum error
            %
            % Parameters
            % ----------
            % - bins: int vector
            %   Indexes of highlighted bins
            
            [~, index] = max(obj.e(bins));
            index = bins(index);
        end
    end
    
    methods (Static)
        function e = rmse(y, y_)
            % Root-mean-square-error
            %
            % Parameters
            % ----------
            % - y: cell array of double vector
            %   True outputs
            % - y_: cell array of double vector
            %   Expected outputs
            %
            % Returns
            % -------
            % - e: double vector
            %   Error
            
            % number of samples
            numberOfSamples = min(numel(y), numel(y_));
            
            e = zeros(numberOfSamples, 1);
            for i = 1:numberOfSamples
                e(i) = rms(y{i} - y_{i});
            end
        end
        
        function plotRMSE(e, bins, index)
            % Create a bar graph of root-mean-square-error and highlight
            % n'th bin
            %
            % Parameters
            % ----------
            % - e: double vector
            %   Error
            % - bins: int vector
            %   Indexes of highlighted bins
            % - index: int
            %   Index of bins with maximum error
            
            % number of bins
            numberOfBins = numel(e);
            % specified error
            e_ = zeros(size(e));
            e_(bins) = e(bins);
            
            % maximum error
            maxError = max(e);
            minError = min(e);
            % number of digits in `round` function
            numberOfDigits = 2;
            
            % bar plot
            bar(e);
            hold('on');
            bar(e_, 'FaceColor', 'red');
            hold('off');
            
            set(...
                gca, ...
                'XTick', unique(round([index, numberOfBins], numberOfDigits)), ...
                'YTick', unique(round([minError, e(index), maxError], numberOfDigits)), ...
                'YGrid', 'on' ...
            );
            axis('tight');
            xlabel('Samples');
            ylabel('RMSE');
        end
        
        function plotTrueVsPredictedOutput(y, y_)
            % Plot `true` vs `predicted` output
            %
            % Parameters
            % ----------
            % - y: double vector
            %   True output
            % - y_: double vector
            %   Expected output
            
            % line width
            lineWidth = 1.5;
            % number of digits in `round` function
            numberOfDigits = 3;
            % number of points
            numberOfPoints = max(numel(y), numel(y_));
            % min and max value
            minValue = min([y(:); y_(:)]);
            maxValue = max([y(:); y_(:)]);
            
            % plot
            plot(y, 'LineWidth', lineWidth);
            hold('on');
            plot(y_, '-.', 'LineWidth', lineWidth);
            hold('off');
            
            xlabel('Index');
            ylabel('Intensity');
            
            legend('True', 'Predicted');
            
            set(gca, ...
                'XTick', numberOfPoints, ...
                'YTick', unique(round([minValue, maxValue], numberOfDigits)), ...
                'XGrid', 'on' ...
            );
            axis('tight');
        end
        
        function plotOutputRMSE(y, y_, e, bins, index, fig)
            % Sub-plots `plotRMSE` and `plotTrueVsPredictedOutput`
            %
            % Parameters
            % ----------
            % - y: double vector
            %   True output
            % - y_: double vector
            %   Expected output
            % - e: double vector
            %   Error
            % - bins: int vector
            %   Indexes of highlighted bins
            % - index: int
            %   Index of bins with maximum error
            % - fig: Figure
            %   Figure handle
            
            % default values
            if ~exist('fig', 'var')
                fig = gcf();
            end
            
            % figure
            figure(fig);
            set(fig, ...
                'Name', 'True/Predicted Ouputs & RMSE', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0, 0, 1, 1] ...
            );

            % plot
            % - parameters
            rows = 2;
            cols = 1;
            % - output
            subplot(rows, cols, 1);
            VizOutputs.plotTrueVsPredictedOutput(y, y_);
            % - rmse
            subplot(rows, cols, 2);
            VizOutputs.plotRMSE(e, bins, index);
        end
        
        function printHelp()
            % Print valid commands in `cli` interface
            
            fprintf('Valid Commands:\n');
            fprintf('\tIndex scalar such as 1, 2, …\n');
            fprintf('\tIndex vector such as [1, 2], 10:20, …\n');
            fprintf('\t''min''\tIndexes with minimum error\n');
            fprintf('\t''max''\tIndexes with maximum error\n');
            fprintf('\t''train''\tIndexes of training data-set\n');
            fprintf('\t''val''\tIndexes of validation data-set\n');
            fprintf('\t''test''\tIndexes of test data-set\n');
            fprintf('\t''end''\tLast index\n');
            fprintf('\t''exit''\tExit the program\n\n');
        end
        
        function h = figure(name)
            % Create `full screen` figure
            %
            % Parameters
            % ----------
            % - name: char vector
            %   Name of figure
            %
            % Return
            % - h: matlab.ui.Figure
            h = figure(...
                'Name', name, ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0, 0, 1, 1] ...
            );
        end
        
        function st = getSummaryTable()
            % Get summary table
            % Columns of table are `Model`, `All`, `Train`, `Val`, `Test`
            %
            % Returns
            % -------
            % - st: table
            %   Summary table of errors
            
            % number of digits in round process
            numOfDigits = 3;
            
            % get data
            filenames = dir(fullfile(VizOutputs.dataDir, '*.mat'));
            numOfData = numel(filenames);
            
            % column names
            colNames = {'Model', 'All', 'Train', 'Val', 'Test'};
            
            % models
            models = cell(numOfData, 1);
            for i = 1:numOfData
                [~, models{i}, ~] = fileparts(filenames(i).name);
            end
            
            % rmse (all, train, val & test)
            all = zeros(numOfData, 1);
            train = zeros(numOfData, 1);
            val = zeros(numOfData, 1);
            test = zeros(numOfData, 1);
            
            for i = 1:numOfData
                vizout = VizOutputs(fullfile(...
                    VizOutputs.dataDir, ...
                    filenames(i).name)...
                );
                all(i) = mean(vizout.e);
                train(i) = mean(vizout.e(vizout.indexes.train));
                val(i) = mean(vizout.e(vizout.indexes.val));
                test(i) = mean(vizout.e(vizout.indexes.test));
            end
            
            % round
            all = round(all, numOfDigits);
            train = round(train, numOfDigits);
            val = round(val, numOfDigits);
            test = round(test, numOfDigits);
            
            % summary table
            st = table(...
                models, all, train, val, test, ...
                'VariableNames', colNames ...
            );
        end
        
        function ut = getUITable()
            % Get uitable
            %
            % Returns
            % -------
            % - st: table
            %   uitable of errors
            
            t = VizOutputs.getSummaryTable();
            data = [...
                t.Model, ...
                num2cell(t.All), ...
                num2cell(t.Train), ...
                num2cell(t.Val), ...
                num2cell(t.Test) ...
            ];
            
            ut = uitable(...
                'Data', data, ...
                'ColumnName', t.Properties.VariableNames, ...
                'Units', 'Normalized', ...
                'Position', [0, 0, 1, 1] ...
            );
            
        end
    end
    
    % main
    methods (Static)
        function main(dbFilename, interface)
            % Main
            %
            % Properties
            % ----------
            % - dbFilename: char vector
            %   Path of data-base file
            % - interface: char vector (defualt = 'cli')
            %   'cli' or 'gui'
            
            % default values
            if ~exist('interface', 'var')
                interface = 'cli';
            end
            
            % show images of `net` and `error`
            [~, filename, ~] = fileparts(dbFilename);

            % - net
            VizOutputs.figure('Net');
            imshow(fullfile('./nets', [filename '.png']));

            % - error
            VizOutputs.figure('Error');
            imshow(fullfile('./errors', [filename '.png']));
            
            % construct `VizOutputs` object
            vizout = VizOutputs(dbFilename);
            
            % print rmse table
            clc();
            vizout.printRMSETable();
            
            % run interface
            switch interface
                case 'cli' % command line interface
                    vizout.cli();
                case 'gui' % graphical user interface
                    vizout.gui();
            end
        end
    end
    
end
