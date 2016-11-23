close all;
clear;
clc;

syms x1 x2
w0 = 1;
w1 = 1;
w2 = 0;

for w0 = 0:0.1:10
    fsurf(logsig(w0 + w1 * x1 + w2 * x2));
    xlabel('x'), ylabel('y'), zlabel('z');
    zlim([0, 1]);
    set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
    drawnow;
    
    pause(0.01);
end