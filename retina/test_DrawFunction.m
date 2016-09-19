%% Init
%  close all;
clear;
clc;

%% GUI
DrawFunctionGUI

%% Code
% Properties
name = 'surround';
limits = [-1, 1, -1, 1];
x_round_digits = 1;

%% 
df = DrawFunction();

df.name = name;
df.limits = limits;
df.x_round_digits = x_round_digits;

df.run();