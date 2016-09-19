classdef RetinalCircuit < handle
    %Retinal Circuit computes object motion
    %   http://www.jneurosci.org/content/28/27/6807.full
    
    properties
        background
        object
        F                           % F(x, y, tau) is the linear response kernel of the bipolar cell at position (x, y) and delay tau
        number_of_bipolars
        bipolar_background_image
        bipolars_background
        bipolar_object_image
        bipolars_object
        ganglion
        amacrine
        threshold
        slope
    end
    
    methods
        function obj = RetinalCircuit(background, object, F, number_of_bipolars)
            obj.background = RetinalCircuit.zero_mean_unit_variance(background);
            obj.object = RetinalCircuit.zero_mean_unit_variance(object);
            obj.number_of_bipolars = number_of_bipolars;
            
            if isempty(F)
                obj.simulate_F();
            else
                obj.F = RetinalCircuit.zero_mean_unit_variance(F);
            end
            
            obj.threshold = [];
            obj.slope = [];
        end
        
        function init(obj)
            
        end
        
        function simulate_F(obj)
            %% Parameters
            signal_surround = load('surround.mat', 'data');
            signal_surround = signal_surround.data;
            signal_center = load('center.mat', 'data');
            signal_center = signal_center.data;

            %% Bipolar Kernel
            bk = BipolarKernel();

            bk.signal_surround = signal_surround;
            bk.signal_center = signal_center;
            bk.height = floor(size(obj.object, 1) / obj.number_of_bipolars);

            bk.run(false);
            
            obj.F = repmat(bk.kernel, obj.number_of_bipolars, 1);
            obj.F = obj.F(1: size(obj.object, 1), :);
        end
        
        function output_image = draw_region_of_bipolars(obj, input_image)
            output_image = input_image;
            
            width = size(output_image, 2);
            height = size(output_image, 1);
            height_of_region = floor(height / obj.number_of_bipolars);
            
            % draw vertical lines
            for i = 1:obj.number_of_bipolars - 1
                y = i * height_of_region;
                output_image = insertShape(output_image, 'Line', [0, y, width, y], 'Color', [1, 0, 0]);
            end
        end
         
        function show_regions(obj, image, text)
            image = obj.draw_region_of_bipolars(image);
            imshow(image, [min(image(:)), max(image(:))]);
            title(text, 'interpreter', 'latex');
        end
        
        function show_results(obj)
           rows = 6;
           cols = 2;
           
           figure(...
               'Name', 'A Retinal Circuit That Computes Object Motion',...
               'NumberTitle','off',...
               'Units','normalized',...
               'OuterPosition',[0 0 1 1]...
           );
       
           % stimuli
           subplot(rows, cols, 1);
           obj.show_regions(obj.background, 'Background');
           
           subplot(rows, cols, 2);
           obj.show_regions(obj.object, 'Object');
           
           % F
           subplot(rows, cols, 3);
           obj.show_regions(obj.F, '$$F(x, y, \tau)$$ - linear response kernel of the bipolar cell');
           
           subplot(rows, cols, 4);
           obj.show_regions(obj.F, '$$F(x, y, \tau)$$ - linear response kernel of the bipolar cell');

