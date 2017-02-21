classdef DagNNViz < handle
    %DAGNNVIZ contains functions for visualization a 'DagNN'
    
    properties
    end
    
    methods
    end
    
    properties (Constant)
        bak_dir = 'D:/PhD/MSU/codes/Retina/nn/convolutional_neural_network/cnn/data/ep20c11/fig4.2/sigma_1.0_bak_70_0.0001';
        data_dir = 'D:/PhD/MSU/codes/Retina/nn/convolutional_neural_network/cnn/data/ep20c11';
        formattype = 'svg';
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
        
        function plot_all(x, red_index)
            % PLOT_ALL plot all samples in square grid
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data
            % - red_index: int (default = 0)
            %   index of 'red' sample
            
            % default values
            if nargin < 2
                red_index = 0;
            end
            
            % number of samples
            N = length(x);
            
            % subplot grid
            % - rows
            rows = ceil(sqrt(N));
            % - cols
            cols = rows;
            
            % plot
            fontsize = 7;
            % - first sample
            i = 1;
            % print progress
            fprintf('Sample %d / %d\n', i, N);

            subplot(rows, cols, i);
            h = plot(x{i});
            set(gca, ...
                'XTick', [], ...
                'XColor', 'white', ...
                'YTick', [], ...
                'YColor', 'white' ...
            );
            xlabel('Time (s)', 'FontSize', fontsize);

            % red sample
            if i == red_index
               set(h, 'Color', 'red'); 
            end
            
            % - other samples
            for i = 2 : N
                % print progress
                fprintf('Sample %d / %d\n', i, N);
                
                subplot(rows, cols, i);
                h = plot(x{i});
                set(gca, ...
                    'XTick', [], ...
                    'XColor', 'white', ...
                    'YTick', [], ...
                    'YColor', 'white' ...
                );
                
                % red sample
                if i == red_index
                   set(h, 'Color', 'red'); 
                end
            end
            suptitle(sprintf('%d Samples', N));
        end
        
        function plot_filter_history(x, red_index)
            % PLOT_ALL plot all samples in square grid
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data
            % - red_index: int (default = 0)
            %   index of 'red' sample
            
            % default values
            if nargin < 2
                red_index = 0;
            end
            
            % number of samples
            N = length(x);
            
            % subplot grid
            % - rows
            rows = ceil(sqrt(N));
            % - cols
            cols = rows;
            
            % plot
            fontsize = 7;
            % - first sample
            i = 1;
            % print progress
            fprintf('Sample %d / %d\n', i, N);

            subplot(rows, cols, i);
            h = plot(x{i});
            set(gca, ...
                'XTick', [], ...
                'YTick', [] ...
            );
            box('off');
            title('Initial Value', 'FontSize', fontsize + 2);
            xlabel('Time (s)', 'FontSize', fontsize);

            % red sample
            if i == red_index
               set(h, 'Color', 'red'); 
            end
            
            % - other samples
            for i = 2 : N
                % print progress
                fprintf('Sample %d / %d\n', i, N);
                
                subplot(rows, cols, i);
                h = plot(x{i});
                set(gca, ...
                    'XTick', [], ...
                    'YTick', [] ...
                );
                box('off');
                
                % red sample
                if i == red_index
                   set(h, 'Color', 'red'); 
                end
            end
            suptitle(sprintf('%d Samples', N));
        end
        
        function plot_filter_initial_best(x, red_index, dt_sec)
            % PLOT_DB_ALL plot all input/output samples in square grid
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   input database
            % - output_dir: char vector
            %   path of output directory
            % - formattype: char vector
            %   file format such as 'pdf', 'svg', 'png' or ...
            % - small_db_size: int (default = 50)
            %   select first samples from db
            
            % figure
            figure(...
                'Name', 'Filter - Initial & Best', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0, 0, 1, 1] ...
            );
        
            % subplot grid
            % - rows
            rows = 1;
            % - cols
            cols = 2;
            
            % initial/best filter
            % - initial
            initial = x{1};
            subplot(rows, cols, 1);
            time = (0 : length(initial) - 1) * dt_sec;
            plot(time, initial, 'Color', 'blue');
            title('Initial Value');
            xlabel('Time (s)');
            ylabel('');
            %   - ticks
            %       - x
            round_digits = 3;
            set(gca, ...
                'XTick', [0, round(time(end), round_digits)] ...
            );
            %       - y
            set(gca, ...
                'YTick', unique([round(min(initial), round_digits), round(max(initial), round_digits)]) ...
            );
            %   - grid
            grid('on');
            box('off');
            
            % - best
            best = x{red_index};
            subplot(rows, cols, 2);
            time = (0 : length(best) - 1) * dt_sec;
            plot(time, best, 'Color', 'red');
            title('Min Validation Cost');
            xlabel('Time (s)');
            ylabel('');
            % - ticks
            %   - x
            set(gca, ...
                'XTick', [0, round(time(end), round_digits)] ...
            );
            %   - y
            set(gca, ...
                'YTick', unique([round(min(best), round_digits), round(max(best), round_digits)]) ...
            );
            % - grid
            grid('on');
            box('off');
        end
        
        function plot_db_all(db, output_dir, formattype, small_db_size)
            % PLOT_DB_ALL plot all input/output samples in square grid
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   input database
            % - output_dir: char vector
            %   path of output directory
            % - formattype: char vector
            %   file format such as 'pdf', 'svg', 'png' or ...
            % - small_db_size: int (default = 50)
            %   select first samples from db
            
            fprintf('----------------\n');
            fprintf('PLOT DB ALL\n');
            fprintf('----------------\n');
            
            % figure
            figure(...
                'Name', 'DB', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0, 0, 1, 1] ...
            );
        
            % small db
            small_db.x = db.x(1:small_db_size);
            small_db.y = db.y(1:small_db_size);
        
            % number of samples
            N = small_db_size;
            
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
            N2 = 2 * N;
            i = 1;
            % first input/output pair
            fontsize = 7;
            fprintf('Sample %d / %d\n', 1, N2);
            % - sample index
            j = floor((i + 1) / 2);
            % - input
            subplot(rows, cols, i);
            plot(small_db.x{j}, 'Color', 'blue');
            title('Stimulus', 'FontSize', fontsize + 2);
            xlabel('Time (s)', 'FontSize', fontsize);
            ylabel('Intensity', 'FontSize', fontsize);
            set(gca, ...
                'XTick', [], ...
                'YTick', [] ...
            );
            box('off');
            % - output
            subplot(rows, cols, i + 1);
            plot(small_db.y{j}, 'Color', 'red');
            title('Response', 'FontSize', fontsize + 2);
            xlabel('Time (s)', 'FontSize', fontsize);
            ylabel('Rate (Hz)', 'FontSize', fontsize);
            set(gca, ...
                'XTick', [], ...
                'YTick', [] ...
            );
            box('off');
            % - other samples
            for i = 3 : 2 : N2
                % print progress
                fprintf('Sample %d / %d\n', i, N2);
                % - sample index
                j = floor((i + 1) / 2);
                % - input
                subplot(rows, cols, i);
                plot(small_db.x{j}, 'Color', 'blue');
                set(gca, ...
                    'XTick', [], ...
                    'XColor', 'white', ...
                    'YTick', [], ...
                    'YColor', 'white' ...
                );
                box('off');
            
                % - output
                subplot(rows, cols, i + 1);
                plot(small_db.y{j}, 'Color', 'red');
                set(gca, ...
                    'XTick', [], ...
                    'XColor', 'white', ...
                    'YTick', [], ...
                    'YColor', 'white' ...
                );
                box('off');
            end
            % super-title
            suptitle(...
                sprintf(...
                    'First %d Samples of %d (Stimulous/Response) Pairs of Training Set', ...
                    length(small_db.x), ...
                    length(db.x) ...
                ) ...
            );
        
            % save
            saveas(gcf, fullfile(output_dir, ['db_all.' formattype]), formattype);
        end
        
        function plot_db_first(db, dt_sec, output_dir, formattype)
            % PLOT_DB_ALL plot all input/output samples in square grid
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   input database
            % - output_dir: char vector
            %   path of output directory
            % - formattype: char vector
            %   file format such as 'pdf', 'svg', 'png' or ...
            % - small_db_size: int (default = 50)
            %   select first samples from db
            
            % figure
            figure(...
                'Name', 'DB', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0, 0, 1, 1] ...
            );
        
            % subplot grid
            % - rows
            rows = 1;
            % - cols
            cols = 2;
            
            % first input/output pair
            % - input
            subplot(rows, cols, 1);
            time = (0 : length(db.x{1}) - 1) * dt_sec;
            plot(time, db.x{1}, 'Color', 'blue');
            title('Stimulus');
            xlabel('Time (s)');
            ylabel('Intensity');
            % - ticks
            %   - x
            round_digits = 2;
            set(gca, ...
                'XTick', [0, round(time(end), round_digits)] ...
            );
            %   - y
            set(gca, ...
                'YTick', unique([round(min(db.x{1}), round_digits), 0, round(max(db.x{1}), round_digits)]) ...
            );
            % - grid
            grid('on');
            box('off');
            % - output
            subplot(rows, cols, 2);
            time = (0 : length(db.y{1}) - 1) * dt_sec;
            plot(time, db.y{1}, 'Color', 'red');
            title('Response');
            xlabel('Time (s)');
            ylabel('Rate (Hz)');
            % - ticks
            %   - x
            set(gca, ...
                'XTick', [0, round(time(end), round_digits)] ...
            );
            %   - y
            set(gca, ...
                'YTick', unique([round(min(db.y{1}), round_digits), 0, round(max(db.y{1}), round_digits)]) ...
            );
            % - grid
            grid('on');
            box('off');
            
            % super-title
            suptitle(...
                sprintf('First Sample (Stimulous/Response) of Training Set') ...
            );
        
            % save
            saveas(gcf, fullfile(output_dir, ['db_first.' formattype]), formattype);
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
            xlabel('Epoch'), ylabel('Bias'), title(title_txt);
            
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
        
            if ~any(param_index)
                param_history = {};
                return
            end
            
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
        
        function plot_spike_trains( spike_trains, number_of_time_ticks, time_limits)
            %PLOT_SPIKE_TRAIN plots spike train
            %   Parameters
            %   ----------
            %   - spike_train : double array
            %   - number_of_time_ticks: int (default = 2)
            %   - time_limits : [double, double] (default = [1, length of each trial]) 
            %       [min_time, max_time]

            % default parameters
            switch nargin
                case 1
                    number_of_time_ticks = 2;
                    time_limits = [1, size(spike_trains, 2)];
                case 2
                    time_limits = [1, size(spike_trains, 2)];
            end
            
            hold('on');
            
            % first baseline
            baseline = 0;
            % number of trails
            N = size(spike_trains, 1);
            % length of spike train
            T = size(spike_trains, 2);
            % time axis
            time = linspace(time_limits(1), time_limits(2), T);
            
            % plot spike train
            for trial_index = 1 : N
                for time_index = 1 : T
                    if spike_trains(trial_index, time_index) > 0
                        plot(...
                            [time(time_index), time(time_index)], ...
                            [baseline, baseline + 1], ...
                            'Color', 'blue' ...
                            );
                    end
                end
                
                baseline = baseline + 1.5;
            end
            
            hold('off');
            % set trial-axis limits
            ylim([-0.5, baseline]);
            % set time-axis label
            xlabel('Time(s)');
            % set trial-axis label
            ylabel('Trail');
            % remove trial-axis ticks
            set(gca, ...
                'XTick', linspace(time_limits(1), time_limits(2), number_of_time_ticks), ...
                'YTick', [] ...
                );
        end
        
        function spks = get_spks(experimets_dir)
            % GET_SPKS gets 'spk' data from saved 'experiment' files in
            % 'experiments_dir' directory
            %
            % Parameters
            % ----------
            % - experiments_dir: char vector
            %   path of saved 'experiments' files
            %
            % Returns
            % -------
            % - spks: struct('value', double array, 'name', char vector)
            % array
            %   contains 'spk' data
            
            % experiment files
            ep_files = dir(fullfile(experimets_dir, '*.mat'));
            ep_files = {ep_files.name};
            
            % number of experiments
            N = length(ep_files);
            
            % spks
            spks = [];
            for i = 1 : N
                spks(i).value = getfield(...
                    load(fullfile(experimets_dir, ep_files{i})), ...
                    'spk' ...
                );
                spks(i).name = ep_files{i};
            end
        end
        
        function plot_spks(experimets_dir)
            % PLOT_SPKS plots 'spk' data from saved 'experiment' files in
            % 'experiments_dir' directory
            %
            % Parameters
            % ----------
            % - experiments_dir: char vector
            %   path of saved 'experiments' files
            
            % spks
            spks = DagNNViz.get_spks(experimets_dir);
            % number of elements
            N = length(spks);
            % add number_of_spiks field
            for i = 1 : N
                spks(i).number_of_spiks = sum(spks(i).value);
            end
            % convert to table
            T = struct2table(spks);
            % sort table based on 'number_of_spiks' columns
            T = sortrows(T, 'number_of_spiks', 'descend');
            
            % subplot grid
            % - rows
            rows = ceil(sqrt(N));
            % - cols
            cols = rows;
            
            % plot
            for i = 1 : N
                subplot(rows, cols, i);
                DagNNViz.plot_spike_trains(T{i, 'value'});
                
                % - title (number of spikes)
                title(...
                    sprintf(...
                        '%d Spikes\n%s', ...
                        T{i, 'number_of_spiks'} ...
                    ) ...
                );
                
                xlabel('');
                ylabel(...
                    char(...
                        regexp(...
                            char(T{i, 'name'}), ...
                            'c\d+', ...
                            'match' ...
                        ) ...
                    ) ...
                );
                
                set(gca, ...
                    'XTick', [], ...
                    'YTick', [] ...
                );
            end
            
        end
        
        function param = analyze_param_name(param_name)
            titles = struct(...
                'B', 'Bipolar', ...
                'A', 'Amacrine', ...
                'G', 'Ganglion' ...
            );
        
            param.is_bias = (param_name(1) == 'b');
            param.title = titles.(param_name(3));
        end
        
        function plot_params(param_names, bak_dir, output_dir, formattype, number_of_epochs, dt_sec)
            % PLOT_PARAMS plots and save parameters in 'params.mat' file
            %
            % Parameters
            % - bak_dir: char vector
            %   path of directory of saved epochs
            % - output_dir: char vector
            %   path of output directory
            % - formattype: char vector
            %   file format such as 'pdf', 'svg', 'png' or ...
            
            % - prameter names
            % param_names = {'w_B', 'w_A', 'w_G', 'b_B', 'b_A', 'b_G'};
            
            % costs
            % - load
            costs = load(fullfile(bak_dir, 'costs'));
            % - bets validation index
            [~, index_min_val_cost] = min(costs.val);
            
            % plot and save
            round_digits = 3;
            for i = 1 : length(param_names)
                % param
                % param.isbias, param.title
                param = DagNNViz.analyze_param_name(param_names{i});
                % param.value
                param.value = ...
                    DagNNViz.get_param_history(bak_dir, (param_names{i}));
                % - resize param.value
                param.value = param.value(1 : number_of_epochs);
                
                if isempty(param.value)
                    continue
                end
                
                % new figure
                figure(...
                    'Name', 'Parameters', ...
                    'NumberTitle', 'off', ...
                    'Units', 'normalized', ...
                    'OuterPosition', [0, 0, 1, 1] ...
                );

                % if parameter is a bias
                if param.is_bias
                    param.value = [param.value{:}];
                    epochs = 0 : (length(param.value) - 1);
                    plot(epochs, param.value);
                    hold('on');
                    plot(...
                        index_min_val_cost - 1, ...
                        round(param.value(index_min_val_cost), round_digits), ...
                        'Color', 'red', ...
                        'Marker', '*', ...
                        'MarkerSize', 3, ...
                        'LineWidth', 2 ...
                    );
                    grid('on');
                    box('off');
                    title(sprintf('%s (Bias with Min Validation Cost is Red)', param.title));
                    xlabel('Epoch');
                    ylabel('Bias');
                    
                    % ticks
                    % - x
                    set(gca, ...
                        'XTick', unique([0, index_min_val_cost - 1, number_of_epochs]) ...
                    );
                    % - y
                    set(gca, ...
                        'YTick', ...
                        unique([...
                            round(min(param.value), round_digits), ...
                            round(param.value(index_min_val_cost), round_digits), ...
                            round(max(param.value), round_digits) ...
                        ]) ...
                    );
                    ylim([round(min(param.value), round_digits), round(max(param.value), round_digits)]);
                    
                    % save
                    saveas(...
                        gcf, ...
                        fullfile(...
                            output_dir, ...
                            ['bias_', lower(param.title), '.', formattype] ...
                        ), ...
                        formattype ...
                    );
                
                % if parameter is a filter
                else
                    % - all
                    DagNNViz.plot_filter_history(param.value, index_min_val_cost);
                    box('off');
                    suptitle(...
                        sprintf(...
                            'Filter of %s for each Epoch of Training (Filter with Min Validation Cost is Red)', ...
                            param.title ...
                        ) ...
                    );
                
                    % save
                    saveas(...
                        gcf, ...
                        fullfile(...
                            output_dir, ...
                            ['filter_', lower(param.title), '_all.', formattype] ...
                        ), ...
                        formattype ...
                    );
                
                    % - initial & best
                    DagNNViz.plot_filter_initial_best(param.value, index_min_val_cost, dt_sec);
                    box('off');
                    suptitle(...
                        sprintf(...
                            'Filter of %s for Epoch 0 & Epoch %d', ...
                            param.title, ...
                            index_min_val_cost - 1 ...
                        ) ...
                    );
                
                    % save
                    saveas(...
                        gcf, ...
                        fullfile(...
                            output_dir, ...
                            ['filter_', lower(param.title), '_initial_best.', formattype] ...
                        ), ...
                        formattype ...
                    );
                end
            end
            
        end
        
        function plot_stim(stim, dt_sec, output_dir, formattype)
            % PLOT_STIM plots stimulous
            %
            % Parameters
            % ----------
            % - stim: double vector
            %   stimulus
            % - dt_sect: double
            %   time resolution in second
            % - output_dir: char vector
            %   path of output directory
            % - formattype: char vector
            %   file format such as 'pdf', 'svg', 'png' or ...
            
            % default values
            if nargin < 4
                formattype = 'svg';
            end
            
            time = (1 : length(stim)) * dt_sec;
            
            % figure
            figure(...
                'Name', 'STIM', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0, 0, 1, 1] ...
            );
            % plot
            plot(time, stim);
            % - title
            title('Stimulus');
            % - label
            %   - x
            xlabel('Time (s)');
            %   - y
            ylabel('Intensity');
            % - ticks
            %   - x
            set(gca, ...
                'XTick', [0, round(time(end), 1)] ...
            );
            %   - y
            set(gca, ...
                'YTick', unique([round(min(stim), 1), 0, round(max(stim), 1)]) ...
            );
            % - grid
            grid('on');
            
            % save
            saveas(gcf, fullfile(output_dir, ['stim.' formattype]), formattype);
        end
        
        function plot_resp(resp, dt_sec, output_dir, formattype)
            % PLOT_STIM plots response
            %
            % Parameters
            % ----------
            % - stim: double vector
            %   stimulus
            % - dt_sect: double
            %   time resolution in second
            % - output_dir: char vector
            %   path of output directory
            % - formattype: char vector
            %   file format such as 'pdf', 'svg', 'png' or ...
            
            % default values
            if nargin < 4
                formattype = 'svg';
            end
            
            time = (1 : length(resp)) * dt_sec;
            
            % figure
            figure(...
                'Name', 'RESP', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0, 0, 1, 1] ...
            );
            % plot
            plot(time, resp);
            % - title
            title('PSTH');
            % - label
            %   - x
            xlabel('Time (s)');
            %   - y
            ylabel('Firing Rate (Hz)');
            % - ticks
            %   - x
            set(gca, ...
                'XTick', [0, round(time(end), 1)] ...
            );
            %   - y
            set(gca, ...
                'YTick', unique([round(min(resp), 1), round(max(resp), 1)]) ...
            );
            % - grid
            grid('on');
            
            % save
            saveas(gcf, fullfile(output_dir, ['resp.' formattype]), formattype);
        end
        
        function plot_data()
            % parameters
            % - path of data directory
            data_dir = DagNNViz.data_dir;
            % - time resolution (sec)
            dt_sec = Neda.dt_sec;
            % - format-type of saved images
            formattype = DagNNViz.formattype;
            
            % output directory
            % - path
            output_dir = fullfile(data_dir, 'summary/images');
            % - make if doesn't exist
            if ~exist(output_dir, 'dir')
                mkdir(output_dir);
            end
            
            % data
            data = load(fullfile(data_dir, 'data.mat'));
            % - stim
            stim = data.stim;
            DagNNViz.plot_stim(stim, dt_sec, output_dir, formattype);
            % - resp
            resp = data.resp;
            DagNNViz.plot_resp(resp, dt_sec, output_dir, formattype);
            
            % db
            % - all
            db = load(fullfile(data_dir, 'db.mat'));
            small_db_size = 50;
            DagNNViz.plot_db_all(...
                db, ...
                output_dir, ...
                formattype, ...
                small_db_size ...
            );
            % - first
            DagNNViz.plot_db_first(...
                db, ...
                dt_sec, ...
                output_dir, ...
                formattype ...
            );
            
        end
        
        function plot_costs(costs, output_dir, formattype)
            % PLOT_COSTS plots 'costs' over time
            
            epochs = 1:length(costs.train);
            % start epochs from zero (0, 1, 2, ...)
            epochs = epochs - 1;
            
            figure(...
                'Name', 'CNN - Costs [Training, Validation, Test]', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0, 0, 1, 1] ...
                );
            
            % costs
            % - train
            plot(epochs, costs.train, 'LineWidth', 2, 'Color', 'blue');
            set(gca, 'YScale', 'log');
            hold('on');
            % - validation
            plot(epochs, costs.val, 'LineWidth', 2, 'Color', 'green');
            % - test
            plot(epochs, costs.test, 'LineWidth', 2, 'Color', 'red');
            
            % minimum validation error
            % - circle
            [~, index_min_val_cost] = min(costs.val);
            circle_x = index_min_val_cost - 1;
            circle_y = costs.val(index_min_val_cost);
            dark_green = [0.1, 0.8, 0.1];
            scatter(circle_x, circle_y, ...
                'MarkerEdgeColor', dark_green, ...
                'SizeData', 75, ...
                'LineWidth', 2 ...
                );
            
            % - cross lines
            h_ax = gca;
            %   - horizontal line
            line(...
                h_ax.XLim, ...
                [circle_y, circle_y], ...
                'Color', dark_green, ...
                'LineStyle', ':', ...
                'LineWidth', 1.5 ...
                );
            %   - vertical line
            line(...
                [circle_x, circle_x], ...
                h_ax.YLim, ...
                'Color', dark_green, ...
                'LineStyle', ':', ...
                'LineWidth', 1.5 ...
                );
            
            hold('off');
            
            % ticks
            round_digits = 3;
            % - x
            set(gca, ...
                'XTick', unique([0, index_min_val_cost - 1, epochs(end)]) ...
            );
            % - y
            set(gca, ...
                'YTick', ...
                unique([...
                    round(min([costs.train, costs.val, costs.test]), round_digits), ...
                    round(costs.val(index_min_val_cost), round_digits), ...
                    round(max([costs.train, costs.val, costs.test]), round_digits) ...
                ]) ...
            );
            
            % labels
            xlabel('Epoch');
            ylabel('Mean Squared Error (Hz^2)');
            
            % title
            title(...
                sprintf('Minimum Validation Error is %.3f at Epoch: %d', ...
                costs.val(index_min_val_cost), ...
                index_min_val_cost - 1 ...
                ) ...
                );
            
            % legend
            legend(...
                sprintf('Training (%.3f)', costs.train(index_min_val_cost)), ...
                sprintf('Validation (%.3f)', costs.val(index_min_val_cost)), ...
                sprintf('Test (%.3f)', costs.test(index_min_val_cost)), ...
                'Best Validation Error' ...
                );
            
            % grid
            grid('on');
            
            % box
            box('off');
            
            % save
            saveas(gcf, fullfile(output_dir, ['error.' formattype]), formattype);
        end
        
        function plot_results(bak_dir, formattype)
            % parameters
