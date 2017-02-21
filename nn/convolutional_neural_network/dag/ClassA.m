classdef ClassA < handle
    methods
        function func1(obj)
            
        end

        function func2(obj)
            disp(obj.func1())
        end
    end
end