classdef CellLayer < handle
    %Cell Layer contains an array of cells
    
    properties
        cells
    end
    
    methods
        function obj = CellLayer(number_of_cells, cell_constructor)
            % cells
            obj.cells = {};
            for i = 1:number_of_cells
                obj.cells{end + 1} = cell_constructor();
            end
            obj.cells = obj.cells';
            
            % arrange
            obj.uniform_arrange();
        end
        
        function uniform_arrange(obj)
            number_of_cells = length(obj.cells);
            dx = 1 / number_of_cells;
            
            radius = dx / 2;
            x = radius;
            for i = 1:number_of_cells
                obj.cells{i}.radius = radius;
                obj.cells{i}.center = x;
                x = x + dx;
            end
        end
        
        function image = get_image_of_cell_arrangement(obj, width, height, color, cell_name)
            image = ones(height, width, 3);
            
            for i = 1:length(obj.cells)
                cell = obj.cells{i};
                center = width * cell.center;
                radius = width * cell.radius;
                x = center - radius + 1;
                y = 1;
                w = 2 * radius;
                h = height;
                
                image = insertShape(...
                    image, ...
                    'Rectangle', [x, y, w, h], ...
                    'Color', color ...
                );
            
%                 image = insertMarker(...
%                     image, ...
%                     [center, h / 2], ...
%                     '+', ...
%                     'Color', color, ...
%                     'Size', 5 ...
%                 );
                
                connections = '';
                if strcmp(cell_name, 'A')
                    % bipolar_layer
                    for j = cell.rf
                        connections = [connections, num2str(j), ','];
                    end
                    connections = connections(1:end - 1);
                    connections = sprintf('{B{%s}}', connections);
                end
                
                if strcmp(cell_name, 'G')
                    % bipolar_layer
                    bipolar_layer_text = '';
                    for j = cell.rf.bipolar_layer
                        bipolar_layer_text = [bipolar_layer_text, num2str(j), ','];
                    end
                    bipolar_layer_text = bipolar_layer_text(1:end - 1);
                    bipolar_layer_text = sprintf('B{%s}', bipolar_layer_text);
                    
                    % amacrine_layer
                    amacrine_layer_text = '';
                    for j = cell.rf.amacrine_layer
                        amacrine_layer_text = [amacrine_layer_text, num2str(j), ','];
                    end
                    amacrine_layer_text = amacrine_layer_text(1:end - 1);
                    amacrine_layer_text = sprintf('A{%s}', amacrine_layer_text);
                    
                    connections = sprintf('{%s, %s}', bipolar_layer_text, amacrine_layer_text);
                end
                
                image = insertText(...
                    image, ...
                    [center, h / 2], ...
                    sprintf('%s%d %s', cell_name, i, connections), ...
                    'BoxColor', 'white', ...
                    'AnchorPoint', 'center' ...
                );
            end
        end
    end
    
end

