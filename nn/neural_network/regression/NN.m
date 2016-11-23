classdef NN < handle
    %Neural Network
    
    properties
        x                               % input data, matrix of column vectors
        y                               % ouput data, matrix of column vectors
        layers                          % dimenstion of each layer except input layer
         
        C                               % cost function
        C_                              % derivative of cost function
        s                               % activation function
        s_                              % derivative of activation function
        sL                              % activation function of last layer
        sL_                             % derivative of activation function of last layer
        
        L                               % number of layers
        w                               % w{l}(j, k) weight between j'th neuron of l'th layer and k'th neuron of (l-1)'th layer
        b                               % b{l}(j) bias of j'th neuron in l'th layer
        z                               % z{l}(j) weighted sum of j'th neuron in l'th layer
        a                               % a{l}(j) activation of j'th neuron in l'th layer
        d                               % d{l}(j) error of j'th neuron in l'th layer
        
        number_of_epochs                %   
        learning_rate                   %
        total_cost                      %
        history                         % history for each epoch
        
        divide_param                    %
        data                            %
        number_of_validations_faild     %
        index_min_cost_validation       %
    end
    
    methods
        function obj = NN(x, y, layers)
            obj.x = x;
            obj.y = y;
            obj.layers = layers;
            
            obj.C = @NN.quadratic_cost_function;
            obj.C_ = @NN.diff_quadratic_cost_function;
            obj.s = @NN.logistic_activation_function;
            obj.s_ = @NN.diff_logistic_activation_function;
            obj.sL = @NN.line_activation_function;
            obj.sL_ = @NN.diff_line_activation_function;
            
            obj.L = length(obj.layers);
            
            obj.number_of_epochs = 100;
            obj.learning_rate = 0.01;
            obj.history = [];
            
            obj.divide_param.train_ratio = 70/100;
            obj.divide_param.validation_ratio = 15/100;
            obj.divide_param.test_ratio = 15/100;
            obj.data = [];
            obj.number_of_validations_faild = 6;
            obj.index_min_cost_validation = [];
        end
        
        function init_w(obj)
            obj.w = cell(obj.L, 1);
            obj.w{1} = randn(obj.layers(1), size(obj.x, 1));
            for l = 2:obj.L
                obj.w{l} = randn(obj.layers(l), obj.layers(l - 1));
            end
        end
        
        function init_b(obj)
            obj.b = cell(obj.L, 1);
            for l = 1:obj.L
                obj.b{l} = zeros(obj.layers(l), 1);
            end
        end
        
        function divide_data(obj)
            n = size(obj.x, 2);
            indexes = randperm(n);
            train_index = floor(obj.divide_param.train_ratio * n);
            validation_index = floor((obj.divide_param.train_ratio + obj.divide_param.validation_ratio) * n);
            test_index = n;
            
            obj.data.train.x = obj.x(:, indexes(1:train_index));
            obj.data.train.y = obj.y(:, indexes(1:train_index));
            
            obj.data.validation.x = obj.x(:, indexes(train_index + 1:validation_index));
            obj.data.validation.y = obj.y(:, indexes(train_index + 1:validation_index));
            
            obj.data.test.x = obj.x(:, indexes(validation_index + 1:test_index));
            obj.data.test.y = obj.y(:, indexes(validation_index + 1:test_index));
        end
        
        function init(obj)
            % w
            obj.init_w();
            % b
            obj.init_b();
            % z
            obj.z = cell(obj.L, 1);
            % a
            obj.a = cell(obj.L, 1);
            % d
            obj.d = cell(obj.L, 1);
            
            % divide data
            obj.divide_data();
        end
        
        function forward_step(obj, x)
            % z, a
            % --first layer
            obj.z{1} = obj.w{1} * x + obj.b{1};
            obj.a{1} = obj.s(obj.z{1});

            % --
            for l = 2:(obj.L - 1)
                obj.z{l} = obj.w{l} * obj.a{l - 1} + obj.b{l};
                obj.a{l} = obj.s(obj.z{l});
            end

            % --last layer
            obj.z{obj.L} = obj.w{obj.L} * obj.a{obj.L - 1} + obj.b{obj.L};
            obj.a{obj.L} = obj.sL(obj.z{obj.L});
        end
        
        function backward_step(obj, y)
            % d
            % --last layer
            obj.d{obj.L} = obj.C_(y, obj.a{obj.L}) .* obj.sL_(obj.z{obj.L});
            % --
            for l = (obj.L - 1):-1:1
                obj.d{l} = (obj.w{l+1}' * obj.d{l+1}) .* obj.s_(obj.z{l});
            end
        end
        
        function update_step(obj, x)
            % w
            % --first layer
            obj.w{1} = obj.w{1} - ...
                (obj.learning_rate * (obj.d{1} * x'));
            
            % --
            for l = 2:obj.L
                obj.w{l} = obj.w{l} - ...
                    (obj.learning_rate * (obj.d{l} * obj.a{l-1}'));
            end
            
            % b
            for l = 1:obj.L
                obj.b{l} = obj.b{l} - ...
                    (obj.learning_rate * obj.d{l});
            end
        end
        
        function y = out(obj, x)
            y = [];
            for i = 1:size(x, 2)
                obj.forward_step(x(:, i));
                y(:, i) = obj.a{obj.L};
            end
        end
        
        function total_cost = get_total_cost(obj)
            total_cost = [];
            
            % train
            output = obj.out(obj.data.train.x);
            error = 0;
            n = size(output, 2);
            for i = 1:n
                error = error + obj.C(obj.data.train.y(:, i), output(:, i));
            end
            error = error / n;
            total_cost(end + 1) = error;
            
            % validation
            output = obj.out(obj.data.validation.x);
            error = 0;
            n = size(output, 2);
            for i = 1:n
                error = error + obj.C(obj.data.validation.y(:, i), output(:, i));
            end
            error = error / n;
            total_cost(end + 1) = error;
            
            % test
            output = obj.out(obj.data.test.x);
            error = 0;
            n = size(output, 2);
            for i = 1:n
                error = error + obj.C(obj.data.test.y(:, i), output(:, i));
            end
            error = error / n;
            total_cost(end + 1) = error;
            
            total_cost = total_cost';
        end
        
        function detailed_x = get_detaild_x(obj)
            min_x = min(obj.x);
            max_x = max(obj.x);
            detailed_x = linspace(min_x, max_x, 10 * size(obj.x, 2));
        end
        
        function plot_total_cost_history(obj)
            epochs = 1:length(obj.history);
            epochs = epochs - 1;
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
        
        function plot_all_regressions(obj)
            figure('Name', 'Neural Network - Regression', 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0.25, 0.25, 0.5, 0.5]);
            
            % train
            subplot(2, 2, 1);
            NN.plot_regression(obj.data.train.y', obj.out(obj.data.train.x)', 'Training', 'blue');
            
            % validation
            subplot(2, 2, 2);
            NN.plot_regression(obj.data.validation.y', obj.out(obj.data.validation.x)', 'Validation', 'green');
            
            % test
            subplot(2, 2, 3);
            NN.plot_regression(obj.data.test.y', obj.out(obj.data.test.x)', 'Test', 'red');
            
            % all
            subplot(2, 2, 4);
            NN.plot_regression(obj.y', obj.out(obj.x)', 'All', 'black');
        end
        
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
        
        function h = plot_fit(obj, figure_name)
            if size(obj.x, 1) > 1
                error('Just for one dimensional data!');
            end
            
            if nargin < 2
                figure_name = 'Neural Network - Approximation';
            end
            
            figure('Name', figure_name, 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0.25, 0.25, 0.5, 0.5]);
            
            % train
            scatter(obj.data.train.x, obj.data.train.y, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue')
            hold('on');
            % validation
            scatter(obj.data.validation.x, obj.data.validation.y, 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green')
            % test
            scatter(obj.data.test.x, obj.data.test.y, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red')
                        
            xlabel('Input');
            ylabel('Target');
            
            
            % fit
            detailed_x = obj.get_detaild_x();
            approximated_y = obj.out(detailed_x);
            
            h = plot(detailed_x, approximated_y, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 2);
            hold('off');
            drawnow();
            ylim('manual');
            title(...
                sprintf('Net: %s, Error: %s', ...
                    mat2str([size(obj.x, 1) obj.layers]), ...
                    mat2str(round(obj.history(obj.index_min_cost_validation).total_cost, 3)) ...
                ) ...
            );
            legend('Training', 'Validation', 'Test', 'Fit', 'Location', 'best');
        end
        
        function animate_fit_history(obj, delay)
            if nargin < 2
                delay = 0.1;
            end
            
            h = obj.plot_fit('Neural Network - History');
            
            % epoches
            detailed_x = obj.get_detaild_x();
            for epoch = 1:obj.index_min_cost_validation
                obj.w = obj.history(epoch).w;
                obj.b = obj.history(epoch).b;
                
                h.YData = obj.out(detailed_x);
                title(...
                    sprintf('Epoch: %d, Error: %s', ...
                        epoch - 1, ...
                        mat2str(round(obj.history(epoch).total_cost, 3)) ...
                    ) ...
                );
                
                pause(delay);
            end
        end
        
        function run(obj)
            obj.init();
            
            % 0 epoch
            obj.history(1).total_cost = obj.get_total_cost();
            obj.history(1).w = obj.w;
            obj.history(1).b = obj.b;
            
            obj.index_min_cost_validation = 1;
            n = size(obj.data.train.x, 2);
            for epoch = 2:(obj.number_of_epochs + 1)
                % forward, backward, update
                for i = 1:n
                    obj.forward_step(obj.data.train.x(:, i));
                    obj.backward_step(obj.data.train.y(:, i));
                    obj.update_step(obj.data.train.x(:, i));
                end
                % history
                obj.history(epoch).total_cost = obj.get_total_cost();
                obj.history(epoch).w = obj.w;
                obj.history(epoch).b = obj.b;
                
                % no imporovement in ? steps
                if obj.history(epoch).total_cost(2) < obj.history(obj.index_min_cost_validation).total_cost(2)
                    obj.index_min_cost_validation = epoch;
                end
                
                if (epoch - obj.index_min_cost_validation) >= obj.number_of_validations_faild
                    break;
                end
            end
            
            % best validation performance
            obj.w = obj.history(obj.index_min_cost_validation).w;
            obj.b = obj.history(obj.index_min_cost_validation).b;
        end
    end
    
    methods (Static)
        function c = quadratic_cost_function(y, a)
            u = a - y;
            c = 0.5 * (u' * u);
        end
        
        function c = diff_quadratic_cost_function(y, a)
            c = a - y;
        end
        
        function a = logistic_activation_function(z)
            a = logsig(z);
        end
        
        function a = diff_logistic_activation_function(z)
            u = logsig(z);
            a = u .* (1 - u);
        end
        
        function a = tanh_activation_function(z)
            a = 2 * logsig(z) - 1;
        end
        
        function a = diff_tanh_activation_function(z)
            u = logsig(2 * z);
            a = 4 * (u .* (1 - u));
        end
        
        function a = line_activation_function(z)
            a = z;
        end
        
        function a = diff_line_activation_function(z)
            a = 1;
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
    end
    
end
