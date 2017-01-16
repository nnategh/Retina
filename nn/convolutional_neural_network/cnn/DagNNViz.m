classdef DagNNViz < handle
    %DAGNNVIZ contains functions for visualization a 'DagNN'
    
    properties
    end
    
    methods
    end
    
    methods (Static)
        function plot_allinone(ax, x)
            % PLOT_ALLINONE plots all data in one figure
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data
            % - ax: Axes
            %   axes handle
            
            if nargin == 1
                % replace 'x' with 'ax'
                x = ax;
                
                % figure
                figure(...
                    'Name', 'All in One', ...
                    'NumberTitle', 'off', ...
                    'Units', 'normalized', ...
                    'OuterPosition', [0, 0, 1, 1] ...
                );
                ax = gca;
            end
            
            % number of samples
            N = length(x);
            
            % plot
            hold('on');
            for i = 1 : N
                plot(ax, x{i});
            end
            title(sprintf('%d Samples', N));
            hold('off');
        end

        function plot_summary(x)
            % PLOT_SUMMARY plots all data in one figure
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data
            
            % number of samples
            N = length(x);
            
            % figure
            figure(...
                'Name', 'Summary', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0, 0, 1, 1] ...
            );
            
            % subplot grid
            % - number of rows
            rows = 4;
            % - number of columns for first part (bigger part)
            cols1 = 3;
            % - number of columns for second part (smaller parts)
            cols2 = 1;
            cols = cols1 + cols2;
            % indexes
            indexes = reshape(1 : (rows * cols), [cols, rows])';
            % - indexes of first part (bigger part)
            indexes1 = indexes(:, 1 : cols1);
            indexes1 = sort(indexes1(:));
            % - indexes of second part (smaller parts)
            indexes2 = indexes(:, (cols1 + 1) : end);
            indexes2 = sort(indexes2(:));

            
            % plot
            % - first part (bigger part)
            DagNNViz.plot_allinone(...
                subplot(rows, cols, indexes1), ...
                x ...
            );
            
            % - second part (smaller parts)
            %   - first sample
            subplot(rows, cols, indexes2(1));
            plot(x{1});
            title(sprintf('Sample #%d', 1));
            
            %   - middle sample
            subplot(rows, cols, indexes2(2));
            %       - index of middle sample
            middle_index = max(floor(N/2), 1);
            plot(x{middle_index});
            title(sprintf('Sample #%d',middle_index));
            
            %   - last sample
            subplot(rows, cols, indexes2(3));
            plot(x{N});
            title(sprintf('Sample #%d', N));
            
            %   - mean of samples
            DagNNViz.plot_populationmean(...
                subplot(rows, cols, indexes2(4)), ...
                x ...
            ); 
        end
        
        function plot_populationmean(ax, x)
            % PLOT_POPULATIONMEAN plots mean of population
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data
            % - ax: Axes
            %   axes handle
            
            if nargin == 1
                % replace 'x' with 'ax'
                x = ax;
                
                % figure
                figure(...
                    'Name', 'Population Mean', ...
                    'NumberTitle', 'off', ...
                    'Units', 'normalized', ...
                    'OuterPosition', [0, 0, 1, 1] ...
                );
                ax = gca;
            end
            
            % number of samples
            N = length(x);
            
            % population mean
            pm = x{1};
            for i = 2 : N
                pm = pm + x{i};
            end
            
            pm = pm / N;
            
            plot(ax, pm);
            title('Mean');
        end
        
        function plot_all(x)
            % PLOT_ALL plot all samples in square grid
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data
            
            % number of samples
            N = length(x);
            
            % subplot grid
            % - rows
            rows = ceil(sqrt(N));
            % - cols
            cols = rows;
            
            % plot
            for i = 1 : N
                subplot(rows, cols, i);
                plot(x{i});
                set(gca, ...
                    'XTick', [], ...
                    'XColor', 'white', ...
                    'YTick', [], ...
                    'YColor', 'white' ...
                );
            end
            suptitle(sprintf('%d Samples', N));
        end
        
        function plot_db_all(db)
            % PLOT_DB_ALL plot all input/output samples in square grid
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   input database
            
            % number of samples
            N = min(length(db.x), length(db.y));
            
            % subplot grid
            % - rows
            rows = ceil(sqrt(2 * N));
            % - cols
            cols = rows;
            % - cols must be even
            if mod(cols, 2) == 1
                cols = cols + 1;
            end
            
            % plot
            for i = 1 : 2 : (2 * N)
                % - sample index
                j = floor((i + 1) / 2);
                % - input
                subplot(rows, cols, i);
                plot(db.x{j}, 'Color', 'blue');
                set(gca, ...
                    'XTick', [], ...
                    'XColor', 'white', ...
                    'YTick', [], ...
                    'YColor', 'white' ...
                );
            
                % - input
                subplot(rows, cols, i + 1);
                plot(db.y{j}, 'Color', 'red');
                set(gca, ...
                    'XTick', [], ...
                    'XColor', 'white', ...
                    'YTick', [], ...
                    'YColor', 'white' ...
                );
            end
            suptitle(sprintf('%d Samples', N));
        end
        
        function plot_db_yhat_all(db, y_)
            % PLOT_DB_YHAT_ALL plot all 'db.x', 'db.yb' and 'y^' samples in
            % square grid
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   input database
            % - y_: cell array
            %   estimated outputs
            
            % number of samples
            N = min([length(db.x), length(db.y), length(y_)]);
            
            % subplot grid
            % - rows
            rows = ceil(sqrt(3 * N));
            % - cols
            cols = rows;
            % - cols (mod(cols, 3) must be 0)
            if mod(cols, 3) == 1
                cols = cols + 2;
            elseif mod(cols, 3) == 2
                cols = cols + 1;
            end
            
            % plot
            for i = 1 : 3 : (3 * N)
                % - sample index
                j = floor((i + 2) / 3);
                % - input
                subplot(rows, cols, i);
                plot(db.x{j}, 'Color', 'blue');
                set(gca, ...
                    'XTick', [], ...
                    'XColor', 'white', ...
                    'YTick', [], ...
                    'YColor', 'white' ...
                );
            
                % - expected-output
                subplot(rows, cols, i + 1);
                plot(db.y{j}, 'Color', 'red');
                set(gca, ...
                    'XTick', [], ...
                    'XColor', 'white', ...
                    'YTick', [], ...
                    'YColor', 'white' ...
                );
            
                % - estimated-output
                subplot(rows, cols, i + 2);
                plot(y_{j}, 'Color', 'green');
                set(gca, ...
                    'XTick', [], ...
                    'XColor', 'white', ...
                    'YTick', [], ...
                    'YColor', 'white' ...
                );
            end
            suptitle(sprintf('%d Samples', N));
        end
        
        function plot_bias(bak_dir, param_name, title_txt)
            % PLOT_BIAS plots history of 'param_name' bias based on saved
            % epoch in 'bak_dir' directory
            %
            % Parameters
            % ----------
            % - bak_dir: char vector
            %   path of directory of saved epochs
            % - param_name: char vector
            %   name of target parameter
            % - title_txt: char vector
            %   title of plot
            
            % get history of prameter
            param_history = DagNNViz.get_param_history(bak_dir, param_name);
            param_history = [param_history{:}];
            
            % plot
            plot(param_history);
            xlabel('epoch'), ylabel('bias'), title(title_txt);
            
        end
        
        function save_video(x, filename, frame_rate)
            % SAVE_VIDEO saves data 'x' as a 'filename.mp4' vidoe file
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data
            % - filename: char vector
            %   name of saved video
            % - frame_rate: int (default is 15)
            %   frame-rate of saved video
            
            % defualt frame-rate is 15
            if nargin < 3
                frame_rate = 15;
            end
            
            % open video writer
            vw = VideoWriter(filename, 'MPEG-4');
            vw.FrameRate = frame_rate;
            open(vw);
            
            % figure
            h = figure(...
                'Name', 'Video', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0.25, 0.25, 0.5, 0.5] ...
            );
        
            % number of samples
            N = length(x);
            
            % delay
            delay = 1 / frame_rate;
            
            % make video
            ylimits = DagNNViz.get_ylimits(x);
            for i = 1 : N
                plot(x{i});
                ylim(ylimits);
                title(sprintf('#%d / #%d', i, N));
                writeVideo(vw, getframe(h));
                
                pause(delay);
            end
            
            % close video writer
            close(vw);
        end
        
        function save_db_video(db, filename, frame_rate)
            % SAVE_DB_VIDEO saves database 'db' as a 'filename.mp4' vidoe file
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   input database
            % - filename: char vector
            %   name of saved video
            % - frame_rate: int (default is 15)
            %   frame-rate of saved video
            
            % defualt frame-rate is 15
            if nargin < 3
                frame_rate = 15;
            end
            
            % open video writer
            vw = VideoWriter(filename, 'MPEG-4');
            vw.FrameRate = frame_rate;
            open(vw);
            
            % figure
            h = figure(...
                'Name', 'Video', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0.25, 0.25, 0.5, 0.5] ...
            );
        
            % number of samples
            N = min(length(db.x), length(db.y));
            
            % delay
            delay = 1 / frame_rate;
            
            % make video
            for i = 1 : N
                % - input
                subplot(1, 2, 1);
                plot(db.x{i}, 'Color', 'blue');
                title(sprintf('Input (#%d / #%d)', i, N));
                
                % - output
                subplot(1, 2, 2);
                plot(db.y{i}, 'Color', 'red');
                title(sprintf('Output (#%d / #%d)', i, N));
                
                % - frame
                writeVideo(vw, getframe(h));
                
                % - delay
                pause(delay);
            end
            
            % close video writer
            close(vw);
        end
        
        function save_db_yhat_video(db, y_, filename, frame_rate)
            % SAVE_DB_YHAT_VIDEO saves 'db.x', 'db.y', 'y^' as a
            % 'filename.mp4' video file
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   input database
            % - y_: cell array
            %   estimated outputs
            % - filename: char vector
            %   name of saved video
            % - frame_rate: int (default is 15)
            %   frame-rate of saved video
            
            % defualt frame-rate is 15
            if nargin < 4
                frame_rate = 15;
            end
            
            % open video writer
            vw = VideoWriter(filename, 'MPEG-4');
            vw.FrameRate = frame_rate;
            open(vw);
            
            % figure
            h = figure(...
                'Name', 'Video', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0.125, 0.25, 0.75, 0.5] ...
            );
        
            % number of samples
            N = min(length(db.x), length(db.y));
            
            % delay
            delay = 1 / frame_rate;
            
            % make video
            for i = 1 : N
                % - input
                subplot(1, 3, 1);
                plot(db.x{i}, 'Color', 'blue');
                title(sprintf('Input (#%d / #%d)', i, N));
                
                % - expected-output
                subplot(1, 3, 2);
                plot(db.y{i}, 'Color', 'red');
                title(sprintf('Expected-Output (#%d / #%d)', i, N));
                
                % - expected-output
                subplot(1, 3, 3);
                plot(y_{i}, 'Color', 'green');
                title(sprintf('Estimated-Output (#%d / #%d)', i, N));
                
                % - frame
                writeVideo(vw, getframe(h));
                
                % - delay
                pause(delay);
            end
            
            % close video writer
            close(vw);
        end
        
        function save_frames(x, frames_dir)
            % SAVE_FRAMES saves data 'x' as a 'sample#.png' image files
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data
            % - frames_dir: char vector
            %   path of output directory for saving frames
            
            % directory for save frames
            if exist(frames_dir, 'dir')
                rmdir(frames_dir, 's');
            end
            mkdir(frames_dir);
            
            % figure
            h = figure(...
                'Name', 'Video', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0.25, 0.25, 0.5, 0.5] ...
            );
        
            % number of samples
            N = length(x);
            
            % delay
            delay = 0.01;
            
            % save images
            for i = 1 : N
                plot(x{i});
                title(sprintf('#%d / #%d', i, N));
                
                imwrite(...
                    frame2im(getframe(h)), ...
                    fullfile(frames_dir, [num2str(i), '.png']), ...
                    'png' ...
                );
                
                pause(delay);
            end
        end
        
        function save_db_frames(db, frames_dir)
            % SAVE_DB_FRAMES saves database 'db' as a 'sample#.png' image files
            %
            % Parameters
            % ----------
           % - db: struct('x', cell array, 'y', cell array)
            %   input database
            % - frames_dir: char vector
            %   path of output directory for saving frames
            
            % directory for save frames
            if exist(frames_dir, 'dir')
                rmdir(frames_dir, 's');
            end
            mkdir(frames_dir);
            
            % figure
            h = figure(...
                'Name', 'Video', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0.25, 0.25, 0.5, 0.5] ...
            );
        
            % number of samples
            N = min(length(db.x), length(db.y));
            
            % delay
            delay = 0.01;
            
            % save images
            for i = 1 : N
                % - input
                subplot(1, 2, 1);
                plot(db.x{i}, 'Color', 'blue');
                title(sprintf('Input (#%d / #%d)', i, N));
                
                % - output
                subplot(1, 2, 2);
                plot(db.y{i}, 'Color', 'red');
                title(sprintf('Output (#%d / #%d)', i, N));
                
                % - write image to file
                imwrite(...
                    frame2im(getframe(h)), ...
                    fullfile(frames_dir, [num2str(i), '.png']), ...
                    'png' ...
                );
                
                % - pause
                pause(delay);
            end
        end
        
        function param_history = get_param_history(bak_dir, param_name)
            % GET_PARAM_HISTORY gets history of a 'param_name' prameter 
            % based on saved epochs in 'bak_dir' directory
            %
            % Parameters
            % ----------
            % - bak_dir: char vector
            %   path of directory of saved epochs
            % - param_name: char vector
            %   name of target parameter
            %
            % Returns
            % -------
            % - param_history : cell array
            %   history of param values
            
            % name-list of saved 'epoch' files
            filenames = dir(fullfile(bak_dir, 'epoch_*.mat'));
            filenames = {filenames.name};
            
            % number of epochs
            N = length(filenames);
            
            % get index of param-name
            params = getfield(...
                load(fullfile(bak_dir, filenames{1})), ...
                'params' ...
            );
            param_index = cellfun(...
                @(x) strcmp(x, param_name), ...
                {params.name} ...
            );
        
            % param-hsitory
            param_history = cell(N, 1);
            for i = 1 : N
                 params = getfield(...
                    load(fullfile(bak_dir, filenames{i})), ...
                    'params' ...
                ); 
                param_history{i} = params(param_index).value;
            end
        end
        
        function ylimits = get_ylimits(x)
            % GET_YLIMITS gets ylimits that is suitable for all samples of
            % 'x' data
            %
            % Parameter
            % ---------
            % - x : cell array
            %   input data
            %
            % Returns
            % -------
            % - ylimits : [double, double]
            %   ylimtis of all samples of 'x'
            
            % number of samples
            N = length(x);
            
            % list of min-limits
            min_limits = zeros(N, 1);
            % list of max-limits
            max_limits = zeros(N, 1);
            
            % compute ylimits
            for i = 1 : N
                min_limits(i) = min(x{i});
                max_limits(i) = max(x{i});
            end
            
            ylimits = [min(min_limits), max(max_limits)];
        end
        
        function save_estimated_outputs(props_filename)
            % SAVE_ESTIMATED_OUTPUTS saves estimated-outputs in
            % 'bak_dir/y_.mat'
            %
            % Parameters
            % ----------
            % - props_filename: char vector
            %   path of configuration json file
            
            % run 'vl_setupnn.m' file
            run('D:\PhD\MSU\codes\matconvnet\matconvnet-1.0-beta23\matlab\vl_setupnn.m');

            % cnn
            cnn = DagNNTrainer(props_filename);
            cnn.init();
            
            % load best validation-cost saved epoch
            cnn.load_best_val_epoch();
            
            % estimated-outputs
            % cnn.net.conserveMemory = false;
            y_ = cnn.out(cnn.db.x);
            
            % save
            save(fullfile(cnn.props.data.bak_dir, 'y_.mat'), 'y_');
        end
    end
    
end
