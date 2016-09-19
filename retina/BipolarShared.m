classdef BipolarShared < handle
    %UNTITLED16 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nonlinear_transform_params
    end
    
    methods
        function obj = BipolarSharedclc()
            obj.nonlinear_transform_params.threshold = 0;
            obj.nonlinear_transform_params.slope = 1;
        end
        
        function y = nonlinear_transform(obj, x)            
            threshold = obj.nonlinear_transform_params.threshold;
            slope = obj.nonlinear_transform_params.slope;
            
            y = zeros(size(x));
            i = x > threshold;
            y(i) = slope * x(i) - threshold;
        end
    end
    
end

