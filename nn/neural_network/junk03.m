close all;
clear;
clc;

syms x y b t

bump(x, y, b, t) = heaviside((cos(t) * x + sin(t) * y) + b) - heaviside((cos(t) * x + sin(t) * y) - b);

tower(x, y, b) = sym(0);

for t = 0:20:179
    tower(x, y, b) = tower(x, y, b) + bump(x, y, b, deg2rad(t));
    fsurf(tower(x, y, 0.1));
    title(t);
    
    pause();
end
