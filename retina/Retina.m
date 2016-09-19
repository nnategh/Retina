classdef Retina < handle
    %Retina
    
    properties
        stimulus
        number_of_bipolar_cells
        number_of_amacrine_cells
        number_of_ganglion_cells
        
        bipolar_layer
        amacrine_layer
        ganglion_layer
    end
    
    methods
        function obj = Retina(...
                stimulus, ...
                number_of_bipolar_cells, ...
                number_of_amacrine_cells, ...
                number_of_ganglion_cells ...
        )
            obj.stimulus = Retina.zero_mean_unit_variance(stimulus);
            obj.number_of_bipolar_cells = number_of_bipolar_cells;
            obj.number_of_amacrine_cells = number_of_amacrine_cells;
            obj.number_of_ganglion_cells = number_of_ganglion_cells;
            
            obj.init();
        end
        
        function init(obj)
            % bipolar
            obj.bipolar_layer = BipolarLayer(...
                obj.number_of_bipolar_cells, ...
                obj.stimulus, ...
                [], ...
                [] ...
            );
            
            % amacrine
            obj.amacrine_layer = AmacrineLayer(...
                obj.number_of_amacrine_cells, ...
                obj.bipolar_layer ...
            );
            
            % ganglion
            obj.ganglion_layer = GanglionLayer(...
                obj.number_of_ganglion_cells, ...
                obj.bipolar_layer, ...
                obj.amacrine_layer ...
            );
            
        end
        
        function show_cell_arrangement(obj)
            figure('Name', 'Cell Arrangement', 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
            
            rows = 3;
            cols = 1;
            width = 1000;
            height = 100;
            
            % bipolar
            subplot(rows, cols, 1);
            image = obj.bipolar_layer.get_image_of_cell_arrangement(width, height, [0, 1, 0], 'B');
            imshow(image)
            title('Bipolar Layer');
            
            % amacrine
            subplot(rows, cols, 2);
            image = obj.amacrine_layer.get_image_of_cell_arrangement(width, height, [1, 0, 0], 'A');
            imshow(image)
            title('Amacrine Layer');
            
            % ganglion
            subplot(rows, cols, 3);
            image = obj.ganglion_layer.get_image_of_cell_arrangement(width, height, [0, 0, 1], 'G');
            imshow(image)
            title('Ganglion Layer');
            
        end
        
        function show_stimulus(obj)
             h = figure();
             imshow(obj.stimulus, [min(obj.stimulus(:)), max(obj.stimulus(:))]);
             set(h, 'Name', 'Stimulus', 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
             title('Stimulus');
             xlabel('Time (s)');
        end
        
        function show_stimulus2(obj)
             h = figure();
             image = obj.stimulus;
             image = image - min(image(:));
             image = image / max(image(:));
             
             % parameters
             line_width = 5;
             x = 5;
             delta_x = 10;
             padding = 2;
             
             % bipolar layer
             for i = 1:length(obj.bipolar_layer.cells)
                 cell = obj.bipolar_layer.cells{i};
                 y1 = cell.rf(1);
                 y2 = cell.rf(2);
                 image = insertShape(image, 'line', [x, y1 + padding, x, y2 - padding], 'Color', 'green', 'LineWidth', line_width); 
             end
             
             % amacrine layer
             x = x + delta_x;
             for i = 1:length(obj.amacrine_layer.cells)
                 cell = obj.amacrine_layer.cells{i};
                 y1 = obj.bipolar_layer.cells{cell.rf(1)}.rf(1);
                 y2 = obj.bipolar_layer.cells{cell.rf(end)}.rf(end);
                 image = insertShape(image, 'line', [x, y1 + padding, x, y2 - padding], 'Color', 'red', 'LineWidth', line_width); 
             end
             
             % ganglion layer
             x = x + delta_x;
             for i = 1:length(obj.ganglion_layer.cells)
                 cell = obj.ganglion_layer.cells{i};
                 y1 = obj.bipolar_layer.cells{cell.rf.bipolar_layer(1)}.rf(1);
                 y2 = obj.bipolar_layer.cells{cell.rf.bipolar_layer(end)}.rf(end);
                 image = insertShape(image, 'line', [x, y1 + padding, x, y2 - padding], 'Color', 'blue', 'LineWidth', line_width); 
             end
             
             % imshow(image, [min(obj.stimulus(:)), max(obj.stimulus(:))]);
             imshow(image);
             set(h, 'Name', 'Stimulus', 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
             title('Stimulus');
             xlabel('Time (s)');
        end
        
        function run(obj)
            % run
            obj.bipolar_layer.run();
            obj.amacrine_layer.run();
            obj.ganglion_layer.run();
            
            % show results
            % --stimulus
            obj.show_stimulus2();
            
            % --cell arrangement
            obj.show_cell_arrangement();
            
            % --layers
            Retina.show_output_signals_of_layer(obj.bipolar_layer);
            Retina.show_output_signals_of_layer(obj.amacrine_layer);
            Retina.show_output_signals_of_layer(obj.ganglion_layer);
        end
    end
    
    methods (Static)
        function C = temporal_conv2(A, B)
            C = zeros(size(A));
            for i = 1:size(A, 1)
                C(i, :) = conv(A(i, :), B(i, :), 'same');
            end
        end
        
        function X = zero_mean_unit_variance(X)
            X = double(X);
            X = X / max(X(:));
            X = X - mean(X(:));
            X = X / std(X(:));
        end
        
        function show_output_signals_of_layer(layer)
            figure('Name', layer.name, 'NumberTitle', 'off', 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
            
            rows = length(layer.cells);
            cols = 1;
            
            for i = 1:length(layer.cells)
                cell = layer.cells{i};
                
                subplot(rows, cols, i);
                plot(cell.output);
                set(gca, 'XTick', []);
                title(sprintf('%s%d', cell.name(1), i));
            end
            
            xlabel('Time (s)');
        end
    end
end

