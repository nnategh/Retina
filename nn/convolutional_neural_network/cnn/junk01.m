%%
close('all');
clear;
clc;

%%
[x,y,z] = meshgrid(-2:.2:2,-2:.25:2,-2:.16:2);
v = x.*exp(-x.^2-y.^2-z.^2);
xslice = [0]; 
yslice = []; 
zslice = [];
slice(x,y,z,v,xslice,yslice,zslice)
colormap hsv