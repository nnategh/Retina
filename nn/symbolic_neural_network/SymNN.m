classdef SymNN < handle
    %Symbolic Neural Network
    
    properties
        layers
        s
        
        L
        x
        y
        w
        b
        z
        a
    end
    
    methods
        function obj = SymNN()
            obj.layers = [1, 2, 1]; 
            obj.s = @purelin; % logsig, tansig
        end
        
        function init_x(obj)
            obj.x = sym('x', [obj.layers(1), 1]);
        end
        
        function init_y(obj)
            obj.y = sym('y', [obj.layers(end), 1]);
        end
        
        function init_w(obj)
            obj.w = cell(obj.L, 1);
            for l = 1:obj.L
                formatting = [sprintf('w_%d', l), '_%d_%d'];
                obj.w{l} = sym(formatting, [obj.layers(l + 1), obj.layers(l)]);
            end
        end
        
        function init_b(obj)
            obj.b = cell(obj.L, 1);
            for l = 1:obj.L
                formatting = [sprintf('b_%d', l), '_%d_%d'];
                obj.b{l} = sym(formatting, [obj.layers(l + 1), 1]);
            end
        end
        
        function init(obj)
            % L
            obj.L = length(obj.layers) - 1;
            % x
            obj.init_x();
            % y
            obj.init_y();
            % w
            obj.init_w();
            % b
            obj.init_b();
            % z
            obj.z = cell(obj.L, 1);
            % a
            obj.a = cell(obj.L, 1);
        end
        
        function forward_step(obj)
            % first layer
            obj.z{1} = obj.w{1} * obj.x + obj.b{1};
            obj.a{1} = obj.s(obj.z{1});
            % others
            for l = 2:obj.L
                obj.z{l} = obj.w{l} * obj.a{l - 1} + obj.b{l};
                obj.a{l} = obj.s(obj.z{l});
            end
        end
        
        function print_w(obj)
            disp('Weights:');
            for l = 1:obj.L
                disp(obj.w{l});
            end
        end
        
        function print_b(obj)
            disp('Biases:');
            for l = 1:obj.L
                disp(obj.b{l});
            end
        end
        
        function print_a(obj)
            disp('Activations:');
            for l = 1:obj.L
                disp(obj.a{l});
            end
        end
        
        function print_output(obj)
            disp('Output:');
            disp(collect(obj.a{end}, obj.x));
        end
        
        function run(obj)
            obj.init();
            
            obj.forward_step();
        end
    end
    
end

