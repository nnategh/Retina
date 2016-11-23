classdef SymNN < handle
    %Symbolic Neural Network
    
    properties
        dimensions
        transfer_function
        
        number_of_layers        
        weights
        outputs
    end
    
    methods
        function obj = SymNN()
            obj.dimensions = [1, 2, 1];
            obj.transfer_function = @purelin;
        end
        
        function make_weights(obj)
            obj.weights = cell(obj.number_of_layers - 1, 1);
            for i = 1:obj.number_of_layers - 1
                pre_name = sprintf('w_%d', i);
                obj.weights{i} = sym([pre_name, '_%d_%d'], [obj.dimensions(i + 1), obj.dimensions(i) + 1]);
            end
        end
        
        function make_outputs(obj)
            obj.outputs = cell(obj.number_of_layers, 1);
            obj.outputs{1} = sym('x', [obj.dimensions(1), 1]);
%             obj.outputs{1} = [1; obj.outputs{1}];
            
            for i = 2:obj.number_of_layers
                obj.outputs{i} = obj.transfer_function(obj.weights{i - 1} * [1; obj.outputs{i - 1}]);
%                 obj.outputs{i} = [1; obj.outputs{i}];
            end
        end
        
        function init(obj)
            obj.number_of_layers = length(obj.dimensions);
            obj.make_weights();
            obj.make_outputs();
        end
        
        function print_weights(obj)
            disp('Weights of layers:');
            for i = 1:length(obj.weights)
                disp(obj.weights{i});
            end
        end
        
        function print_outputs(obj)
            disp('Outputs of layers:');
            for i = 1:length(obj.outputs)
                disp(obj.outputs{i});
            end
        end
        
        function print_output(obj)
            disp('Output:');
            disp(collect(obj.outputs{end}, obj.outputs{1}));
        end
        
        function run(obj)
            obj.init();
        end
    end
    
end

