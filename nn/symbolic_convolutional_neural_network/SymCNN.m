classdef SymCNN < handle
    %Symbolic Neural Network
    
    properties
        kernel_sizes
        input_size
        layers
        s
        
        L
        x
        w
        b
        z
        a
    end
    
    methods
        function obj = SymCNN()
            obj.kernel_sizes = [
                2, 2, 2
                2, 2, 1
            ];
            obj.input_size = [3, 3, 3];
            
            obj.s = @purelin; % logsig, tansig
        end
        
        function init_layers(obj)
            obj.layers = zeros(obj.L, 2);
            % first layer
            obj.layers(1, :) = obj.input_size(1:2) - obj.kernel_sizes(1, 1:2) + 1;
            % other layers
            for l = 2:obj.L
                obj.layers(l, :) = obj.layers(l-1, :) - obj.kernel_sizes(l, 1:2) + 1;
            end 
        end
        
        function init_x(obj)
            obj.x = sym('x', obj.input_size);
        end
        
        
        function init_w(obj)
            obj.w = cell(obj.L, 1);
            for l = 1:obj.L
                formatting = [sprintf('w_%d', l), '_%d_%d_%d'];
                obj.w{l} = sym(formatting, obj.kernel_sizes(l, :));
            end
        end
        
        function init_b(obj)
            obj.b = cell(obj.L, 1);
            for l = 1:obj.L
                formatting = [sprintf('b_%d', l), '_%d_%d'];
                obj.b{l} = sym(formatting, obj.layers(l, :));
            end
        end
        
        function init(obj)
            % L
            obj.L = size(obj.kernel_sizes, 1);
            % layers
            obj.init_layers();
            % x
            obj.init_x();
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
            tmp = conv3(obj.x, obj.w{1});
            obj.z{1} = tmp + repmat(obj.b{1}, [1, 1, size(tmp, 3)]);
            obj.a{1} = obj.s(obj.z{1});
            % others
            for l = 2:obj.L
                tmp = conv3(obj.a{l - 1}, obj.w{l});
                obj.z{l} = tmp + repmat(obj.b{l}, [1, 1, size(tmp, 3)]);
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

