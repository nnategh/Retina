classdef DagNNViz < handle
    %DAGNNVIZ contains functions for visualization a 'DagNN'
    
    properties
    end
    
    methods
    end
    
    properties (Constant)
        % Constant Properties
        % -------------------
        % - bak_dir: char vector
        %   Path of `backup` directory which contains `costs`, `db_indexes`, 
        %   `elapsed_times`, `epochs` and also contains `summary`
        %   direcotry.
        % - data_dir: char vector
        %   Path of `data` directory which contains `db.mat` and
        %   `params.mat`
        % - output_dir: char vector
        %   Path of output directory
        % - formattype: char vector
        %   File format such as `epsc`, `pdf`, `svg`, `png` or ...
        % - showtitle: logical (default: true)
        %   If `showtitle` is `false` then plots don't have any title
        
        bak_dir = 'E:\Documents\University\3. PhD\MSU\Neda\codes\Retina\nn\convolutional_neural_network\cnn\data\ep20c11\fig4.2\bak_200_0.0001';
        data_dir = 'E:\Documents\University\3. PhD\MSU\Neda\codes\Retina\nn\convolutional_neural_network\cnn\data\ep20c11';
        output_dir = '';
        formattype = 'epsc';
        showtitle = true;
    end
    
    % Unused
    methods (Static)
        
    end
    
    % Utils
    methods (Static)
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
        
        function title(varargin)
            % Add or not `title` of current axis
            %
            % Parameters
            % ----------
            % - text: char vector
            %   Text of title
            if DagNNViz.showtitle
                title(varargin{:});
            end
        end
        
        function suptitle(text)
            % Add or not `suptitle` of current figure
            %
            % Parameters
            % ----------
            % - text: char vector
            %   Text of title
            if DagNNViz.showtitle
                suptitle(text);
            end
        end
        
        function hideticks()
            % Hide `XTick` and `YTick` of current axis
            set(gca, ...
                'XTick', [], ...
                'YTick', [], ...
                'Box', 'off' ...
            );
        end
        
        function round_digits = get_round_digits(x_min, x_max)
            % Get first `rounddigits` start from `0` that distinguish
            % between `x_min` and `x_max`
            round_digits = 3;
            x_min_rounded = round(x_min, round_digits);
            x_max_rounded = round(x_max, round_digits);
            
            while x_min_rounded == x_max_rounded
                round_digits = round_digits + 1;
                x_min_rounded = round(x_min, round_digits);
                x_max_rounded = round(x_max, round_digits);
            end
            
        end
        
        function twoticks(x, axis_name)
            % Show just `min` and `max` of ticks
            %
            % Parameters
            % ----------
            % - x: double vector
            %   Input values
            % - axis_name: cahr vector
            %   'XTick' or 'YTick' 
            
            x_min = min(x);
            x_max = max(x);
            round_digits = DagNNViz.get_round_digits(x_min, x_max);
            set(gca, ...
                axis_name, [...
                    round(x_min, round_digits), ...
                    round(x_max, round_digits) ...
                ] ...
            );
        end
        
        function saveas(filename)
            % Save curret figure as `fielname`
            %
            % Parameters
            % ----------
            % - filename: char vector
            %   Path of file which must be saved
            
            saveas(gcf, filename, DagNNViz.formattype);
        end
    end
    
    methods (Static)
        function plot(x, y, plot_color, plot_title, x_label, y_label)
            % Like as matlab `plot`
            %
            % Parameters
            % ----------
            % - x: double vector
            %   `x` input
            % - y: double vector
            %   `y` input
            % - plot_color: char vector
            %   Color of plot
            % - plot_title: char vector
            %   Title of plot
            % - x_label: char vector
            %   Label of `x` axis
            % - y_label: char vector
            %   Label of `y` axis
            
            plot(x, y, 'Color', plot_color);
            DagNNViz.title(plot_title);
            xlabel(x_label);
            ylabel(y_label);
            %   - ticks
            %       - x
            DagNNViz.twoticks(x, 'XTick');
            %       - y
            DagNNViz.twoticks(y, 'YTick');
            %   - grid
            grid('on');
            box('off');
        end
        
        function print_title(text)
            % Print `text` in command window
            %
            % Parameters
            % ----------
            % - text: char vector
            %   Text of title
            
            fprintf('%s\n', text);
            fprintf('%s\n', repmat('-', size(text)));
        end
        
        function plot_allinone(ax, x)
            % Plot all data in one figure
            %
            % Parameters
            % ----------
            % - ax: Axes
            %   axes handle
            % - x: cell array
            %   input data {x1, x2, ...}
            
            if nargin == 1
                % replace 'x' with 'ax'
                x = ax;
                
                % figure
                DagNNViz.figure('All in One');
                ax = gca;
            end
            
            % number of samples
            N = length(x);
            
            % plot
            hold('on');
            for i = 1 : N
                plot(ax, x{i});
            end
            DagNNViz.title(sprintf('%d Samples', N));
            hold('off');
        end
        
        function pm = populationmean(x)
            % Return `mean` of population
            % Parameters
            % ----------
            % - x: cell array
            %   input data {x1, x2, ...}
            %
            % Return
            % ------
            % - pm: double vector
            
            % number of samples
            N = length(x);
            
            % population mean
            pm = x{1};
            for i = 2 : N
                pm = pm + x{i};
            end
            
            pm = pm / N;
        end

        function plot_populationmean(ax, x)
            % Plot mean of population
            %
            % Parameters
            % ----------
            % - ax: Axes
            %   axes handle
            % - x: cell array
            %   input data {x1, x2, ...}
            
            if nargin == 1
                % replace 'x' with 'ax'
                x = ax;
                
                % figure
                DagNNViz.figure('Population Mean');
                ax = gca;
            end
            
            plot(ax, DagNNViz.populationmean(x));
            DagNNViz.title('Mean');
        end
        
        function plot_summary(x)
            % Plot all data in one figure
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data  {x1, x2, ...}
            
            % number of samples
            N = length(x);
            
            % figure
            DagNNViz.figure('Summary');
            
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
            DagNNViz.title(sprintf('Sample #%d', 1));
            
            %   - middle sample
            subplot(rows, cols, indexes2(2));
            %       - index of middle sample
            middle_index = max(floor(N/2), 1);
            plot(x{middle_index});
            DagNNViz.title(sprintf('Sample #%d',middle_index));
            
            %   - last sample
            subplot(rows, cols, indexes2(3));
            plot(x{N});

            DagNNViz.title(sprintf('Sample #%d', N));
            
            %   - mean of samples
            DagNNViz.plot_populationmean(...
                subplot(rows, cols, indexes2(4)), ...
                x ...
            ); 
        end
        
        function plot_all(x, red_index)
            % Plot all samples in square grid
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data {x1, x2, ...}
            % - red_index: int (default = 0)
            %   index of 'red' sample
            
            DagNNViz.print_title('Plot All');
            
            % default values
            if nargin < 2
                red_index = 0;
            end
            
            % figure
            DagNNViz.figure('All');
            
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
            DagNNViz.hideticks();
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
                DagNNViz.hideticks();
                
                % red sample
                if i == red_index
                   set(h, 'Color', 'red'); 
                end
            end

            DagNNViz.suptitle(sprintf('%d Samples', N));
        end
        
        % todo: refactor to `plot_all`
        function plot_filter_history(x, red_index)
            % Plot all samples in square grid
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data
            % - red_index: int (default = 0)
            %   index of 'red' sample
            
            DagNNViz.print_title('Plot Filter History');
            
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
            DagNNViz.hideticks();
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
                DagNNViz.hideticks();
                
                % red sample
                if i == red_index
                   set(h, 'Color', 'red'); 
                end
            end
            DagNNViz.suptitle(sprintf('%d Samples', N));
        end
        
        function plot_filter_initial_best(x, red_index, dt_sec)
            % Plot `initial` and `best` samples
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input data. x{1} is `initial` and x{red_index} is `best`
            % - red_index: int
            %   index of 'red' sample (`best` one)
            % - dt_sect: double
            %   time resolution in second
            
            % figure
            DagNNViz.figure('Filter - Initial & Best');
        
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
            DagNNViz.plot(...
                time, ...
                initial, ...
                'blue', ...
                'Initial Value', ...
                'Time (s)', ...
                '' ...
            );
            % todo: use `axis('tight')`
            % axis('tight');
            
            % - best
            best = x{red_index};
            subplot(rows, cols, 2);
            time = (0 : length(best) - 1) * dt_sec;
            DagNNViz.plot(...
                time, ...
                best, ...
                'red', ...
                'Min Validation Cost', ...
                'Time (s)', ...
                '' ...
            );
        end
        
        function plot_db_all(db, output_dir, small_db_size)
            % Plot all input/output samples in square grid
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   Input database
            % - output_dir: char vector
            %   Path of output directory
            % - small_db_size: int (default = 50)
            %   Select first samples from db
            
            DagNNViz.print_title('Plot DB All');
            
            % figure
            DagNNViz.figure('DB All');
        
            % number of samples
            if ~exist('small_db_size', 'var')
                small_db_size = min([50, length(db.x), length(db.y)]);
            end
            N = small_db_size;
            N2 = 2 * N;
            
            % subplot grid
            % - rows
            rows = ceil(sqrt(N2));
            % - cols
            cols = rows;
            % - cols must be even
            if mod(cols, 2) == 1
                cols = cols + 1;
            end
            
            % plot
            i = 1;
            % first input/output pair
            fontsize = 7;
            % - sample index
            j = floor((i + 1) / 2);
            % - input
            %   - print progress
            fprintf('Sample %d / %d\n', i, N2);
            subplot(rows, cols, i);
            plot(db.x{j}, 'Color', 'blue');
            DagNNViz.title('Stimulus', 'FontSize', fontsize + 2);
            xlabel('Time (s)', 'FontSize', fontsize);
            ylabel('Intensity', 'FontSize', fontsize);
            DagNNViz.hideticks();
            % - output
            %   - print progress
            fprintf('Sample %d / %d\n', i + 1, N2);
            
            subplot(rows, cols, i + 1);
            plot(db.y{j}, 'Color', 'red');
            DagNNViz.title('Response', 'FontSize', fontsize + 2);
            xlabel('Time (s)', 'FontSize', fontsize);
            ylabel('Rate (Hz)', 'FontSize', fontsize);
            DagNNViz.hideticks();
            % - other samples
            for i = 3:2:N2
                % - sample index
                j = floor((i + 1) / 2);
                
                % - input
                %   - print progress
                fprintf('Sample %d / %d\n', i, N2);
                
                subplot(rows, cols, i);
                plot(db.x{j}, 'Color', 'blue');
                DagNNViz.hideticks();
            
                % - output
                %   - print progress
                fprintf('Sample %d / %d\n', i + 1, N2);

                subplot(rows, cols, i + 1);
                plot(db.y{j}, 'Color', 'red');
                DagNNViz.hideticks();
            end
            % super-title
            DagNNViz.suptitle(...
                sprintf(...
                    'First %d Samples of %d (Stimulous/Response) Pairs of Training Set', ...
                    N, ...
                    length(db.x) ...
                ) ...
            );
            % todo: write function `DagNNViz.saveas`
            % save
            DagNNViz.saveas(fullfile(output_dir, 'db_all'));
        end
        
        function plot_db_first(db, dt_sec, output_dir)
            % Plot first input/output sample
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   input database
            % - dt_sect: double
            %   time resolution in second
            % - output_dir: char vector
            %   path of output directory
            
            % figure
            DagNNViz.figure('DB - First Sample Pair');
        
            % subplot grid
            % - rows
            rows = 1;
            % - cols
            cols = 2;
            
            % first input/output pair
            % - input
            subplot(rows, cols, 1);
            time = (0 : length(db.x{1}) - 1) * dt_sec;
            DagNNViz.plot(...
                time, ...
                db.x{1}, ...
                'blue', ...
                'Stimulus', ...
                'Time (s)', ...
                'Intensity' ...
            );
            % - output
            subplot(rows, cols, 2);
            time = (0 : length(db.y{1}) - 1) * dt_sec;
            DagNNViz.plot(...
                time, ...
                db.y{1}, ...
                'red', ...
                'Stimulus', ...
                'Time (s)', ...
                'Rate (Hz)' ...
            );
            % super-title
            DagNNViz.suptitle(...
                sprintf('First Sample (Stimulous/Response) of Training Set') ...
            );
            % save
            DagNNViz.saveas(fullfile(output_dir, 'db_first'));
        end
        
        function plot_db_yhat_all(db, y_, small_db_size)
            % Plot all 'db.x', 'db.y' and 'y^' samples in
            % square grid
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   input database
            % - y_: cell array
            %   estimated outputs
            % - small_db_size: int (default = 50)
            %   Select first samples from db
            
            DagNNViz.print_title('Plot DB and Actual `y` All');
            
            % number of samples
            if ~exist('small_db_size', 'var')
                small_db_size = min([27, length(db.x), length(db.y), length(y_)]);
            end
            N = small_db_size;
            N3 = 3 * N;
            
            % subplot grid
            % - rows
            rows = ceil(sqrt(N3));
            % - cols
            cols = rows;
            % - cols (mod(cols, 3) must be 0)
            if mod(cols, 3) == 1
                cols = cols + 2;
            elseif mod(cols, 3) == 2
                cols = cols + 1;
            end
            
            % plot
            for i = 1:3:N3
                % - sample index
                j = floor((i + 2) / 3);
                % - input
                subplot(rows, cols, i);
                plot(db.x{j}, 'Color', 'blue');
                DagNNViz.hideticks();
            
                % - expected-output
                subplot(rows, cols, i + 1);
                plot(db.y{j}, 'Color', 'red');
                DagNNViz.hideticks();
            
                % - estimated-output
                subplot(rows, cols, i + 2);
                plot(y_{j}, 'Color', 'green');
                DagNNViz.hideticks();
            end
            DagNNViz.suptitle(sprintf('%d Samples', N));
        end
        
        function plot_bias(bak_dir, param_name, title_txt)
            % Plots history of `param_name` bias based on saved
            % epochs in `bak_dir` directory
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
            xlabel('Epoch');
            ylabel('Bias');
            
            DagNNViz.title(title_txt);
        end
        
        % todo: make methods('unused') and send methods like this one to it
        function save_video(x, filename, frame_rate)
            % Save data 'x' as a 'filename.mp4' vidoe file
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
            if ~exist('frame_rate', 'var')
                frame_rate = 15;
            end
            
            % open video writer
            vw = VideoWriter(filename, 'MPEG-4');
            vw.FrameRate = frame_rate;
            open(vw);
            
            % figure
            h = DagNNViz.figure('Video');
        
            % number of samples
            N = length(x);
            
            % delay
            delay = 1 / frame_rate;
            
            % make video
            ylimits = DagNNViz.get_ylimits(x);
            for i = 1 : N
                plot(x{i});
                ylim(ylimits);
                DagNNViz.title(sprintf('#%d / #%d', i, N));
                writeVideo(vw, getframe(h));
                
                pause(delay);
            end
            
            % close video writer
            close(vw);
        end
        
        function save_db_video(db, filename, frame_rate)
            % Save database 'db' as a 'filename.mp4' vidoe file
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
            if ~exist('frame_rate', 'var')
                frame_rate = 15;
            end
            
            % open video writer
            vw = VideoWriter(filename, 'MPEG-4');
            vw.FrameRate = frame_rate;
            open(vw);
            
            % figure
            h = DagNNViz.figure('Video');
        
            % number of samples
            N = min(length(db.x), length(db.y));
            
            % delay
            delay = 1 / frame_rate;
            
            % make video
            for i = 1 : N
                % - input
                subplot(121), plot(db.x{i}, 'Color', 'blue');
                DagNNViz.title(sprintf('Input (#%d / #%d)', i, N));
                
                % - output
                subplot(122), plot(db.y{i}, 'Color', 'red');
                DagNNViz.title(sprintf('Output (#%d / #%d)', i, N));
                
                % - frame
                writeVideo(vw, getframe(h));
                
                % - delay
                pause(delay);
            end
            
            % close video writer
            close(vw);
        end
        
        function save_db_yhat_video(db, y_, filename, frame_rate)
            % Save 'db.x', 'db.y', 'y^' as a
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
            if ~exist('frame_rate', 'var')
                frame_rate = 15;
            end
            
            % open video writer
            vw = VideoWriter(filename, 'MPEG-4');
            vw.FrameRate = frame_rate;
            open(vw);
            
            % figure
            h = DagNNViz.figure('Video');
        
            % number of samples
            N = min(length(db.x), length(db.y));
            
            % delay
            delay = 1 / frame_rate;
            
            % make video
            for i = 1 : N
                % - input
                subplot(131), plot(db.x{i}, 'Color', 'blue');
                DagNNViz.title(sprintf('Input (#%d / #%d)', i, N));
                
                % - expected-output
                subplot(132), plot(db.y{i}, 'Color', 'red');
                DagNNViz.title(sprintf('Expected-Output (#%d / #%d)', i, N));
                
                % - expected-output
                subplot(133), plot(y_{i}, 'Color', 'green');
                DagNNViz.title(sprintf('Estimated-Output (#%d / #%d)', i, N));
                
                % - frame
                writeVideo(vw, getframe(h));
                
                % - delay
                pause(delay);
            end
            
            % close video writer
            close(vw);
        end
        
        function save_frames(x, frames_dir)
            % Save data 'x' as a 'sample#.png' image files
            %
            % Parameters
            % ----------
            % - x: cell array
            %   Input data
            % - frames_dir: char vector
            %   Path of output directory for saving frames
            
            % directory for save frames
            if exist(frames_dir, 'dir')
                rmdir(frames_dir, 's');
            end
            mkdir(frames_dir);
            
            % figure
            h = DagNNViz.figure('Video');
        
            % number of samples
            N = length(x);
            
            % delay
            delay = 0.01;
            
            % save images
            for i = 1 : N
                plot(x{i});
                DagNNViz.title(sprintf('#%d / #%d', i, N));
                
