classdef DagNNTrainer < handle
    %DAGNNTRAINER implements a trainer for DagNN
    
    properties
        % - props: struct base on dagnntrainer_schema.json
        %       properties of cnn contains configuration of 'data', 'net'
        %       and 'learning' parameters
        % - db: struct('x', cell array, 'y', cell array)
        %       database
        % - current_epoch : int
        %       current epoch
        % - net: DagNN
        %       Dag convolutional neural network
        % - data: struct(...
        %           'train', struct('x', cell array, 'y', cell array), ...
        %           'val', struct('x', cell array, 'y', cell array), ...
        %           'test', struct('x', cell array, 'y', cell array) ...
        %         )
        %       contains 'train', 'val' and 'test' data
        % - costs: stuct(...
        %           'train', double array, ...
        %           'val', double array, ...
        %           'test', double array ...
        %          )
        % - elapsed_times: double array
        %       array of elased times
        props
        db
        current_epoch
        net
        data
        costs
        elapsed_times
    end
    
    properties (Constant)
        % - props_dir: char vector
        %   path of properties json files
        
        props_dir = './data/props';

        format_spec = struct(...
            'change_db_y', '-changed_y.mat', ...
            'noisy_params', '-snr_%d.mat' ...
        );
    end
    
    methods
        function obj = DagNNTrainer(props_filename)
            %DAGNNTRAINER constructor of 'DagNNTrainer' class
            %
            % Parameters
            % ----------
            % - props_filename: char vector
            %   path of configuration json file
            
            % print 'Load: ...'
            [~, filename, ext] = fileparts(props_filename);
            DagNNTrainer.print_dashline();
            fprintf(sprintf('Load: "%s\" file\n', [filename, ext]));
            DagNNTrainer.print_dashline();
            
            obj.init_props(props_filename);
        end
        
        function init_props(obj, filename)
            % INIT_PROPS read 'props' from the configuration json file and
            % refine it such as convert column-vector to row-vector and
            % null to {}
            %
            % filename: char vector
            %   path of configuration json file
            
            % decode json
            obj.props = jsondecode(fileread(filename));
            
            % net (column-vector -> row-vector)
            % - vars
            %   - input
            obj.props.net.vars.input.size = obj.props.net.vars.input.size';
            
            %   - output
            obj.props.net.vars.output.size = obj.props.net.vars.output.size';
            
            % - params
            for i = 1:length(obj.props.net.params)
                obj.props.net.params(i).size = obj.props.net.params(i).size';
            end
            
            % - layers (column-vector -> row-vector and null -> {})
            for i = 1:length(obj.props.net.layers)
                % - inputs
                if isempty(obj.props.net.layers(i).inputs)
                    obj.props.net.layers(i).inputs = {};
                else
                    obj.props.net.layers(i).inputs = obj.props.net.layers(i).inputs';
                end
                % - outputs
                if isempty(obj.props.net.layers(i).outputs)
                    obj.props.net.layers(i).outputs = {};
                else
                    obj.props.net.layers(i).outputs = obj.props.net.layers(i).outputs';
                end
                
                % - params
                if isempty(obj.props.net.layers(i).params)
                    obj.props.net.layers(i).params = {};
                else
                    obj.props.net.layers(i).params = obj.props.net.layers(i).params';
                end
            end
        end
        
        function init_db(obj)
            % INIT_DB initialzes 'db' from the 'db_filename'
            
            % db
            % - load
            obj.db = load(obj.props.data.db_filename);
            % - standardize
            obj.standardize_db();
            % - resize
            obj.resize_db();
        end
        
        function standardize_db(obj)
            % STANDARDIZE_DB makes db zero-mean and unit-variance
            
            % db
            % - x
            if obj.props.learning.standardize_x
                for i = 1 : length(obj.db.x)
                    mu = mean(obj.db.x{i}(:));
                    sigma = std(obj.db.x{i}(:));
                    if sigma == 0
                        sigma = 1;
                    end
                    obj.db.x{i} = (obj.db.x{i} - mu) / sigma;
                end
            end
            % - y
            if obj.props.learning.standardize_y
                for i = 1 : length(obj.db.y)
                    mu = mean(obj.db.y{i}(:));
                    sigma = std(obj.db.y{i}(:));
                    if sigma == 0
                        sigma = 1;
                    end
                    obj.db.y{i} = (obj.db.y{i} - mu) / sigma;
                end
            end
        end
        
        function resize_db(obj)
            % RESIZE_DB resizes 'db.x' and 'db.y'
            
            % resize
            % - db.x
            input_size = obj.props.net.vars.input.size;
            for i = 1 : length(obj.db.x)
                obj.db.x{i} = DataUtils.resize(obj.db.x{i}, input_size);
            end
            % - db.y
            output_size = obj.props.net.vars.output.size;
            for i = 1 : length(obj.db.y)
                obj.db.y{i} = DataUtils.resize(obj.db.y{i}, output_size);
            end
        end
        
        function init_bak_dir(obj)
            % INIT_BAK_DIR initializes 'bak' directory from the 'bak_dir'
            
            if ~exist(obj.props.data.bak_dir, 'dir')
                mkdir(obj.props.data.bak_dir);
            end
        end
        
        function init_current_epoch(obj)
            % INIT_CURRENT_EPOCH initializes 'current_epoch' based on last
            % saved epoch in the 'bak' directory
            
            list = dir(fullfile(obj.props.data.bak_dir, 'epoch_*.mat'));
            tokens = regexp({list.name}, 'epoch_([\d]+).mat', 'tokens');
            epoch = cellfun(@(x) sscanf(x{1}{1}, '%d'), tokens);
            obj.current_epoch = max(epoch);
        end
        
        function init_net(obj)
            % INIT_NET initialzes 'net'
            
            % if there is no saved epoch file in 'bak' directory
            if isempty(obj.current_epoch)
                obj.current_epoch = 1;
                % blocks
                blocks = struct(...
                    'conv', @dagnn.Conv, ...
                    'norm', @dagnn.NormOverall, ...
                    'relu', @dagnn.ReLU, ...
                    'minus', @dagnn.Minus, ...
                    'convrelu', @dagnn.ConvReLU, ...
                    'convnorm', @dagnn.ConvNorm, ...
                    'convnormrelu', @dagnn.ConvNormReLU, ...
                    'convnormreluminus', @dagnn.ConvNormReLUMinus, ...
                    'normrelu', @dagnn.NormReLU, ...
                    'sum', @dagnn.Sum, ...
                    'quadcost', @dagnn.QuadraticCost ...
                    );
                
                % define object
                obj.net = dagnn.DagNN();
                % obj.net.conserveMemory = false;
                
                % add layers
                layers = obj.props.net.layers;
                for i = 1:length(layers)
                    obj.net.addLayer(...
                        layers(i).name, blocks.(layers(i).type)(), ...
                        layers(i).inputs, ...
                        layers(i).outputs, ...
                        layers(i).params ...
                        );
                end
                
                % init params
                obj.init_params();
                
                % set 'size' property of 'Conv' blocks
                for i = 1:length(obj.net.layers)
                    if startsWith(...
                            class(obj.net.layers(i).block), ...
                            'dagnn.Conv' ...
                            )
                        param_name = obj.net.layers(i).params{1};
                        param_index = obj.net.getParamIndex(param_name);
                        param_size = size(obj.net.params(param_index).value);
                        
                        obj.net.layers(i).block.set_kernel_size(param_size);
                    end
                end
                
                % save first epoch in 'bak' directory
                obj.save_current_epoch();
            else
                % load last saved epoch file in 'bak' directory
                obj.load_current_epoch();
            end
        end
        
        function init_data(obj)
            % INIT_DATA divide 'db' based on 'train_val_test_ratios' and
            % initializes 'data'
            
            % number of samples
            n = min(length(obj.db.x), length(obj.db.y));
            
            % ratios
            % - train
            ratios.train = obj.props.learning.train_val_test_ratios(1);
            % - test
            ratios.val = obj.props.learning.train_val_test_ratios(2);
            
            % shuffle db
            if exist(obj.get_db_indexes_filename(), 'file')
                indexes = obj.load_db_indexes();
            else
                indexes = randperm(n);
                obj.save_db_indexes(indexes);
            end
            
            % end index
            % - train
            end_index.train = floor(ratios.train * n);
            % - val
            end_index.val = floor((ratios.train + ratios.val) * n);
            % - test
            end_index.test = n;
            
            % data
            % - train
            %   - x
            obj.data.train.x = obj.db.x(indexes(1:end_index.train));
            %   - y
            obj.data.train.y = obj.db.y(indexes(1:end_index.train));
            
            % - val
            %   - x
            obj.data.val.x = obj.db.x(indexes(end_index.train + 1:end_index.val));
            %   - y
            obj.data.val.y = obj.db.y(indexes(end_index.train + 1:end_index.val));
            
            % - test
            %   - x
            obj.data.test.x = obj.db.x(indexes(end_index.val + 1:end_index.test));
            %   - y
            obj.data.test.y = obj.db.y(indexes(end_index.val + 1:end_index.test));
        end
        
        function init_params(obj)
            % INIT_PARAMS initializes obj.net.params from 'params_filename'
            
            params = obj.props.net.params;
            weights = load(obj.props.data.params_filename);
            for i = 1:length(params)
                obj.net.params(obj.net.getParamIndex(params(i).name)).value = ...
                    DataUtils.resize(weights.(params(i).name), params(i).size);
            end
        end
        
        function init_meta(obj)
            % INIT_META set obj.net.meta
            
