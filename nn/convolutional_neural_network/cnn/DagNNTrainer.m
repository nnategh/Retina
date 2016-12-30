classdef DagNNTrainer < handle
    %DAGNNTRAINER implements a trainer for DagNN
    
    properties
        % independant
        x                               % cell array of input data.
        y                               % cell array of output data.
        
        space_value_limits              % for kernel designer. 2d matrix, columns (ymin, ymax)
        time_value_limits               % for kernel designer. 2d matrix, columns (ymin, ymax)
        
        resize_method                   % 'crop', 'nearset', 'bilinear' and 'bicubic'
        
        % dependant
        data                            % structure of 'train', 'validation' and 'test'
        train_costs                     % train cost for each epoch
        val_costs                       % val cost for each epoch
        test_costs                      % test cost for each epoch
        index_min_val_cost              % epoch number that network has minimum cost on validation data
        
        props                           % properties of cnn
        net                             % DagNN
    end
    
    methods
        function obj = DagNNTrainer(filename)
            % props
            obj.init_props(filename);
            
            % resize method
            obj.resize_method = 'crop';
        end
        
        function init_props(obj, filename)
            % decode json
            obj.props = jsondecode(fileread(filename));
            
            % refine
            % - input
            obj.props.input.size = obj.props.input.size';
            
            % - output
            obj.props.output.size = obj.props.output.size';
            
            % - params
            for i = 1:length(obj.props.params)
                obj.props.params(i).size = obj.props.params(i).size';
            end
            
            % - layers
            for i = 1:length(obj.props.layers)
                % inputs
                if isempty(obj.props.layers(i).inputs)
                    obj.props.layers(i).inputs = {};
                else
                    obj.props.layers(i).inputs = obj.props.layers(i).inputs';
                end
                % outputs
                if isempty(obj.props.layers(i).outputs)
                    obj.props.layers(i).outputs = {};
                else
                    obj.props.layers(i).outputs = obj.props.layers(i).outputs';
                end
                
                % params
                if isempty(obj.props.layers(i).params)
                    obj.props.layers(i).params = {};
                else
                    obj.props.layers(i).params = obj.props.layers(i).params';
                end
            end
        end
        
        function init_net(obj)
            % blocks
            blocks = struct(...
                'conv', @dagnn.Conv, ...
                'relu', @dagnn.ReLU, ...
                'quadcost', @dagnn.QuadraticCost ...
            );
            
            % define object
            obj.net = dagnn.DagNN();
            
            % add layers
            layers = obj.props.layers;
            for i = 1:length(layers)
                obj.net.addLayer(...
                    layers(i).name, blocks.(layers(i).type)(), ...
                    layers(i).inputs, ...
                    layers(i).outputs, ...
                    layers(i).params ...
                );
            end
        end
        
        function init_params(obj, generator)
            % defualt generator
            if nargin < 2
                generator = @rand;
            end
            
            % initialize obj.net.params
            params = obj.props.params;
            for i = 1:length(params)
                obj.net.params(obj.net.getParamIndex(params(i).name)).value = ...
                    generator(params(i).size);
            end
        end
        
        % todo: complete the method
        function init_input_size(obj)
           return
        end
        
        % todo: refactor resize_input, resize_x and resize_y
        function x = resize_input(obj, x)
            do_crop = strcmp(obj.resize_method, 'crop');
            m = obj.input_size(1);
            n = obj.input_size(2);
            p = obj.input_size(3);
            
            for i = 1:length(x)
                [M, N, P] = size(x{i});
                
                if P > p
                    x{i} = x{i}(:, :, 1:p);
                elseif P < p
                    % concatenate leading zero frames
                    x{i} = cat(3, zeros(M, N, p - P), x{i});
                end
                
                if isequal([M, N], obj.input_size)
                    continue;
                end
                
                % todo: if (M, N) < (m, n) -> resize bigger
                if do_crop
                    m1 = floor((M - m) / 2) + 1;
                    m2 = m1 + m - 1;
                    n1 = floor((N - n) / 2) + 1;
                    n2 = n1 + n - 1;
                    x{i} = x{i}(m1:m2, n1:n2, :);
                else
                    x{i} = imresize(x{i}, obj.input_size, obj.resize_method);
                end
            end
        end
        
        % todo
        function resize_x(obj)
            do_crop = strcmp(obj.resize_method, 'crop');
            m = obj.input_size(1);
            n = obj.input_size(2);
            p = obj.input_size(3);
            
            for i = 1:length(obj.x)
                [M, N, P] = size(obj.x{i});
                
                if P > p
                    obj.x{i} = obj.x{i}(:, :, 1:p);
                elseif P < p
                    % concatenate leading zero frames
                    obj.x{i} = cat(3, zeros(M, N, p - P), obj.x{i});
                end
                
                if isequal([M, N], obj.input_size)
                    continue;
                end
                
                if do_crop
                    m1 = floor((M - m) / 2) + 1;
                    m2 = m1 + m - 1;
                    n1 = floor((N - n) / 2) + 1;
                    n2 = n1 + n - 1;
                    obj.x{i} = obj.x{i}(m1:m2, n1:n2, :);
                else
                    obj.x{i} = imresize(obj.x{i}, obj.input_size, obj.resize_method);
                end
            end
        end
        
        % todo
        function resize_y(obj)
            do_crop = strcmp(obj.resize_method, 'crop');
            m = obj.output_size(1);
            n = obj.output_size(2);
            p = obj.output_size(3);
            
            for i = 1:length(obj.y)
                [M, N, P] = size(obj.y{i});
                
                if P > p
                    obj.y{i} = obj.y{i}(:, :, 1:p);
                elseif P < p
                    % concatenate leading zero frames
                    obj.y{i} = cat(3, zeros(M, N, p - P), obj.y{i});
                end
                
                if isequal([M, N], obj.output_size)
                    continue;
                end
                
                if do_crop
                    m1 = floor((M - m) / 2) + 1;
                    m2 = m1 + m - 1;
                    n1 = floor((N - n) / 2) + 1;
                    n2 = n1 + n - 1;
                    obj.y{i} = obj.y{i}(m1:m2, n1:n2, :);
                else
                    obj.y{i} = imresize(obj.y{i}, obj.output_size, obj.resize_method);
                end
            end
        end
        
        % todo
        function add_noise_to_w(obj, sigma)
            for l = 1:obj.L
                obj.w{l} = obj.w{l} + sigma * randn(size(obj.w{l}));
            end
        end
        
        function divide_data(obj)
            size_input = obj.props.input.size;
            size_output = obj.props.output.size;
            if size_input(end) ~= size_output(end)
                error('Number of inputs and outputs are not the same.');
            end
            
            n = size_input(end);
            train_ratio = obj.props.train_val_test_ratios(1);
            val_ratio = obj.props.train_val_test_ratios(2);
            
            indexes = randperm(n);
            train_index = floor(train_ratio * n);
            val_index = floor((train_ratio + val_ratio) * n);
            test_index = n;
            
            obj.data.train.x = obj.x(indexes(1:train_index));
            obj.data.train.y = obj.y(indexes(1:train_index));
            
            obj.data.val.x = obj.x(indexes(train_index + 1:val_index));
            obj.data.val.y = obj.y(indexes(train_index + 1:val_index));
            
            obj.data.test.x = obj.x(indexes(val_index + 1:test_index));
            obj.data.test.y = obj.y(indexes(val_index + 1:test_index));
        end
        
        function make_data(obj, generator)
            % default generator
            if nargin < 2
                generator = @rand;
            end
            
            % inputs
            N = obj.props.number_of_samples;
            obj.x = cell(N, 1);
            for i = 1:N
                obj.x{i} = generator(obj.props.input.size);
            end
            
            % outputs
            obj.y = obj.out(obj.x);
        end
        
        function init(obj)
            % net
            obj.init_net();
            
            % params
            obj.init_params();
            
            % data
            obj.divide_data();
            
            % train costs
            obj.train_costs(1) = obj.get_train_cost();

            % val costs
            obj.val_costs(1) = obj.get_val_cost();
            
            % test costs
            obj.test_costs(1) = obj.get_test_cost();
            
            % index_min_cost_validation
            obj.index_min_val_cost = 1;
        end
        
        function y = out(obj, x)
            n = length(x);
            y = cell(n, 1);
            for i = 1:n
                obj.net.eval(...
                    {obj.props.input.name, x{i}} ...
                );

                y{i} = obj.net.vars(...
                    obj.net.getVarIndex(obj.props.output.name) ...
                ).value;
            end
        end
        
        function draw_net(obj, face_alpha)
            if nargin == 1
                face_alpha = 0.8;
            end
            
            scales = obj.input_size;
            for i = 1:obj.L
                scales(end + 1, :) = obj.kernel_sizes(i, :);
                scales(end + 1, :) = obj.layers(i, :);
            end

            face_colors = zeros(size(scales, 1), 3);
            face_colors(1, :) = [1, 0, 0]; % x -> red
            face_colors(2:2:end, :) = repmat([0, 1, 0], obj.L, 1); % kernels -> green
            face_colors(3:2:end, :) = repmat([0, 0, 1], obj.L, 1); % layers -> blue
            
            CNN.draw_cubes(scales, face_colors, face_alpha);
        end
        
        function plot_kernel(obj, l)
            kd = KernelDesigner.load(obj.kernel_paths{l});
            kd.space_df.run();
            kd.time_df.run();
        end
        
        function plot_total_cost_history(obj)
            epochs = 1:length(obj.history);
            epochs = epochs - 1; % start from zero (0, 1, 2, ...)
            total_costs = [obj.history.total_cost];
            
            figure('Name', 'Neural Network - Error', 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0.25, 0.25, 0.5, 0.5]);
            
            % train
            plot(epochs, total_costs(1, :), 'LineWidth', 2, 'Color', 'blue');
            set(gca, 'YScale', 'log');
            hold('on');
            % validation
            plot(epochs, total_costs(2, :), 'LineWidth', 2, 'Color', 'green');
            % test
            plot(epochs, total_costs(3, :), 'LineWidth', 2, 'Color', 'red');
            
            % minimum validation error
            % --circle
            circle_x = obj.index_min_cost_validation - 1;
            circle_y = total_costs(2, obj.index_min_cost_validation);
            dark_green = [0.1, 0.8, 0.1];
            scatter(circle_x, circle_y, ...
                'MarkerEdgeColor', dark_green, ...
                'SizeData', 300, ...
                'LineWidth', 2 ...
            );
            
            % --cross lines
            h_ax = gca;
            % ----horizontal line
            line(...
                h_ax.XLim, ...
                [circle_y, circle_y], ...
                'Color', dark_green, ...
                'LineStyle', ':', ...
                'LineWidth', 1.5 ...
            );
            % ----vertical line
            line(...
                [circle_x, circle_x], ...
                h_ax.YLim, ...
                'Color', dark_green, ...
                'LineStyle', ':', ...
                'LineWidth', 1.5 ...
            );
            
            hold('off');
            
            xlabel('Epoch');
            ylabel('Mean Squared Error (mse)');
            min_total_costs_based_validation = obj.history(obj.index_min_cost_validation).total_cost;
            
            title(...
                sprintf('Minimum Validation Error is %.3f at Epoch: %d', ...
                    min_total_costs_based_validation(2), ...
                    obj.index_min_cost_validation - 1 ...
                    ) ...
            );
        
            legend(...
                sprintf('Training (%.3f)', min_total_costs_based_validation(1)), ...
                sprintf('Validation (%.3f)', min_total_costs_based_validation(2)), ...
                sprintf('Test (%.3f)', min_total_costs_based_validation(3)), ...
                'Best' ...
            );
            
            grid('on');
            grid('minor');
        end
        
        %todo regression between two histograms
        function plot_all_regressions(obj)
            figure('Name', 'Neural Network - Regression', 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0.25, 0.25, 0.5, 0.5]);
            
            % train
            subplot(2, 2, 1);
            CNN.plot_regression(obj.data.train.y', obj.out(obj.data.train.x)', 'Training', 'blue');
            
            % validation
            subplot(2, 2, 2);
            CNN.plot_regression(obj.data.validation.y', obj.out(obj.data.validation.x)', 'Validation', 'green');
            
            % test
            subplot(2, 2, 3);
            CNN.plot_regression(obj.data.test.y', obj.out(obj.data.test.x)', 'Test', 'red');
            
            % all
            subplot(2, 2, 4);
            CNN.plot_regression(obj.y', obj.out(obj.x)', 'All', 'black');
        end
        
        %todo how to calculate error
        function plot_error_histogram(obj)
            all_errors              = obj.y                 -   obj.out(obj.x);
            train_errors            = obj.data.train.y      -   obj.out(obj.data.train.x);
            validation_errors       = obj.data.validation.y -   obj.out(obj.data.validation.x);
            test_errors             = obj.data.test.y       -   obj.out(obj.data.test.x);
            
            [N, edges] = histcounts(all_errors, 20);
            N_train = histcounts(train_errors, edges);
            N_validation = histcounts(validation_errors, edges);
            N_test = histcounts(test_errors, edges);
            
            % stacked bar plot
            figure('Name', 'Neural Network - Error Histogram', 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0.25, 0.25, 0.5, 0.5]);
            bin_centers = (edges(1:end - 1) + edges(2:end)) / 2;
            h = bar(...
                bin_centers, ...
                [N_train', N_validation', N_test'], ...
                'BarLayout', 'stacked' ...
            );
            h(1).FaceColor = 'blue';
            h(2).FaceColor = 'green';
            h(3).FaceColor = 'red';
            
            % zero line
            max_N = max(N);
            line([0, 0], [0, 1.1 * max_N], 'Color', [.8, .4, .2], 'LineWidth', 2);
            set(gca, 'XTick', bin_centers);
            axis('tight');
            
            % legends
            legend('Training', 'Validation', 'Test', 'Zero Error');
        end
        
        function cost = get_cost(obj, x, y)
            n = length(x);
            for i = 1:n
                obj.net.eval(...
                    {...
                        obj.props.input.name, x{i}, ...
                        obj.props.output.name, y{i} ...
                    } ...
                );

                cost = cost + obj.net.vars(...
                    obj.net.getVarIndex('cost') ...
                ).value;
            end
        end
        
        function train_cost = get_train_cost(obj)
            train_cost = ...
                obj.get_cost(obj.data.train.x, obj.data.train.y);
        end
        
        function val_cost = get_val_cost(obj)
            val_cost = ...
                obj.get_cost(obj.data.val.x, obj.data.val.y);
        end
        
        function test_cost = get_test_cost(obj)
            test_cost = ...
                obj.get_cost(obj.data.test.x, obj.data.test.y);
        end
        
        function run(obj)
            % init net
            obj.init();
            
            n = length(obj.data.train.x);
            batch_size = obj.props.batch_size - 1;
            for epoch = 1:obj.props.number_of_epochs
                % shuffle train data
                permuted_indexes = randperm(n);
                for i = 1:batch_size:n
                    indexes = permuted_indexes(i:i+batch_size);
                    % make batch data
                    input = ...
                        DagNNTrainer.cell_array_to_tensor(...
                            obj.data.train.x(indexes) ...
                        );

                    output = ...
                        DagNNTrainer.cell_array_to_tensor(...
                            obj.data.train.y(indexes) ...
                        );

                    % forwar, backward step
                    obj.net.eval(...
                        {...
                            obj.props.input.name, input, ...
                            obj.props.output.name, output
                        }, ...
                        {'cost', 1} ...
                    );

                    % update step
                    for param_index = 1:length(obj.net.params)
                        obj.net.params(param_index).value = ...
                            obj.net.params(param_index).value - ...
                            obj.props.learning_rate * obj.net.params(param_index).der;
                    end
                    
                end
                % costs
                % - train
                obj.train_costs(end + 1) = obj.get_train_cost();
                % - val
                obj.val_costs(end + 1) = obj.get_val_cost();
                % - test
                obj.test_costs(end + 1) = obj.get_test_cost();
                
                % no imporovement in number_of_val_fails steps
                if obj.val_costs(end) < obj.val_costs(obj.index_min_val_cost)
                    obj.index_min_val_cost = length(obj.val_costs);
                end
                
                if (length(obj.val_costs) - obj.index_min_val_cost) >= ...
                        obj.props.number_of_val_fails
                    break;
                end
                
%                 % print epoch number
%                 fprintf(repmat('\b', 1, length(progress_message)));
%                 progress_message = sprintf('Epoch: %d', epoch - 1);
%                 fprintf(progress_message);
                obj.save_net(sprintf('./epoch_%d', epoch));
            end
%             fprintf('\n');
            
            % todo: load best validation performance
        end
        
        function save_net(obj, filename)
            net_struct = obj.net.saveobj();
            save(filename, '-struct', 'net_struct') ;
            clear('net_struct');
        end
        
        function load_net(obj, filename)
            net_struct = load(filename) ;
            obj.net = dagnn.DagNN.loadobj(net_struct) ;
            clear(net_struct);
        end
        
        function save(obj, filename)
            save(filename, 'obj');
        end
    end
    
    methods (Static)
        function tensor = cell_array_to_tensor(cell_array)
            tensor_size = horzcat(...
                size(cell_array{1}), ...
                length(cell_array) ...
            );
        
            indexes = cell(1, length(tensor_size));
            for i = 1:length(tensor_size)
                indexes{i} = 1:tensor_size(i);
            end
            
            tensor = zeros(tensor_size);
            for i = 1:length(cell_array)
                indexes{end} = i;
                tensor(indexes{:}) = cell_array{i};
            end
        end
        
        function plot_regression(target, output, axes_title, color)
            scatter(target, output, 'MarkerEdgeColor', color);
            
            lsline();
            beta = regress(...
                output, ...
                [ones(size(target)), target] ...
            );
            
            title(sprintf('$\\bf{%s~(\\rho:%.2f)}$', axes_title, corr(target, output)), 'Interpreter', 'latex');
            
            xlabel('$Target$', 'Interpreter', 'latex');
            ylabel(sprintf('$o \\approx \\bf{%.2f}~t~+~\\bf{%.3f}$', beta(2), beta(1)), 'Interpreter', 'latex');
            
            legend('Data', 'Fit', 'Location', 'northwest');
            axis('square');
            
        end
        
        function v = make_input(folder_path, filename_extension)
            % default value for filename_extension is 'jpg'
            if nargin == 1
                filename_extension = 'jpg';
            end
            
            % read files
            files = dir([folder_path, '/*.', filename_extension]);
            
            % init v
            I = imread(fullfile(folder_path, files(1).name));
            [m, n] = size(I);
            p = length(files);
            v = zeros(m, n, p);
            
            % make v
            for i = 1:p
                I = imread(fullfile(folder_path, files(i).name));
                I = double(I);
                I = I / max(I(:));

                v(:, :, i) = I;
            end
        end
        
        function movie_3darray(v, delay)
            if nargin == 1
                delay = 0.1;
            end
            
            for i = 1:size(v, 3)
                imshow(v(:, :, i));
                pause(delay);
            end
        end
        
        function movie_slice_3darray(v, delay, edge_color)
            if nargin == 2
                edge_color = false;
            end
            
            if nargin == 1
                delay = 0.1;
            end
            
            [m, n, p] = size(v);
            
            v = permute(v, [2, 3, 1]);
            v = flip(v, 3);
            v = flip(v, 1);

            for i = 1:p
                h = slice(v, i, [], []);
                if ~edge_color
                    set(h, 'EdgeColor', 'none');
                end
                
                xlabel('Frames');
                axis([1, p, 1, n, 1, m]);
                set(gca, ...
                    'XTick', [1, p], 'XTickLabel', [1, p], ...
                    'YTick', [1, n], 'YTickLabel', [n, 1], ...
                    'ZTick', [1, m], 'ZTickLabel', [m, 1] ...
                );
                colormap('gray');
                
                pause(delay);
            end
        end
        
        function plot_slice_3darray(v, number_of_slices, edge_color)
            [m, n, p] = size(v);
            
            if nargin < 2 || number_of_slices > p
                number_of_slices = p;
            end
            
            if nargin < 3
                edge_color = false;
            end
            
            v = permute(v, [2, 3, 1]);
            v = flip(v, 3);
            v = flip(v, 1);
            
            dx = (p - 1) / (number_of_slices - 1);
            sx = 1:dx:p;
            sx = floor(sx);

            h = slice(v, sx, [], [], 'cubic');
            if ~edge_color
                set(h, 'EdgeColor', 'none');
            end
            
            xlabel('Frames');
            axis([1, p, 1, n, 1, m]);
            set(gca, ...
                'XTick', [1, p], 'XTickLabel', [1, p], ...
                'YTick', [1, n], 'YTickLabel', [n, 1], ...
                'ZTick', [1, m], 'ZTickLabel', [m, 1] ...
            );
            colormap('gray');
        end
        
        function draw_cube( scale, translate, face_color, face_alpha, edge_color, line_width )
            %Draw Cubic

            % default parameters
            switch nargin
                case 2
                    face_color = 'blue';
                    face_alpha = 0.8;
                    edge_color = 'black';
                    line_width = 2;
                case 3
                    face_alpha = 0.8;
                    edge_color = 'black';
                    line_width = 2;
                case 4
                    edge_color = 'black';
                    line_width = 2;
                case 5
                    line_width = 2;
            end

            %
            vertices = [
                0 0 0
                0 0 1
                0 1 0
                0 1 1
                1 0 0
                1 0 1
                1 1 0
                1 1 1
            ];

            % vertices = vertices .* repmat(scale, size(vertices, 1), 1);
            % vertices = vertices + repmat(translate, size(vertices, 1), 1);

            vertices = vertices * diag(scale) + translate;

            faces = [
                1 2 4 3
                5 6 8 7
                1 5 6 2
                3 7 8 4
                1 5 7 3
                2 6 8 4
            ];

            patch(...
                'Faces', faces, ...
                'Vertices', vertices, ...
                'FaceColor', face_color, ...
                'FaceAlpha', face_alpha, ...
                'EdgeColor', edge_color, ...
                'LineWidth', line_width ...
            );

            axis('equal');
            view(3);
        end
        
        function draw_cubes( scales, face_colors, face_alpha )
            %Draw Cubes

            % parameters
            font_size = 12;
            font_weight = 'bold';
            x_text = 5;

            %
            figure('Name', 'Cubes', 'NumberTitle', 'off', 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);
            hold('on');

            M = scales(1, 1);
            N = scales(1, 2);
            scales = flip(scales, 1);
            face_colors = flip(face_colors, 1);
            scales = scales(:, [3, 2, 1]);

            translate = [0, 0, 0];
            for i = 1:size(scales, 1)
                scale = scales(i, :);
                center_translate = ...
                    translate + ...
                    [0, floor((N - scale(2)) / 2), floor((M - scale(3)) / 2)];
                CNN.draw_cube(scale, center_translate, face_colors(i, :), face_alpha);
                text(...
                    -x_text, (i - 0.5) * N, 0, ...
                    sprintf('%dx%dx%d', scale(3), scale(2), scale(1)), ...
                    'FontSize', font_size, ...
                    'FontWeight', font_weight, ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'middle' ...
                );
                translate = translate + [0, N, 0];
            end

            axis('equal');
            axis('off');
            view(3);

            hold('off');
        end
        
        function obj = load(filename)
            obj = load(filename);
            obj = obj.(char(fieldnames(obj)));
        end
        
        function x = normalize(x)
            m = size(x, 1);
            n = size(x, 2);
            for i = 1:m
                for j = 1:n
                    max_ = max(abs(x(i, j, :)));
                    if max_ ~= 0
                        x(i, j, :) = x(i, j, :) / max_;
                    end
                end
            end
        end
        
        function matrix = flipn(matrix)
            %FLIPN flip on all dimensions
            for dim = 1:ndims(matrix)
                matrix = flip(matrix, dim);
            end
        end
    end
    
end