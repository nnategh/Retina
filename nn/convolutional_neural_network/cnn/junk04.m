% init
close('all');
clear();
clc();

% load db, params
load('D:\PhD\MSU\codes\Retina\nn\convolutional_neural_network\cnn\data\ep20c11\noisy\results\fig4.2.convrelu\db.mat')
% load('D:\PhD\MSU\codes\Retina\nn\convolutional_neural_network\cnn\data\ep20c11\noisy\results\fig4.2.convrelu\params_snr_-10.mat')
load('D:\PhD\MSU\codes\Retina\nn\convolutional_neural_network\cnn\data\ep20c11\params.mat')

% actual y
plot(y{1}, 'Color', 'blue')

% expected y
% - resize params
filter_size = [20, 1];
af = @(x) max(x, 0); % activation function
%   - w_B
w_B = DataUtils.resize(w_B, filter_size);
%   - w_A
w_A = DataUtils.resize(w_A, filter_size);
%   - w_G
w_G = DataUtils.resize(w_G, filter_size);

% - compute vars
%   - B
B = af(conv(x{1}, w_B, 'valid'));
%   - A
A = af(conv(x{1}, w_A, 'valid'));
%   - A + B
AB = A + B;
%   - G
G = af(conv(AB, w_G, 'valid'));
G = flipud(G);

% - plot
hold('on');
plot(G, 'Color', 'red');