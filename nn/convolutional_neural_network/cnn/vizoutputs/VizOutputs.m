classdef VizOutputs < handle
    %Visualize `true` and `predicted` outputs with `rmse` errors
    
    properties
        % Properties
        % ----------
        % - y: cell array of double vector
        %   True outputs
        % - y_: cell array of double vector
        %   Expected outputs
        % - e: double vector
        %   Root-Mean-Square-Error between `y` and `y_`
        y
        y_
        e
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
            % `y`, `y_` & `e`
            obj.y = db.y;
            obj.y_ = db.y_;
            obj.e = VizOutputs.rmse(obj.y, obj.y_);
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
            
            % loop until input equls `'exit'`
            while true
                % get number of bins
                bins = input(prompt);
                
                % if input is string command
                if ischar(bins)
                    switch bins
                        case 'min' % bins with minimum errors
                            bins = find(obj.e == minError);
                        case 'max' % bins with maximum errors
                            bins = find(obj.e == maxError);
                        case 'end' % last bin
                            bins = numberOfBins;
                        otherwise
                            bins = [];
                    end
                end
                
                % break if bins is empty
                if isempty(bins)
                    break;
                end
                
                % plot for each bin number
                for bin = bins
                    % double to integer
                    refinedBin = floor(bin);
                    % minimum bin number is `1`
                    refinedBin = max(1, refinedBin);
                    % maximum bin number is `number of bins`
                    refinedBin = min(numberOfBins, refinedBin);
                    % plot
                    obj.plot(refinedBin);
                    % pause
                    pause(delay);
                end
            end
        end
        
        function plot(obj, binNumber)
            % Helper method for `plotOutputRMSE` static function
            %
            % Parameters
            % ----------
            % - binNumber: int
            %   No. of bin in bar plot of rmse

            VizOutputs.plotOutputRMSE(...
                obj.y{binNumber}, ...
                obj.y_{binNumber}, ...
                obj.e, ...
                binNumber ...
            );
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
        
        function plotRMSE(e, n)
            % Create a bar graph of root-mean-square-error and highlight
            % n'th bin
            %
            % Parameters
            % ----------
            % - e: double vector
            %   Error
            % - n: int
            %   No. of highlighted bin
            
            % number of bins
            numberOfBins = numel(e);
            % specified error
            e_ = zeros(size(e));
            e_(n) = e(n);
            % maximum error
            maxError = max(e);
            % number of digits in `round` function
            numberOfDigits = 2;
            
            % bar plot
            bar(e);
            hold('on');
            bar(e_, 'FaceColor', 'red');
            hold('off');
            
            set(...
                gca, ...
                'XTick', unique(round([n, numberOfBins], numberOfDigits)), ...
                'YTick', unique(round([e(n), maxError], numberOfDigits)), ...
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
        
        function plotOutputRMSE(y, y_, e, n)
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
            % - n: int
            %   No. of highlighted bin
            
            % figure
            set(gcf, ...
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
            VizOutputs.plotRMSE(e, n);
        end
    end
    
    % main
    methods (Static)
        function main(dbFilename)
            % Main
            %
            % Properties
            % ----------
            % - dbFilename: char vector
            %   Path of data-base file
            
            % construct `VizOutputs` object
            vizout = VizOutputs(dbFilename);
            
            % cli
            % vizout.cli();
            
            % gui
            vizout.gui();
        end
    end
    
end