%                 imwrite(...
%                     frame2im(getframe(h)), ...
%                     fullfile(frames_dir, [num2str(i), '.png']), ...
%                     'png' ...
%                 );
            
                saveas(...
                    h, ...
                    fullfile(frames_dir, [num2str(i), '.png']), ...
                    'png' ...
                );
                
                pause(delay);
            end
        end
        
        function save_db_frames(db, frames_dir)
            % Save database 'db' as a 'sample#.png' image files
            %
            % Parameters
            % ----------
            % - db: struct('x', cell array, 'y', cell array)
            %   Input database
            % - frames_dir: char vector
            %   Path of output directory for saving frames
            
            % directory for save frames
            if exist(frames_dir, 'dir')
                rmdir(frames_dir, 's');
            end
            mkdir(frames_dir);
            
            % figure
            h = DagNNViz.figure('Video');
        
            % number of samples
            N = min(length(db.x), length(db.y));
            
            % delay
            delay = 0.01;
            
            % save images
            for i = 1 : N
                % - input
                subplot(121), plot(db.x{i}, 'Color', 'blue');
                DagNNViz.title(sprintf('Input (#%d / #%d)', i, N));
                
                % - output
                subplot(122), plot(db.y{i}, 'Color', 'red');
                DagNNViz.title(sprintf('Output (#%d / #%d)', i, N));
                
                % - save image to file
                saveas(...
                    h, ...
                    fullfile(frames_dir, [num2str(i), '.png']), ...
                    'png' ...
                );
                
                % - pause
                pause(delay);
            end
        end
        
        function param_history = get_param_history(bak_dir, param_name)
            % Get history of a `param_name` prameter 
            % based on saved epochs in `bak_dir` directory
            %
            % Parameters
            % ----------
            % - bak_dir: char vector
            %   Path of directory of saved epochs
            % - param_name: char vector
            %   Name of target parameter
            %
            % Returns
            % -------
            % - param_history : cell array
            %   History of param values
            
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
            % Get ylimits that is suitable for all samples of
            % 'x' data
            %
            % Parameter
            % ---------
            % - x : cell array
            %   Input data
            %
            % Returns
            % -------
            % - ylimits : [double, double]
            %   Ylimtis of all samples of 'x'
            
            ylimits = [
                min(cellfun(@(s) min(s), x)), ...
                max(cellfun(@(s) max(s), x))
            ];
        end
        
        function save_estimated_outputs(props_filename)
            % Save estimated-outputs in 'bak_dir/y_.mat'
            %
            % Parameters
            % ----------
            % - props_filename: char vector
            %   Path of configuration json file
            
            % run 'vl_setupnn.m' file
            run('vl_setupnn.m');

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
            %Plot spike train
            %   Parameters
            %   ----------
            %   - spike_trains : double array
            %   - number_of_time_ticks: int (default = 2)
            %   - time_limits : [double, double] (default = [1, length of each trial]) 
            %       [min_time, max_time]

            % default parameters
            if ~exist('number_of_time_ticks', 'var')
                number_of_time_ticks = 2;
            end
            if ~exist('time_limits', 'var')
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
            % Get 'spk' data from saved 'experiment' files in
            % 'experiments_dir' directory
            %
            % Parameters
            % ----------
            % - experiments_dir: char vector
            %   Path of saved 'experiments' files
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
            spks(N) = struct('value', [], 'name', []);
            for i = 1 : N
                spks(i).value = getfield(...
                    load(fullfile(experimets_dir, ep_files{i})), ...
                    'spk' ...
                );
                spks(i).name = ep_files{i};
            end
        end
        
        function plot_spks(experimets_dir)
            % Plot 'spk' data from saved 'experiment' files in
            % 'experiments_dir' directory
            %
            % Parameters
            % ----------
            % - experiments_dir: char vector
            %   Path of saved 'experiments' files
            
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
                DagNNViz.title(...
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
            % Analyze parameter name
            %
            % Parameters
            % ----------
            % - param_name: char vector
            %   Name of parameter
            %
            % Returns
            % -------
            % - param: struct('is_bias', boolean, 'title', char vector)
            %   Parameter info such as `is_bias` and `title`
            titles = struct(...
                'B', 'Bipolar', ...
                'A', 'Amacrine', ...
                'G', 'Ganglion' ...
            );
        
            param.is_bias = (param_name(1) == 'b');
            param.title = titles.(param_name(3));
        end
        
        function plot_params(param_names, bak_dir, output_dir, number_of_epochs, dt_sec)
            % Plot and save parameters in 'params.mat' file
            %
            % Parameters
            % ----------
            % - bak_dir: char vector
            %   Path of directory of saved epochs
            % - output_dir: char vector
            %   Path of output directory
            % - number_of_epochs: int
            %   Number of epochs
            % - dt_sect: double
            %   Time resolution in second
            
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
                
                if isempty(param.value)
                    continue
                end
                
                % - resize param.values
                param.value = param.value(1 : number_of_epochs);
                
                % new figure
                DagNNViz.figure('Parameters');
                
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
                    DagNNViz.title(sprintf('%s (Bias with Min Validation Cost is Red)', param.title));
                    xlabel('Epoch');
                    ylabel('Bias');
                    
                    % ticks
                    % - x
                    %todo: writ `threeticks` method
                    set(gca, ...
                        'XTick', ...
                        unique([...
                            0, ...
                            index_min_val_cost - 1, ...
                            number_of_epochs ...
                        ]) ...
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
                    DagNNViz.saveas(fullfile(...
                        output_dir, ...
                        ['bias_', lower(param.title)] ...
                    ));
                
                % if parameter is a filter
                else
                    % - all
                    DagNNViz.plot_filter_history(param.value, index_min_val_cost);
                    box('off');
                    DagNNViz.suptitle(...
                        sprintf(...
                            'Filter of %s for each Epoch of Training (Filter with Min Validation Cost is Red)', ...
                            param.title ...
                        ) ...
                    );
                
                    % save
                    DagNNViz.saveas(fullfile(...
                        output_dir, ...
                        ['filter_', lower(param.title), '_all'] ...
                    ));
                
                    % - initial & best
                    DagNNViz.plot_filter_initial_best(param.value, index_min_val_cost, dt_sec);
                    box('off');
                    DagNNViz.suptitle(...
                        sprintf(...
                            'Filter of %s for Epoch 0 & Epoch %d', ...
                            param.title, ...
                            index_min_val_cost - 1 ...
                        ) ...
                    );

                    % save
                    DagNNViz.saveas(fullfile(...
                        output_dir, ...
                        ['filter_', lower(param.title), '_initial_best'] ...
                    ));
                end
            end
        end
        
        function plot_stim(stim, dt_sec, output_dir)
            % Plot stimulous
            %
            % Parameters
            % ----------
            % - stim: double vector
            %   Stimulus
            % - dt_sect: double
            %   Time resolution in second
            % - output_dir: char vector
            %   Path of output directory
            
            time = (1 : length(stim)) * dt_sec;
            
            % figure
            DagNNViz.figure('STIM');
            % plot
            plot(time, stim);
            % - title
            DagNNViz.title('Stimulus');
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
            DagNNViz.saveas(fullfile(output_dir, 'stim'));
        end
        
        function plot_resp(resp, dt_sec, output_dir)
            % Plot response
            %
            % Parameters
            % ----------
            % - stim: double vector
            %   Stimulus
            % - dt_sect: double
            %   Time resolution in second
            % - output_dir: char vector
            %   Path of output directory
            
            time = (1 : length(resp)) * dt_sec;
            
            % figure
            DagNNViz.figure('RESP');
            % plot
            plot(time, resp);
            % - title
            DagNNViz.title('PSTH');
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
            DagNNViz.saveas(fullfile(output_dir, 'resp'));
        end
        
        function plot_noisy_params(params_path, noisy_params_path, output_dir, snr, dt_sec)
            % Plot noisy params with target ones
            %
            % Parameters
            % ----------
            % - params_path: char vector
            %   Path of noiseless `params` file
            % - noisy_params_path: char vector
            %   Path of noisy `params` file
            % - output_dir: char vector
            %   Path of output directory
            % - snr: double
            %   Signal-to-noise ratio per sample, in dB
            % - dt_sec: double
            %   time resolution in seconds
            
            if ~exist('dt_sec', 'var')
                dt_sec = Neda.dt_sec;
            end
            
            % params
            % - noisless
            params = load(params_path);
            % - noisy
            noisy_params = load(noisy_params_path);

            fields = fieldnames(params);
            for i = 1 : length(fields)
                param = DagNNViz.analyze_param_name(fields{i});
                
                if param.is_bias
                    continue
                end
                
                % figure
                DagNNViz.figure('Noisy Parameters');
            
                % noisless/noisy filter
                % - noisless
                noisless = params.(fields{i});
                time = (0 : length(noisless) - 1) * dt_sec;
                plot(time, noisless, 'Color', 'blue');
                
                hold('on');
                
                % - noisy
                noisy = noisy_params.(fields{i});
                plot(time, noisy, 'Color', 'red');
                
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
                    'YTick', ...
                    unique([...
                        round(min(min(noisless), min(noisy)), round_digits), ...
                        round(max(max(noisless), max(noisy)), round_digits) ...
                    ]) ...
                );
                %   - grid
                grid('on');
                box('off');
                
                 % legend
                legend(...
                    'Noisless', ...
                    sprintf('Noisy (SNR %0.2f dB)', snr) ...
                );

                % save
                DagNNViz.saveas(fullfile(...
                    output_dir, ...
                    [lower(param.title), '_filter_noisy_noiseless']...
                ));
            end            
        end
        
        % todo: move to another `lib` or `methods group`
        function rms_db(db_path)
            % Compute the `root mean square` of given `data-base`
            %
            % Parameters
            % ----------
            % - db_path: char vector
            %   Path of database
            
            % load `db`
            db = load(db_path);
            % rms(`db.y`)
            rms_y = cellfun(@rms, db.y);
            % print `mean` and `std`
            fprintf('rms(db.y) = %d (%d)\n', mean(rms_y), std(rms_y));
        end
        
        function plot_data()
            % Plot data
            
            % parameters
            % - path of data directory
            data_dir = DagNNViz.data_dir;
            % - time resolution (sec)
            dt_sec = Neda.dt_sec;

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
            DagNNViz.plot_stim(stim, dt_sec, output_dir);
            % - resp
            resp = data.resp;
            DagNNViz.plot_resp(resp, dt_sec, output_dir);
            
            % db
            % - all
            db = load(fullfile(data_dir, 'db.mat'));
            small_db_size = 50;
            DagNNViz.plot_db_all(...
                db, ...
                output_dir, ...
                small_db_size ...
            );
            % - first
            DagNNViz.plot_db_first(...
                db, ...
                dt_sec, ...
                output_dir ...
            );
            
        end
        
        function plot_costs(costs, output_dir)
            % Plot 'costs' over time
            %
            % Parameters
            % ----------
            % - costs: ?
            %   
            % - output_dir: char vector
            %   Path of output directory
            
            epochs = 1:length(costs.train);
            % start epochs from zero (0, 1, 2, ...)
            epochs = epochs - 1;
            
            DagNNViz.figure('CNN - Costs [Training, Validation, Test]');
            
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
            DagNNViz.title(...
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
            DagNNViz.saveas(fullfile(output_dir, 'error'));
        end
        
        function plot_results(props_filename)
            % Plot resutls
            %
            % Parameters
            % ----------
            % - props_filename: char vector
            %   Path of `properties`

            % parameters
            % - time resolution
            dt_sec = Neda.dt_sec;
            
            % main
            % todo: wow! its better to use DagNNViz.print_title()
            DagNNTrainer.print_dashline();
            fprintf('%s\n', props_filename);
            DagNNTrainer.print_dashline();
            % props
            props = jsondecode(fileread(props_filename));
            % 'bak' dir
            bak_dir = props.data.bak_dir;

            % output dir
            % - path
            output_dir = fullfile(bak_dir, 'images');
            % - make if doesn't exist
            if ~exist(output_dir, 'dir')
                mkdir(output_dir);
            end

            % costs
            % - make
            costs = load(fullfile(bak_dir, 'costs.mat'));
            % - plot
            DagNNViz.plot_costs(costs, output_dir);

            % params
            DagNNViz.plot_params(...
                {props.net.params.name}, ...
                bak_dir, ...
                output_dir, ...
                props.learning.number_of_epochs + 1, ...
                dt_sec ...
            );
        
            % db
            % - all
            db = load(props.data.db_filename);
            small_db_size = 50;
            DagNNViz.plot_db_all(...
                db, ...
                output_dir, ...
                small_db_size ...
            );
            % - first
            DagNNViz.plot_db_first(...
                db, ...
                dt_sec, ...
                output_dir ...
            );
        end
    end
end
