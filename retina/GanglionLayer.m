classdef GanglionLayer < CellLayer
    %Ganglion Layer contains an array of ganglion cells
    
    properties (Constant)
        name = 'Ganglion Layer';
    end
    
    properties
        bipolar_layer
        amacrine_layer
    end
    
    methods
        function obj = GanglionLayer(number_of_cells, bipolar_layer, amacrine_layer)
            % cells
            obj@CellLayer(number_of_cells, @Ganglion);
            
            % bipolar layer
            obj.bipolar_layer = bipolar_layer;
            
            % amacrine layer
            obj.amacrine_layer = amacrine_layer;
            
            % receptive field
            obj.make_receptive_field_of_cells();
        end
                
        function make_receptive_field_of_cells(obj)
            for i = 1:length(obj.cells)                
                % biplar
                obj.cells{i}.rf.bipolar_layer = [];
                
                for j = 1:length(obj.bipolar_layer.cells)
                    if abs(obj.cells{i}.center - obj.bipolar_layer.cells{j}.center) <= obj.cells{i}.radius
                        obj.cells{i}.rf.bipolar_layer(end + 1) = j;
                    end
                end
                
                % amacrine
                obj.cells{i}.rf.amacrine_layer = [];
                
                for j = 1:length(obj.amacrine_layer.cells)
                    if abs(obj.cells{i}.center - obj.amacrine_layer.cells{j}.center) <= obj.cells{i}.radius
                        obj.cells{i}.rf.amacrine_layer(end + 1) = j;
                    end
                end
            end
        end
        
        function run(obj)
            threshold = 0;
            for i = 1:length(obj.cells)
                ganglion = obj.cells{i};
                
                % bipolar_layer
                ganglion.output = [];
                for j = ganglion.rf.bipolar_layer
                    bipolar = obj.bipolar_layer.cells{j};
                    if isempty(ganglion.output)
                        ganglion.output = bipolar.output;
                    else
                        ganglion.output = ganglion.output + bipolar.output;
                    end
                    
                end
                
                offset = 0.1;
                % amacrine_layer
                for j = ganglion.rf.amacrine_layer
                    amacrine = obj.amacrine_layer.cells{j};
                    ganglion.output = ganglion.output - ...
                        (1 / ganglion.radius) * (abs(ganglion.center - amacrine.center) + offset) * amacrine.output;
                end
                
                % threshold
                ganglion.output(ganglion.output < threshold) = 0;
            end
        end
    end
end