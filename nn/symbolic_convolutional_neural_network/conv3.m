function B = conv3( A, K )
%3D Convolution (valid part)
%   B = A * k

for i = 1:3
    K = flip(K, i);
end

[M, N, O] = size(A);
[m, n, o] = size(K);

for i = 1:(M - m + 1)
    for j = 1:(N - n + 1)
        for k = 1:(O - o + 1)
            tmp = A(i:i+m-1, j:j+n-1, k:k+o-1) .* K;
            B(i, j, k) = sum(tmp(:));
        end
    end
end

end

