%% Init
close all;
clear;
clc;

%% Parameters
% stimulus = rand(100, 500);
stimulus = imread('differential.png');
number_of_bipolar_cells = 10;
number_of_amacrine_cells = 5;
number_of_ganglion_cells = 2;

%%
retina = Retina(...
    stimulus, ...
    number_of_bipolar_cells, ...
    number_of_amacrine_cells, ...
    number_of_ganglion_cells...
);

retina.run();