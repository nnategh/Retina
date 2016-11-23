close all;
clear;
clc;

syms x y b theta

bump(x, y, b, theta) = heaviside((cos(theta) * x + sin(theta) * y) + b) - heaviside((cos(theta) * x + sin(theta) * y) - b);

b = 0.1;
t = 0;

for t = linspace(0, 360, 37)
    fcontour(gca, bump(x, y, b, deg2rad(t)));
    set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
    xlabel('x');
    title(t);
    
    pause();
end