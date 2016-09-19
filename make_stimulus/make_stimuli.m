close all;
clear;
clc;

% properties
number_of_simulations = 20;
frame_rate = 25;
delay = 1 / frame_rate;
condition = 'global'; % ('global' or 'differential').

background.strip.width = 500;
background.strip.height = 10;
background.number_of_strips = 50;


circle.radius = 50;
circle.thickness = 5;
circle.color = [128 128 128];


% background.strip
background.strip.black = zeros(background.strip.height, background.strip.width, 'uint8');
background.strip.white = 255 - background.strip.black;

% background
background.shape = background.strip.white;
for i = 2:background.number_of_strips
    if mod(i, 2) == 0
        background.shape = vertcat(background.shape, background.strip.black);
    else
        background.shape = vertcat(background.shape, background.strip.white);
    end
end
background.inv_shape = background.shape;

% square
[h, w] = size(background.shape);
h_2 = h / 2;
w_2 = w / 2;


square.width = 2 * circle.radius;
square.top_left = [h_2 w_2] - [circle.radius circle.radius];
r1 = square.top_left(1);
r2 = square.top_left(1) + square.width;
c1 = square.top_left(2);
c2 = square.top_left(2) + square.width;

circle.points = [];
for r = r1:r2
    for c = c1:c2
        if (r - h_2) ^ 2 + (c - w_2) ^ 2 <= circle.radius ^ 2
            circle.points(end + 1) = (c - 1) * h + r;
        end
    end
end

% movie
for i = 1:number_of_simulations
    tmp = background.shape;
    
    if strcmp(condition, 'differential')
        tmp(circle.points) = background.inv_shape(circle.points);
    end
    
    tmp = insertShape(tmp, 'circle', [w_2 h_2 circle.radius], 'LineWidth', circle.thickness, 'Color', circle.color);
    
    imshow(tmp);
    pause(delay);
    
    background.shape = circshift(background.shape, 1);
    
    if strcmp(condition, 'differential')
        background.inv_shape = circshift(background.inv_shape, -1);
    end
end
