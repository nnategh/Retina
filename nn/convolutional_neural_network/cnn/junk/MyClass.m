classdef MyClass < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        a
    end
    
    methods
        function set.a(obj, val)
            obj.a = val;
            disp('set.a');
        end
        
        function setA(obj, val)
            obj.a = val;
        end
        
        function val = get.a(obj)
            val = obj.a;
            disp('get.a');
        end
    end
    
end

