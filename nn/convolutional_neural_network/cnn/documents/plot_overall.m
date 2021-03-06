%% Initialization
close('all');
clear();
clc();

%% Filenames
filenames = {
    'fig.4.png', ...
    '1.png', ...
    '2.png', ...
    '3.png', ...
    '4.png', ...
    '5.png' ...
};

%% Plot
% - fig4
subplot(2, 5, 1:5);
imshow(filenames{1});
title('Figure 4');
% - topologies
for i = 1:5
    subplot(2, 5, 5 + i);
    imshow(filenames{1 + i});
    title(num2str(i));
end
