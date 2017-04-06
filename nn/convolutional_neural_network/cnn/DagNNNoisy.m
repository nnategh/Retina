classdef DagNNNoisy < handle
    %A framework for training a dag with noisy parameters
    
    properties (Constant)
        base_props_dir = 'D:/PhD/MSU/codes/Retina/nn/convolutional_neural_network/cnn/data/ep20c11/noisy/base_props';
        indexhtml_path = 'D:/PhD/MSU/codes/Retina/nn/convolutional_neural_network/cnn/data/ep20c11/noisy/index.html';
        snr = [-1];
        formattype = 'svg';
    end
    
    methods (Static)
        function base_props_filenames = get_base_props_filenames(base_props_dir)
            % Get filenames of `base_props` from given directory
            %
            % Parameters
            % ----------
            % - base_props_dir: char vector
            %   Path of directory containing `base_props` json files
            
            base_props_filenames = ...
                dir(fullfile(base_props_dir, '*.json'));
            base_props_filenames = {base_props_filenames.name};
        end
        
        function make_db(props_filename, db_filename)
            % Make database based on dag (specivied by `props` file) 
            % and save it
            %
            % Parameters
            % ----------
            % - props_filename: char vector
            %   Path of dag properties file
            % - db_filename: char vector
            %   Path of output database
            
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
            % Add noise to parameters of a dag and save it
            %
            % Parameters
            % ----------
            % - props_filename: char vector
            %   Path of dag properties file
            % - params_filename: char vector
            %   Path of output dag parameters file
            % - snr: double
            %   Signal to noise ratio in dB
            
            % net
            cnn = DagNNTrainer(props_filename);
            cnn.init();
            
            % load params
            params = load(cnn.props.data.params_filename);

            % add white Gaussian noise to signal
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
            % Make a dag properties file
            %
            % Parameters
            % ----------
            % - base_props_filename: char vector
            %   Path of basic properties file
            % - db_filename: char vector
            %   Path of database
            % - parame_filename: char vector
            %   Path of parameters
            % - bak_dir: char vector
            %   Path of backup directory
            % - props_filename: char vector
            %   Path of output properties file
            
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
            % Run a dag and plot `costs` and `diagraph`
            %
            % Parameters
            % ----------
            % - props_filename: char vector
            %   Path of properties for defining dag

            cnn = DagNNTrainer(props_filename);
            cnn.run();

            % Plot
            %   - costs
            cnn.plot_costs();
            %   - diagraph
            DagNNTrainer.plot_digraph(props_filename);
        end
        
        function run()
            % RUN
            close('all');
            clear;
            clc;
            
            % parameters
            viz = DagNNViz();
            
            run('vl_setupnn.m');
            
            base_props_filenames = DagNNNoisy.get_base_props_filenames(DagNNNoisy.base_props_dir);
            for i = 1:numel(base_props_filenames)
                base_props_filename = fullfile(...
                    DagNNNoisy.base_props_dir, ...
                    base_props_filenames{i} ...
                );
                
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
                    DagNNViz.plot_results(props_filename);
                    
                    % copy net.svg
                    copyfile(...
                        fullfile(DagNNNoisy.base_props_dir, [name, '.svg']), ...
                        fullfile(bak_dir, 'images', 'net.svg') ...
                    );
                
                    % copy index.html
                    copyfile(...
                        DagNNNoisy.indexhtml_path, ...
                        bak_dir ...
                    );
                
                    % plot noisy/noiseless filters
                    viz.output_dir = fullfile(bak_dir, 'images');
                    viz.plot_noisy_params(...
                        props.data.params_filename, ...
                        params_filename, ...
                        snr_value ...
                    )
                end
            end
        end
    end
    
end
