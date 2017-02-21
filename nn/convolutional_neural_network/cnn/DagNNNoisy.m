classdef DagNNNoisy < handle
    %DAGNNNOISY
    
    properties (Constant)
        base_props_dir = 'D:\PhD\MSU\codes\Retina\nn\convolutional_neural_network\cnn\data\ep20c11\noisy\base_props';
        snr = [10, 1, 0];
        formattype = 'svg';
    end
    
    methods (Static)
        function base_props_filenames = get_base_props_filenames(base_props_dir)
            % GET_BASE_PROPS_FILENAMES
            
            base_props_filenames = ...
                dir(fullfile(base_props_dir, '*.json'));
            base_props_filenames = {base_props_filenames.name};
        end
        
        function make_db(props_filename, db_filename)
            % MAKE_DB

            if exist(db_filename, 'file')
                return
            end
            
            cnn = DagNNTrainer(props_filename);
            cnn.init();

            % db
            db.x = cnn.db.x;
            db.y = cnn.out(db.x);
            
            % save
            save(...
                db_filename, ...
                '-struct', 'db' ...
            );
            clear('db');
        end
        
        function make_params(props_filename, params_filename, snr)
            % MAKE_PARAMS
            
            if exist(params_filename, 'file')
                return
            end
            
            % net
            cnn = DagNNTrainer(props_filename);
            cnn.init();
            
            % load params
            params = load(cnn.props.data.params_filename);

            % add white Gaussian noise to signal
            
%             for field = fieldnames(params)
%                 params.(char(field)) = ...
%                     awgn(params.(char(field)), snr, 'measured');
%             end

            fields = fieldnames(params);
            for i = 1 : length(fields)
                params.(fields{i}) = ...
                    awgn(params.(fields{i}), snr, 'measured');
            end

            % save
            save(...
                params_filename, ...
                '-struct', 'params' ...
            );
            clear('params');
        end
        
        function make_props(...
                base_props_filename, ...
                db_filename, ...
                params_filename, ...
                bak_dir, ...
                props_filename ...
            )
            % MAKE_PARAMS
            
            % json
            % - decode
            props = jsondecode(fileread(base_props_filename));
            
            % - db_filename
            props.data.db_filename = db_filename;

            % - params_filename
            props.data.params_filename = params_filename;
            
            % - bak_dir
            props.data.bak_dir = bak_dir;
            
            % - encode and save
            file = fopen(props_filename, 'w');
            fprintf(file, '%s', jsonencode(props));
            fclose(file);
        end
        
        function run_props(props_filename)
            % RUN_PROPS

            cnn = DagNNTrainer(props_filename);
            cnn.run();

            cnn.plot_costs();

            figure();
            DagNNTrainer.plot_digraph(props_filename);
        end
        
        function run()
            % RUN
            close('all');
            clear;
            clc;
            
            run('vl_setupnn.m');
            
            for base_props_filename = DagNNNoisy.get_base_props_filenames(DagNNNoisy.base_props_dir)
                base_props_filename = ...
                    fullfile(DagNNNoisy.base_props_dir, char(base_props_filename));
                
                [pathstr, ~, ~] = fileparts(DagNNNoisy.base_props_dir);
                [~, name, ~] = fileparts(base_props_filename);
                root_dir = fullfile(pathstr, 'results', name);
                % make dir
                if ~exist(root_dir, 'dir')
                    mkdir(root_dir);
                end
                
                % make db
                db_filename = fullfile(root_dir, 'db.mat');
                DagNNNoisy.make_db(...
                    base_props_filename, ...
                    db_filename ...
                );
                
                for snr_value = DagNNNoisy.snr
                    % make params
                    props = jsondecode(fileread(base_props_filename));
                    params_filename = fullfile(...
                        root_dir, ...
                        sprintf('params_snr_%d.mat', snr_value) ...
                    );
                    DagNNNoisy.make_params(...
                        base_props_filename, ...
                        params_filename, ...
                        snr_value ...
                    );

                    % make props files
                    props_filename = fullfile(...
                        root_dir, ...
                        sprintf(...
                            'props_snr_%d_bs_%d_lr_%0.4f.json', ...
                            snr_value, ...
                            props.learning.batch_size, ...
                            props.learning.learning_rate ...
                        ) ...
                    );
                    bak_dir = fullfile(...
                        root_dir, ...
                        sprintf(...
                            'bak_snr_%d_bs_%d_lr_%0.4f', ...
                            snr_value, ...
                            props.learning.batch_size, ...
                            props.learning.learning_rate ...
                        ) ...
                    );

                    DagNNNoisy.make_props(...
                        base_props_filename, ...
                        db_filename, ...
                        params_filename, ...
                        bak_dir, ...
                        props_filename ...
                    );

                    % run props files
                    DagNNNoisy.run_props(props_filename);
                    
                    % make images
                    % DagNNViz.plot_results(bak_dir, DagNNNoisy.formattype);
                    
                    % copy net.svg
                    copyfile(...
                        fullfile(DagNNNoisy.base_props_dir, [name, '.svg']), ...
                        fullfile(bak_dir, 'images', 'net.svg') ...
                    );
                end
            end
        end
    end
    
end

