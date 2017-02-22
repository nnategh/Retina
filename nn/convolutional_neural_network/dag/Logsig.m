classdef Logsig < Block
    % LOGSIG implements log-sigmoid function
    methods
        function y = forward(obj, x)
            y = logsig(x{1});
        end
    end
end