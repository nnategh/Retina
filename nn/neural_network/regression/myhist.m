function [ x, y ] = myhist( data, n )
%My Histogram

m = min(data);
M = max(data);
w = (M - m) / (n - 1);
% w = ceil(w);
data = data - (m - (w / 2));
% x = linspace(m, M, n);
x = linspace(m, M, n);
x = x';
y = zeros(size(x));

for i = 1:length(data)
    index = floor(data(i) / w) + 1;
    y(index) = y(index) + 1;
end

bar(x, y);

end
