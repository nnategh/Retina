function approximate_with_step_function1( f, x, number_of_intervals )
% Approximate a function with step function (heaviside function).

figure;
plot(x, f(x), 'Color', 'red', 'LineStyle', '-', 'LineWidth', 2);

y = zeros(size(x));
min_x = min(x(:));
max_x = max(x(:));
width = (max_x - min_x) / number_of_intervals;
for i = 1:length(x)
    c = floor((x(i) - min_x) / width);
    
    y(i) = f((floor(c) + 0.5) * width + min_x); % int(c) * w + w/2
end

hold('on');
plot(x, y, 'Color', 'blue', 'LineStyle', '--');
hold('off');

end