<<<<<<< HEAD
%             % - 'bak' dir
%             bak_dir = DagNNViz.bak_dir;
%             % - format-type
%             formattype = DagNNViz.formattype;
            % - output-dir
            output_dir = fullfile(bak_dir, 'images');
            if ~exist(output_dir, 'dir')
                mkdir(output_dir);
=======
            % - format-type
            formattype = DagNNViz.formattype;
            % - time resolution
            dt_sec = Neda.dt_sec;
            
            % 'props' dir
            props_dir = DagNNTrainer.props_dir;
            % properties filenames
            props_filenames = ...
                dir(fullfile(props_dir, '*.json'));
            props_filenames = {props_filenames.name};
            
            % main loop
            for i = 1 : length(props_filenames)
                DagNNTrainer.print_dashline();
                fprintf('%s\n', props_filenames{i});
                DagNNTrainer.print_dashline();
                % props-filename
                props_filename = fullfile(props_dir, props_filenames{i});
                % props
                props = jsondecode(fileread(props_filename));
                % 'bak' dir
                bak_dir = props.data.bak_dir;
                
                % output dir
                % - path
                output_dir = fullfile(bak_dir, 'summary/images');
                % - make if doesn't exist
                if ~exist(output_dir, 'dir')
                    mkdir(output_dir);
                end

                % costs
                % - make
                costs = load(fullfile(bak_dir, 'costs.mat'));
                % - plot
                DagNNViz.plot_costs(costs, output_dir, formattype);

                % params
                DagNNViz.plot_params({props.net.params.name}, bak_dir, output_dir, formattype, 101, dt_sec);
>>>>>>> 7c560ee09af839c0a811c3ed8f77a34a72db15d9
            end
            
            
        end
    end
end
