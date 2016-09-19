classdef AmacrineLayer < CellLayer
    %Amacrine Layer contains an array of amacrine cells
    
    properties (Constant)
        name = 'Amacrine Layer';
    end
    
    properties
        bipolar_layer
    end
    
    methods
        function obj = AmacrineLayer(number_of_cells, bipolar_layer)
            % cells
            obj@CellLayer(number_of_cells, @Amacrine);
            
            % bipolar layer
            obj.bipolar_layer = bipolar_layer;
            
            % receptive field
            obj.make_receptive_field_of_cells();
        end
                
        function make_receptive_field_of_cells(obj)
            for i = 1:length(obj.cells)                
                obj.cells{i}.rf = [];
                
                for j = 1:length(obj.bipolar_layer.cells)
                    if abs(obj.cells{i}.center - obj.bipolar_layer.cells{j}.center) <= obj.cells{i}.radius
                        obj.cells{i}.rf(end + 1) = j;
                    end
                end
            end
        end
        
        function run(obj)
            % bipolar_layer
            for i = 1:length(obj.cells)
                amacrine = obj.cells{i};
                
                amacrine.output = [];
                for j = amacrine.rf
                    bipolar = obj.bipolar_layer.cells{j};
                    
                    if isempty(amacrine.output)
                        amacrine.output = bipolar.output;
                    else
                        amacrine.output = amacrine.output + bipolar.output;
                    end
                end
            end
        end
    end
    
end

