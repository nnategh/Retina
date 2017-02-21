classdef Sigma < Block
    % SIGMA implements multiplication
    methods
        function y = forward(obj, x)
            % FORWARD implements y = w * x + b
            %
            % Parameters
            % ----------
            % - x: x{1}, x{2}, x{3}
            %   x{1} is x
            %   x{2} is w
            %   x{3} is b
            y = x{2} * x{1} + x{3};
        end
    end
end