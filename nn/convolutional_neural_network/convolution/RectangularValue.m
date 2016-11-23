classdef RectangularValue < handle
    %Rectangular Value
    
    properties
        rows
        cols
        value
    end
    
    methods
        function obj = RectangularValue(rows, cols)
            obj.rows = rows;
            obj.cols = cols;
            obj.value = zeros(rows, cols);
        end
    end
    
end

