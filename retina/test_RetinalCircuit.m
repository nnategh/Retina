%% Init
close all;
clear;
clc;

%% Properties
background_path = './s1.png';
background = imread(background_path);
object_path = './s2.png';
object = imread(object_path);

number_of_bipolars = 5;
threshold = 0;
slope = 1;

% F = background;
% F = object;
% F = rand(size(background, 1), floor(size(background, 2) / 2));

% F = load('bipolar_kernel.mat', 'data');
% F = F.data;

F = [];

%% 
rc = RetinalCircuit(background, object, F, number_of_bipolars);
rc.threshold = threshold;
rc.slope = slope;
rc.run();