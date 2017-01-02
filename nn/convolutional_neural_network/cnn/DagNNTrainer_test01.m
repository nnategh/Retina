%%
close('all');
clear();
clc();

%% Properties
dagnn_path = './dagnn/dagnn1.1.json';
db_path = './data/db1.mat';

%% Net
cnn = DagNNTrainer(dagnn_path, db_path);
cnn.run();

%% Results
cnn.plot_costs();

%% Test DagNNTrainer.make_db
% db_path = './db2.mat';
% number_of_samples = 20;
% input_size = [10, 10];
% output_size = [4, 4];
% generator = @rand;
% 
% DagNNTrainer.make_db2(...
%     db_path, ...
%     number_of_samples, ...
%     input_size, ...
%     output_size, ...
%     generator ...
% );