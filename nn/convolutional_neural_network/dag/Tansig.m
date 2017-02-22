classdef Tansig < Block
    % TANSIG implements hyperbolic tangent sigmoid function
    methods
        function y = forward(obj, x)
            y = tansig(x{1});
        end
    end
end