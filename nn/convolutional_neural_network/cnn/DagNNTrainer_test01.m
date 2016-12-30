%%
close('all');
clear();
clc();

%% Properties
filename = './dagnn.json';

%% Net
cnn = DagNNTrainer(filename);
cnn.make_data();

%% Results
