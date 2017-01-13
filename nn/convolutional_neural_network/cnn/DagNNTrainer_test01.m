%%
close('all');
clear();
clc();

% run('D:\PhD\MSU\codes\matconvnet\matconvnet-1.0-beta23\matlab\vl_setupnn.m');

%% Properties
dagnn_filename = './dagnn/fig4.1.json';
db_filename = './data/db1.mat';

%% Net
cnn = DagNNTrainer(dagnn_filename, db_filename);
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

%% Plot digraph
figure();
DagNNTrainer.plot_digraph(dagnn_filename);
