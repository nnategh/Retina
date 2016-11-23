%% Init
close all;
clear;
clc;

%% Code
% Properties
precision = 2;
is_symmetry = true;
x_label = 'Distance';
y_label = 'Sensitivity';

%
df = DrawFunction();
df.precision = precision;
df.is_symmetry = is_symmetry;
df.x_label = x_label;
df.y_label = y_label;

df.run();