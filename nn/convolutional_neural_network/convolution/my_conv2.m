function B = my_conv2( A, K )
%2D Convolution
%   B = A * K
[M, N] = size(A);
[m, n] = size(K);
B = zeros(M - m + 1, N - n + 1);

for i = 1:size(B, 1)
    for j = 1:size(B, 2)
        tmp = A(i:i+m-1, j:j+n-1) .* K;
        B(i, j) = sum(tmp(:));
    end
end

end

