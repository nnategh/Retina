function res = my_shuffle( a )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

check = zeros(size(a), 'logical');
res = zeros(size(a));

n = length(a);
for i = 1:n
    index = randi(n);
    while check(index)
        index = index + 1;
        if index > n
            index = 1;
        end
    end
    res(i) = a(index);
    check(index) = true;
end

end