%             obj.net.meta = struct(...
%                 'learning_rate', obj.props.learning.learning_rate, ...
%                 'batch_size', obj.props.learning.batch_size ...
%             );

            obj.net.meta.learning = obj.props.learning;
        end
        
        function cost = get_cost(obj, x, y)
            % GET_COST computes mean cost of net based on input 'x' and
            % expected-output 'y'
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input
            % - y: cell array
            %   expected-output
            
            n = length(x);
            cost = 0;
            for i = 1:n
                obj.net.eval({...
                    obj.props.net.vars.input.name, x{i}, ...
                    obj.props.net.vars.expected_output.name, y{i} ...
                    });
                
                cost = cost + obj.net.vars(...
                    obj.net.getVarIndex(obj.props.net.vars.cost.name) ...
                    ).value;
            end
            
            cost = cost / n;
        end
        
        function train_cost = get_train_cost(obj)
            % GET_TRAIN_COST get cost of training data
            
            train_cost = ...
                obj.get_cost(obj.data.train.x, obj.data.train.y);
        end
        
        function val_cost = get_val_cost(obj)
            % GET_VAL_COST get cost of validation data
            
            val_cost = ...
                obj.get_cost(obj.data.val.x, obj.data.val.y);
        end
        
        function test_cost = get_test_cost(obj)
            % GET_TEST_COST get cost of test data
            
            test_cost = ...
                obj.get_cost(obj.data.test.x, obj.data.test.y);
        end
        
        function init_costs(obj)
            % INIT_COSTS initializes 'costs'
            
            % if 'costs.mat' file exists in 'bak' directory
            if exist(obj.get_costs_filename(), 'file')
                obj.load_costs();
                obj.costs.train = ...
                    obj.costs.train(1:obj.current_epoch);
                obj.costs.val = ...
                    obj.costs.val(1:obj.current_epoch);
                obj.costs.test = ...
                    obj.costs.test(1:obj.current_epoch);
            else
                % costs
                % - train
                obj.costs.train(1) = obj.get_train_cost();
                
                % - costs
                obj.costs.val(1) = obj.get_val_cost();
                
                % - costs
                obj.costs.test(1) = obj.get_test_cost();
                
                % save
                obj.save_costs();
            end
        end
        
        function init_elapsed_times(obj)
            % INIT_ELAPSED_TIMES initializes 'elapsed_times'
            
            % if 'elapsed_times' file exists in 'bak' directory
            if exist(obj.get_elapsed_times_filename(), 'file')
                obj.load_elapsed_times();
                obj.elapsed_times = ...
                    obj.elapsed_times(1:obj.current_epoch);
            else
                obj.elapsed_times(1) = 0;
                obj.save_elapsed_times();
            end
        end
        
        function init(obj)
            % INIT initializes properties
            
            % db
            obj.init_db();
            
            % backup directory
            obj.init_bak_dir()
            
            % current epoch
            obj.init_current_epoch()
            
            % net
            obj.init_net();
            
            % - meta
            obj.init_meta();
            
            % data
            obj.init_data();
            
            % costs
            obj.init_costs();
            
            % elapsed times
            obj.init_elapsed_times();
            
            % bak_dir == 'must_be_removed'
            if strcmp(obj.props.data.bak_dir, 'must_be_removed')
                rmdir(obj.props.data.bak_dir, 's');
            end
        end
        
        function y = out(obj, x)
            % OUT computes estimated-outputs of network based on given
            % inputs
            %
            % Parameters
            % ----------
            % - x: cell array
            %   input
            
            n = length(x);
            y = cell(n, 1);
            for i = 1:n
                obj.net.eval({...
                    obj.props.net.vars.input.name, x{i} ...
                    });
                
                y{i} = obj.net.vars(...
                    obj.net.getVarIndex(obj.props.net.vars.output.name) ...
                    ).value;
            end
        end
        
        function run(obj)
            % RUN runs the learing process contains 'forward', 'backward'
            % and 'update' steps
            
            % init net
            obj.init();
            
            % print epoch progress (last saved epoch)
            obj.print_epoch_progress()
            
            obj.current_epoch = obj.current_epoch + 1;
            
            % epoch number that network has minimum cost on validation data
            [~, index_min_val_cost] = min(obj.costs.val);
            
            n = length(obj.data.train.x);
            batch_size = obj.props.learning.batch_size;
            
            % epoch loop
            while obj.current_epoch <= obj.props.learning.number_of_epochs + 1
                begin_time = cputime();
                % shuffle train data
                permuted_indexes = randperm(n);
                
                % batch loop
                for start_index = 1:batch_size:n
                    end_index = start_index + batch_size - 1;
                    if end_index > n
                        end_index = n;
                    end
                    
                    indexes = permuted_indexes(start_index:end_index);
                    % make batch data
                    % - x
                    input = ...
                        DagNNTrainer.cell_array_to_tensor(...
                        obj.data.train.x(indexes) ...
                        );
                    % - y
                    expected_output = ...
                        DagNNTrainer.cell_array_to_tensor(...
                        obj.data.train.y(indexes) ...
                        );
                    
                    % forward, backward step
                    obj.net.eval(...
                        {...
                        obj.props.net.vars.input.name, input, ...
                        obj.props.net.vars.expected_output.name, expected_output
                        }, ...
                        {obj.props.net.vars.cost.name, 1} ...
                        );
                    
                    % update step
                    for param_index = 1:length(obj.net.params)
                        obj.net.params(param_index).value = ...
                            obj.net.params(param_index).value - ...
                            obj.props.learning.learning_rate * obj.net.params(param_index).der;
                    end
                    
                    % print samples progress
                    fprintf('Samples:\t%d-%d/%d\n', start_index, end_index, n);
                end
                
                % elapsed times
                obj.elapsed_times(end + 1) = cputime() - begin_time();
                % costs
                % - train
                obj.costs.train(end + 1) = obj.get_train_cost();
                % - val
                obj.costs.val(end + 1) = obj.get_val_cost();
                % - test
                obj.costs.test(end + 1) = obj.get_test_cost();
                
                % no imporovement in number_of_val_fails steps
                if obj.costs.val(end) < obj.costs.val(index_min_val_cost)
                    index_min_val_cost = length(obj.costs.val);
                end
                
                if (length(obj.costs.val) - index_min_val_cost) >= ...
                        obj.props.learning.number_of_val_fails
                    break;
                end
                
                % print epoch progress
                obj.print_epoch_progress()
                
                % save
                % - costs
                obj.save_costs();
                % - elapsed times
                obj.save_elapsed_times();
                % - net
                obj.save_current_epoch();
                
                % increament current epoch
                obj.current_epoch = obj.current_epoch + 1;
            end 
        end
        
        function load_best_val_epoch(obj)
            % LOAD_BEST_VAL_EPOCH loads best validation performance saved
            % epoch
            
            % update current-epoch
            [~, obj.current_epoch] = min(obj.costs.val);
            % init-net
            obj.init_net();
        end
        
        function print_epoch_progress(obj)
            % PRINT_EPOCH_PROGRESS print progress, after each batch
            %
            % Examples
            % --------
            % 1.
            %   >>> print_epoch_progress()
            %   --------------------------------
            %   Epoch:	...
            %   Costs:	[..., ..., ...]
            %   Time:	... s
            %   --------------------------------
            
            DagNNTrainer.print_dashline();
            fprintf('Epoch:\t%d\n', obj.current_epoch);
            fprintf('Costs:\t[%.3f, %.3f, %.3f]\n', ...
                obj.costs.train(end), ...
                obj.costs.val(end), ...
                obj.costs.test(end) ...
                );
            fprintf('Time:\t%f s\n', ...
                obj.elapsed_times(obj.current_epoch));
            DagNNTrainer.print_dashline();
        end
        
        function plot_costs(obj)
            % PLOT_COSTS plots 'costs' over time
            
            epochs = 1:length(obj.costs.train);
            epochs = epochs - 1; % start from zero (0, 1, 2, ...)
            
            figure(...
                'Name', 'CNN - Costs [Training, Validation, Test]', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0.25, 0.25, 0.5, 0.5] ...
                );
            
            % costs
            % - train
            plot(epochs, obj.costs.train, 'LineWidth', 2, 'Color', 'blue');
            set(gca, 'YScale', 'log');
            hold('on');
            % - validation
            plot(epochs, obj.costs.val, 'LineWidth', 2, 'Color', 'green');
            % - test
            plot(epochs, obj.costs.test, 'LineWidth', 2, 'Color', 'red');
            
            % minimum validation error
            % - circle
            [~, index_min_val_cost] = min(obj.costs.val);
            circle_x = index_min_val_cost - 1;
            circle_y = obj.costs.val(index_min_val_cost);
            dark_green = [0.1, 0.8, 0.1];
            scatter(circle_x, circle_y, ...
                'MarkerEdgeColor', dark_green, ...
                'SizeData', 300, ...
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
            
            % labels
            xlabel('Epoch');
            ylabel('Mean Squared Error (mse)');
            
            % title
            title(...
                sprintf('Minimum Validation Error is %.3f at Epoch: %d', ...
                obj.costs.val(index_min_val_cost), ...
                index_min_val_cost - 1 ...
                ) ...
                );
            
            % legend
            legend(...
                sprintf('Training (%.3f)', obj.costs.train(index_min_val_cost)), ...
                sprintf('Validation (%.3f)', obj.costs.val(index_min_val_cost)), ...
                sprintf('Test (%.3f)', obj.costs.test(index_min_val_cost)), ...
                'Best' ...
                );
            
            % grid
            grid('on');
            grid('minor');
        end
        
        function filename = get_current_epoch_filename(obj)
            % GET_CURRENTJ_EPOCH_FILENAME returns path of current epoch
            % saved file in 'bak' directory
            
            filename = fullfile(...
                obj.props.data.bak_dir, ...
                sprintf('epoch_%d', obj.current_epoch) ...
                );
        end
        
        function save_current_epoch(obj)
            % SAVE_CURRENT_EPOCH saves 'net' of current-epoch in 'bak'
            % directory
            
            net_struct = obj.net.saveobj();
            save(...
                obj.get_current_epoch_filename(), ...
                '-struct', 'net_struct' ...
                ) ;
            
            clear('net_struct');
        end
        
        function load_current_epoch(obj)
            % LOAD_CURRENT_EPOCH loads 'net' of current-epoch from 'bak'
            % directory
            
            net_struct = load(...
                obj.get_current_epoch_filename() ...
                ) ;
            
            obj.net = dagnn.DagNN.loadobj(net_struct) ;
            clear('net_struct');
        end
        
        function filename = get_costs_filename(obj)
            % GET_COSTS_FILENAME returns path of 'costs.mat' saved file in
            % 'bak' directory
            
            filename = fullfile(...
                obj.props.data.bak_dir, ...
                'costs.mat' ...
                );
        end
        
        function save_costs(obj)
            % SAVE_COSTS saves 'costs.mat' in 'bak' directory
            
            costs = obj.costs;
            
            save(...
                obj.get_costs_filename(), ...
                '-struct', ...
                'costs' ...
                );
            
            clear('costs');
        end
        
        function load_costs(obj)
            % LOAD_COSTS loads 'costs.mat' from 'bak' directory
            
            obj.costs = load(obj.get_costs_filename());
        end
        
        function filename = get_db_indexes_filename(obj)
            % GET_DB_INDEXES_FILENAME returns path of 'db_indexes.mat'
            % saved file in 'bak' directory
            
            filename = fullfile(...
                obj.props.data.bak_dir, ...
                'db_indexes.mat' ...
                );
        end
        
        function save_db_indexes(obj, indexes)
            % SAVE_DB_INDEXES saves 'db_indexes.mat' in 'bak' directory
            
            db_indexes = indexes;
            save(...
                obj.get_db_indexes_filename(), ...
                'db_indexes' ...
                );
        end
        
        function db_indexes = load_db_indexes(obj)
            % SAVE_DB_INDEXES loads 'db_indexes.mat' from 'bak' directory
            
            db_indexes = getfield(...
                load(obj.get_db_indexes_filename()), ...
                'db_indexes' ...
                );
        end
        
        function filename = get_elapsed_times_filename(obj)
            % GET_ELAPSED_TIMES_FILENAME returns path of 'elapsed_times.mat'
            % saved file in 'bak' directory
            
            filename = fullfile(...
                obj.props.data.bak_dir, ...
                'elapsed_times.mat' ...
                );
        end
        
        function save_elapsed_times(obj)
            % SAVE_ELAPSED_TIMES saves 'elapsed_times' in 'bak' directory
            
            elapsed_times = obj.elapsed_times;
            save(...
                obj.get_elapsed_times_filename(), ...
                'elapsed_times' ...
                );
            
            clear('elapsed_times');
        end
        
        function load_elapsed_times(obj)
            % LOAD_ELAPSED_TIMES loads 'elapsed_times.mat' from 'bak'
            % directory
            
            obj.elapsed_times = getfield(...
                load(obj.get_elapsed_times_filename()), ...
                'elapsed_times' ...
                );
        end
        
        function save(obj, filename)
            % SAVE saves the 'DagNNTrainer' object
            
            save(filename, 'obj');
        end
        
        %todo: split to 'db', 'params'
        function make_random_data_old(obj, number_of_samples, generator)
            % MAKE_RANDOM_DATA make random 'db' and 'params' files.
            %
            %   Parameters
            %   ----------
            %   - number_of_samples : int
            %       number of training data
            %   - generator : handle function (default is @rand)
            %       generator function such as 'rand', 'randn', ...
            
            % default generator
            if nargin < 3
                generator = @rand;
            end
            
            % db
            db.x = cell(number_of_samples, 1);
            db.y = cell(number_of_samples, 1);
            
            % - x, y
            input_size = obj.props.net.vars.input.size;
            output_size = obj.props.net.vars.output.size;
            for i = 1:number_of_samples
                db.x{i} = generator(input_size);
                db.y{i} = generator(output_size);
            end
            
            % - save
            save(obj.props.data.db_filename, 'db');
            clear('db');
            
            % params
            params = obj.props.net.params;
            % - weights
            weights = struct();
            for i = 1 : length(params)
                weights.(params(i).name) = generator(params(i).size);
            end
            % - save
            save(obj.props.data.params_filename, '-struct', 'weights');
            clear('weights');
        end
        
        function make_db_with_changed_y(obj)
            % MAKE_DB_WITH_CHANGED_Y generated 'db.y' based on given 
            % 'db.x' and 'params' file.
            
            % db filename
            db_filename = [...
                obj.props.data.db_filename, ...
                DagNNTrainer.format_spec.change_db_y ...
            ];
        
            if exis(db_filename, 'file')
                return
            end
            
            % db
            db.x = obj.db.x;
            db.y = obj.out(db.x);
            
            % save
            save(...
                db_filename, ...
                '-struct', 'db' ...
            );
            clear('db');
        end
        
        function make_noisy_params(obj, snr)
            % MAKE_NOISY_PARAMS
            %
            % Parameters
            % ----------
            % - snr: double
            %   The scalar snr specifies the signal-to-noise ratio per 
            %   sample, in dB
            
            % params filename
            params_filename = [...
                obj.props.data.params_filename, ...
                sprintf(DagNNTrainer.format_spec.noisy_params, snr) ...
            ];
        
            if exis(params_filename, 'file')
                return
            end
            
            % load
            params = load(obj.props.data.params_filename);
            
            % add white Gaussian noise to signal
            for field = fieldnames(params)
                % x = params.(fields{i});
                % params.(fields{i}) = x + sigma * randn(size(x));
                params.(char(field)) = ...
                    awgn(params.(char(field)), snr, 'measured');
            end
            
            % save
            save(...
                params_filename, ...
                '-struct', 'params' ...
            );
            clear('params');
        end
    end
    
    methods (Static)
        function tensor = cell_array_to_tensor(cell_array)
            % CELL_ARRAY_TO_TENSOR converts cell array to multi-dimensional
            % array
            
            tensor_size = horzcat(...
                size(cell_array{1}), ...
                [1, length(cell_array)] ...
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
        
        function print_dashline(length_of_line)
            % PRINT_DASHLINE prints a dash-line
            %
            % Parameters
            % ----------
            % - length_of_line: int
            %   length of printed dash-line
            %
            % Examples
            % --------
            % 1.
            %   >>> DagNNTrainer.print_dashline(5)
            %   -----
            
            if nargin < 1
                length_of_line = 32;
            end
            
            fprintf(repmat('-', 1, length_of_line));
            fprintf('\n');
        end
        
        function dg = make_digraph(filename)
            % MAKE_DIGRAPH makes a directed-graph based on given 'json' file
            %
            % Parameters
            % ----------
            % - filename : char vector
            %   filename of input 'json' file
            %
            % Returns
            % - dg : digraph
            %   directed graph
            %
            % Examples
            % --------
            % 1.
            %   >>> filename = './dagnn.json';
            %   >>> dg = DagNNTrainer.make_digraph(dagnn_filename);
            %   >>> dg.Edges
            %    EndNodes
            %   __________
            %      ...
            
            % read 'json' file
            props = jsondecode(fileread(filename));
            
            % add layers to digraph
            dg = digraph();
            
            for l = 1 : length(props.net.layers)
                layer = props.net.layers(l);
                block = layer.name;
                
                % add edges
                % - inputs, block
                for i = 1 : length(layer.inputs)
                    x = layer.inputs(i);
                    dg = addedge(dg, x, block);
                end
                % - params, block
                for i = 1 : length(layer.params)
                    w = layer.params(i);
                    dg = addedge(dg, w, block);
                end
                % - block, outputs
                for i = 1 : length(layer.outputs)
                    y = layer.outputs(i);
                    dg = addedge(dg, block, y);
                end
            end
        end
        
        function plot_digraph(filename)
            % PLOT_DIGRAPH plot a directed-graph based on given 'json' file
            %
            % Parameters
            % ----------
            % - filename : char vector
            %   filename of input 'json' file
            %
            % Examples
            % --------
            % 1.
            %   >>> filename = './dagnn.json';
            %   >>> dg = DagNNTrainer.plot_digraph(dagnn_filename);
            %   ...
            
            % read 'json' file
            props = jsondecode(fileread(filename));
            
            % make digraph
            dg = DagNNTrainer.make_digraph(filename);
            
            % plot graph
            h = plot(dg);
            
            % layout
            layout(h, 'layered', ...
                'Direction', 'right', ...
                'Sources', props.net.vars.input.name, ...
                'Sinks', props.net.vars.cost.name, ...
                'AssignLayers', 'asap' ...
                );
            
            % highlight
            % - input, output
            highlight(h, ...
                {...
                    props.net.vars.input.name, ...
                    props.net.vars.expected_output.name ...
                }, ...
                'NodeColor', 'red' ...
                );
            % - params
            params = {};
            for i = 1 : length(props.net.params)
                params{end + 1} = props.net.params(i).name;
            end
            highlight(h, ...
                params, ...
                'NodeColor', 'green' ...
                );
            % - blocks
            ms = h.MarkerSize;
            blocks = {};
            for i = 1 : length(props.net.layers)
                blocks{end + 1} = props.net.layers(i).name;
            end
            highlight(h, ...
                blocks, ...
                'Marker', 's', ...
                'MarkerSize', 5 * ms ...
                );
            % hide axes
            set(h.Parent, ...
                'XTick', [], ...
                'YTick', [] ...
                );
            
        end
        
        function obj = load(filename)
            % LOAD loads 'DagNNTrainer' from file
            
            obj = load(filename);
            obj = obj.(char(fieldnames(obj)));
        end
        
        function test()
            % setup 'matconvnet'
            run('vl_setupnn.m');
            
            % 'props' dir
            props_dir = DagNNTrainer.props_dir;
            % properties filenames
            props_filenames = ...
                dir(fullfile(props_dir, '*.json'));
            props_filenames = {props_filenames.name};
            
            % net
            for i = 1 : length(props_filenames)
                % props-filename
                props_filename = fullfile(props_dir, props_filenames{i});
                % - define
                cnn = DagNNTrainer(props_filename);
                % - run
                tic();
                cnn.run();
                toc();
                
                % - plot net
                figure();
                DagNNTrainer.plot_digraph(props_filename);
            end
        end
    end 
end
