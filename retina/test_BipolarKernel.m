%% Init
close all;
clear;
clc;

%% Parameters
signal_surround = load('surround.mat', 'data');
signal_surround = signal_surround.data;
signal_center = load('center.mat', 'data');
signal_center = signal_center.data;

%% Bipolar Kernel
bk = BipolarKernel();

bk.signal_surround = signal_surround;
bk.signal_center = signal_center;
bk.height = 50;

bk.run(true);