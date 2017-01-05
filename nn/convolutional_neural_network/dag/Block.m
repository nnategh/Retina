classdef Block
    %BLOCK is a layer of computation
    
    properties
    end
    
    methods
        function y = forward(obj, x, w)
        end
        
        function [dzdx, dzdw] = backward(obj, x, w, dzdy)
            % y
            y = obj.forward(x, w);
            
            % vectorize dzdy
            vec_dzdy = reshape(dzdy, numel(dzdy), 1);
            
            % dzdz
            dzdx = cell(length(x), 1);
            for i = 1 : length(x)
                dzdx{i} = zeros(size(x{i}));
                
                for j = 1 : numel(x{i})
                    x{i}(j) = x{i}(j) + eps;
                    
                    dydx = (obj.forward(x, w) - y) / eps;
                    vec_dydx = reshape(dydx, numel(dydx), 1);
                    
                    dzdx{i}(j) = dot(vec_dzdy, vec_dydx);
                    
                    x{i}(j) = x{i}(j) - eps;
                end
            end
            
            % dzdw
            dzdw = cell(length(w), 1);
            for i = 1 : length(w)
                dzdw{i} = zeros(size(w{i}));
                
                for j = 1 : numel(w{i})
                    w{i}(j) = w{i}(j) + eps;
                    
                    dydw = (obj.forward(x, w) - y) / eps;
                    vec_dydw = reshape(dydw, numel(dydw), 1);
                    
                    dzdw{i}(j) = dot(vec_dzdy, vec_dydw);
                    
                    w{i}(j) = w{i}(j) - eps;
                end
            end
        end
    end
    
end

