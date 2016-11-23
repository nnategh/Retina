%% Init
close all;
clear;
clc;

%% Parameters
precision = 2;

size_ = [10, 10, 5];
space_value_limits = [-1, 1];
time_value_limits = [-1, 1];

number_of_slices = 5;
edge_color = true;
delay = 1;

%% Init
kd = KernelDesigner();
kd.precision = precision;

kd.init();

%% Get Kernel
kernel = kd.get_kernel(size_, space_value_limits, time_value_limits);

figure;
CNN.plot_slice_3darray(kernel, number_of_slices, edge_color);
figure;
CNN.movie_slice_3darray(kernel, delay, edge_color);

%% Save
% kd.save('test');
kd = KernelDesigner.load('test');