classdef Block < handle
    %BLOCK is a layer of computation
    
    properties
    end
    
    methods
        function y = forward(obj, x)
            %FORWARD moves forward
            %
            % Parameters
            % ----------
            % - x: cell vector of double array
            %   List of inputs containing `vars` and `paras`
            %
            % Returns
            % -------
            % - y: double array 
            %   Output
        end
        
        function [dzdx] = backward(obj, x, dzdy)
            % BACKWARD moves backward
            %
            % Parameters
            % ----------
            % - x: cell vector of double array
            %   List of inputs containing `vars` and `paras`
            % - dzdy: double array
            %   Derivative of `cost` with respect to `output` of block
            %
            % Returns
            % -------
            % - dzdx: cell vector of double array
            %   List of derivatives of `cost` with respect ot `inputs` fo block
            
            
            % y
            y = obj.forward(x, w);

            % dzdz
            dzdx = cell(length(x), 1);
            for i = 1 : length(x)
                dzdx{i} = zeros(size(x{i}));
                
                for j = 1 : numel(x{i})
                    x{i}(j) = x{i}(j) + eps;
                    
                    dydx = (obj.forward(x) - y) / eps;
                    dzdx{i}(j) = dot(dzdy(:), dydx(:));
                    
                    x{i}(j) = x{i}(j) - eps;
                end
            end
        end
    end
    
end

