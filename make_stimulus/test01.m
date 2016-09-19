%% init
close all;
clear;
clc;

%% Parameters
I = rand(500, 500);

% Create figure
figure1 = figure;
colormap('gray');

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create image
image(I,'Parent',axes1,'CDataMapping','scaled');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.5 500.5]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0.5 500.5]);
box(axes1,'on');
axis(axes1,'ij');
% Set the remaining axes properties
set(axes1,'DataAspectRatio',[1 1 1],'Layer','top','TickDir','out');
