%%
close('all');
clear();
clc();

run('D:\PhD\MSU\codes\matconvnet\matconvnet-1.0-beta23\matlab\vl_setupnn.m');

%% Properties
props_filename = 'D:\PhD\MSU\codes\Retina\nn\convolutional_neural_network\cnn\data\ep20c11\fig4.2\fig4.2.json';
cnn = DagNNTrainer(props_filename);

%% Make random data
% cnn.make_random_data(100);

%% Net
% cnn.init();
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
DagNNTrainer.plot_digraph(props_filename);
