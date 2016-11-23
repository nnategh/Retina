%%
close('all');
clear;
clc;

%% Parameters
folder_path = '/Users/yaza/Desktop/neda/codes/matlab/videos/tiny-insect-flight';
filename_extension = 'jpg';
number_of_x_slices = 5;
delay = 0.1;

%% Read files
files = dir([folder_path, '/*.', filename_extension]);


%% Play movie

% for i = 1:length(files)
%     imshow(fullfile(files(i).folder, files(i).name));
%     pause(delay);
% end


%% Play slice

% v
I = imread(fullfile(files(1).folder, files(1).name));
[m, n] = size(I);
p = length(files);
v = zeros(m, n, p);

for i = 1:p
    I = imread(fullfile(files(i).folder, files(i).name));
    I = double(I);
    I = I / max(I(:));
    
    v(:, :, i) = I;
end

% slice
fig = figure('Name', 'Video', 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
ax = axes(fig);

v = permute(v, [2, 3, 1]);
v = flip(v, 3);
v = flip(v, 1);

% for i = 1:p
%     slice(ax, v, i, [], []);
%     axis(ax, [1, p, 1, n, 1, m]);
%     xlabel(ax, 'z');
%     ylabel(ax, 'x');
%     zlabel(ax, 'y');
%     colormap('gray');
%     
%     pause(delay);
% end

if isempty(number_of_x_slices) || number_of_x_slices > p
    number_of_x_slices = p;
end

dx = (p - 1) / (number_of_x_slices - 1);
sx = 1:dx:p;
sx = floor(sx);

slice(ax, v, sx, [], []);
axis(ax, [1, p, 1, n, 1, m]);
xlabel(ax, 'Frames');
% ylabel(ax, 'x');
% zlabel(ax, 'y');
set(ax, ...
    'XTick', [1, p], 'XTickLabel', [1, p], ...
    'YTick', [1, n], 'YTickLabel', [n, 1], ...
    'ZTick', [1, m], 'ZTickLabel', [m, 1] ...
);
% grid('on');
% grid('minor');
colormap('gray');