%            subplot(rows, cols, 3);
%            imshow(obj.F, [min(obj.F(:)), max(obj.F(:))]);
%            title('$$F(x, y, \tau)$$ - linear response kernel of the bipolar cell', 'interpreter', 'latex');
%            
%            subplot(rows, cols, 4);
%            imshow(obj.F, [min(obj.F(:)), max(obj.F(:))]);
%            title('$$F(x, y, \tau)$$ - linear response kernel of the bipolar cell', 'interpreter', 'latex');
           
           % b'
           % - background
           obj.bipolar_background_image = RetinalCircuit.temporal_conv2(obj.background, obj.F);
           subplot(rows, cols, 5);
           obj.show_regions(obj.bipolar_background_image, 'b''(t) - predicted response of bipolar cell');
           
           % - object
           obj.bipolar_object_image = RetinalCircuit.temporal_conv2(obj.object, obj.F);
           subplot(rows, cols, 6);
           obj.show_regions(obj.bipolar_object_image, 'b''(t) - predicted response of bipolar cell');
           
           % b' (different phases)
           offset = 2;
           new_cols = obj.number_of_bipolars * cols + offset;
           
           % - background
           width_of_region = floor(size(obj.background, 1) / obj.number_of_bipolars);
           for i = 1:obj.number_of_bipolars
                obj.bipolars_background(i, :) = ...
                    sum(obj.bipolar_background_image(...
                        (i - 1) * width_of_region + 1 : i * width_of_region, :)); 
           end
           
           for i = 1:obj.number_of_bipolars
                subplot(rows, new_cols, 3 * new_cols + i);
                area(obj.bipolars_background(i, :), 'FaceColor', 'white');
                set(gca,'XLim', [min(obj.bipolars_background(i, :)), max(obj.bipolars_background(i, :))], 'XTick', [], 'YTick', [], 'Color', 'black');
           end
           
           
           % - object
           width_of_region = floor(size(obj.object, 1) / obj.number_of_bipolars);
           for i = 1:obj.number_of_bipolars
                obj.bipolars_object(i, :) = ...
                    sum(obj.bipolar_object_image(...
                        (i - 1) * width_of_region + 1 : i * width_of_region, :)); 
           end
           
           for i = 1:obj.number_of_bipolars
                subplot(rows, new_cols, 3 * new_cols + (new_cols / 2) + i + (offset / 2));
                area(obj.bipolars_object(i, :), 'FaceColor', 'white');
                set(gca, 'Xlim', [min(obj.bipolars_object(i, :)), max(obj.bipolars_object(i, :))], 'XTick', [], 'YTick', [], 'Color', 'black');
           end
           
           % N(b')
           if isempty(obj.threshold)               
               obj.threshold = min(max(obj.bipolars_background(:)), max(obj.bipolars_object(:))) / 2;
           end
           if isempty(obj.slope)
               obj.slope = 0.1;
           end
           
%            fprintf('obj.threshold:\t%f\n', obj.threshold);
%            fprintf('obj.slope:\t\t%f\n', obj.slope);
           
           % - background
           for i = 1:obj.number_of_bipolars
                obj.bipolars_background(i, :) = obj.nonlinear_transform(obj.bipolars_background(i, :));
           end
           
           for i = 1:obj.number_of_bipolars
                subplot(rows, new_cols, 4 * new_cols + i);
                area(obj.bipolars_background(i, :), 'FaceColor', 'white');
                set(gca, 'XLim', [min(obj.bipolars_background(i, :)), max(obj.bipolars_background(i, :))], 'XTick', [], 'YTick', [], 'Color', 'black');
           end
           
           % - object
           for i = 1:obj.number_of_bipolars
                obj.bipolars_object(i, :) = obj.nonlinear_transform(obj.bipolars_object(i, :));
           end
           
           for i = 1:obj.number_of_bipolars
                subplot(rows, new_cols, 4 * new_cols + (new_cols / 2) + i + (offset / 2));
                area(obj.bipolars_object(i, :), 'FaceColor', 'white');
                set(gca, 'XLim', [min(obj.bipolars_object(i, :)), max(obj.bipolars_object(i, :))], 'XTick', [], 'YTick', [], 'Color', 'black');
           end
           
           
           % amacrine
           obj.amacrine = sum(obj.bipolars_background);
           subplot(rows, cols, 11);
           area(obj.amacrine, 'FaceColor', 'white');
           set(gca,'XLim', [min(obj.amacrine), max(obj.amacrine)], 'XTick', [], 'YTick', [], 'Color', 'black');
           title('Amacrine');
           xlabel('Time (sec)');
%            ylabel('Rate (Hz)');
           
           % ganglion
           obj.ganglion = sum(obj.bipolars_object);
           subplot(rows, cols, 12);
           area(obj.ganglion, 'FaceColor', 'white');
           set(gca,'XLim', [min(obj.ganglion), max(obj.ganglion)], 'XTick', [], 'YTick', [], 'Color', 'black');
           title('Ganglion');
           xlabel('Time (sec)');
%            ylabel('Rate (Hz)');

           
           % plot of N(.)
           figure('Name', 'Nonlinear Transform', 'NumberTitle', 'off');
           x = -(1 + obj.threshold):0.1:(1 + obj.threshold);
           plot(...
               x,...
               obj.nonlinear_transform(x),...
               'LineWidth', 2);
           set(gca, 'XTickLabel', [], 'YTickLabel', []);
           grid on, grid minor;
           title(sprintf('N(b) - threshold: %.1f, slope: %.1f', obj.threshold, obj.slope), 'interpreter', 'latex');
           xlabel('Input', 'interpreter', 'latex');
           ylabel('Output', 'interpreter', 'latex');
           axis equal;
           
        end
        
        function y = nonlinear_transform(obj, x)
            y = zeros(size(x));
            for i = 1:length(x)
                if x(i) > obj.threshold
                    y(i) = obj.slope * (x(i) - obj.threshold);
                end
            end
        end
        
        function run(obj)
            obj.show_results();
        end
    end
    
    methods (Static)
        function C = temporal_conv2(A, B)
            A = double(A);
            B = double(B);
            C = [];
            for i = 1:size(A, 1)
                C(end + 1, :) = conv(A(i, :), B(i, :));
            end
            
            C = C(:, 1:size(A, 2));
        end
        
        function X = zero_mean_unit_variance(X)
            X = double(X);
            X = X - mean(X(:));
            X = X / std(X(:));
        end
    end
    
end

