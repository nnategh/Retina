classdef MovingImage < handle
    %MovingImage simulates random-walk translation on an image
    %   input: an image (grayscale); pixel size; movement step size in space and time.
    % 
    %   output: 
    
    properties
        filename                % path of input image (image could be any format and colorspace!)
        image                   % input grayscale image
        box                     % target area
        
        step_size_time_ms       % step size time (mili second)
        duration_ms             % duration of simulation (mili second)
        number_of_translations  % number of translations
        target_images           % array of target images [m x n x number_of_translations]
        
        pixel_size_um           % size of a pixel (micro meter)
        step_size_space_um      % step size space (micro meters)
        
        sampling_method         % sampling_method method (both | horizental | vertical)
        
        sampled_translations    % array of sample translations (nx2)
        intensity_values        % intensity values of sample points
        x_values                % relative x coordinates of sample points
        y_values                % relative y coordinates of sample points
        
        is_video_saved          % save the video of simulation
        video_filename          % name of video which must be saved
        video_frame_rate        % frame-reate of video which must be saved
    end
    
    properties (Constant)
        plot_line_width = 2;
        plot_color = 'black';
    end
    
    methods
        function obj = MovingImage()
            % is a constructor, and set the independant variables to thier
            % default values
            obj.filename = 'lena.jpg';
            
            obj.step_size_time_ms = 15;
            obj.duration_ms = 5 * 1000;
            
            obj.pixel_size_um = 100;
            obj.step_size_space_um = 9.2;
            
            obj.sampling_method = 'both';
            
            obj.is_video_saved = false;
            obj.video_filename = 'result';
            obj.video_frame_rate = 15;
            
            obj.box = [];
        end
        
        function init(obj)
            % initialize the dependant variables
            obj.image = imread(obj.filename);
            if size(obj.image, 3) == 3
                obj.image = rgb2gray(obj.image);
            end
            
            if isempty(obj.box)
                [height, width] = size(obj.image);
                c = 0.2;
                obj.box = [NaN, NaN, c * width, c * height];
            end
            
            if isnan(obj.box(1)) || isnan(obj.box(2))
                [height, width] = size(obj.image);
                obj.box(1) = (width / 2) - (obj.box(3) / 2);
                obj.box(2) = (height / 2) - (obj.box(4) / 2);
            end
            
            obj.number_of_translations = round(obj.duration_ms / obj.step_size_time_ms);
        end
        
        function px = um2px(obj, um)
            % convert um(micro meter) to px(pixel)
            px = round(um / obj.pixel_size_um);
        end
            
        % Show results
        
        function show_sampled_translations_image(obj, n)
            res = imtranslate(obj.image, obj.sampled_translations(n, :));
            
            res = cat(3, res, res, res);
                     
            res = insertShape(res, 'rectangle', obj.box, 'LineWidth', 5, 'Color', [255, 0, 0]);
        
            imshow(res);
        end
        
        function show_target_image(obj, n)
            res = imtranslate(obj.image, obj.sampled_translations(n, :));
            
            res = imcrop(res, obj.box);
            
            obj.target_images(:, :, n) = res;
        
            imshow(res);
        end
        
        function plot_intensity_time_series(obj)
            % show time series of intensity values
            I = imcrop(obj.image, obj.box);
            h = figure('Name', 'Pick a pixel', 'NumberTitle', 'off');
            imshow(I);
            set(gca, 'Visible', 'on', 'Box', 'on', 'XTick', [], 'YTick', []);
            
            [x, y] = ginput(1);
            x = int32(x);
            y = int32(y);
            close(h);
            
            rows = 2;
            cols = 3;
            figure('Name', 'Intensity time series of the selected pixel', 'NumberTitle', 'off');
            
            pose = ones(size(I));
            pose(y, x) = 0;
            subplot(rows, cols, 2);
            imshow(pose);
            set(gca, 'Visible', 'on', 'Box', 'on', 'XTick', [], 'YTick', []);
            title('Position');
            
            subplot(rows, cols, 4:6);
            tmp = obj.target_images(y, x, :);
            tmp = tmp(:);
            plot(tmp);
            ylim([0, 255]);
            title('Time Series');
            xlabel('sample');
            ylabel('intensity');
        end
        
        function plot_x_time_series(obj, n)
            res = zeros(obj.number_of_translations, 1);
            res(1:n) = obj.x_values(1:n);
            
            plot(...
                res, ...
                'LineWidth', MovingImage.plot_line_width, ...
                'Color', MovingImage.plot_color ...
            );
        end
        
        function plot_y_time_series(obj, n)
            res = zeros(obj.number_of_translations, 1);
            res(1:n) = obj.y_values(1:n);
            
            plot(...
                res, ...
                'LineWidth', MovingImage.plot_line_width, ...
                'Color', MovingImage.plot_color ...
            );
        end
        
        function show_results(obj, framerate)
           % show original image + sampled points + overlaid image
           h = figure(...
               'Name', 'Moving-Image Simulation', ...
               'NumberTitle','off', ...
               'Units','normalized', ...
               'OuterPosition', [0 0 1 1], ...
               'Color', 'white' ...
           );
           rows = 3;
           cols = 3;
           
           if obj.is_video_saved
               vw = VideoWriter(obj.video_filename, 'MPEG-4');
               vw.FrameRate = obj.video_frame_rate;
               open(vw);
           end
           
           delay = 1 / framerate;
           x_min = min(obj.x_values);
           x_max = max(obj.x_values);
           y_min = min(obj.y_values);
           y_max = max(obj.y_values);
           
           % original image
           figure(h), subplot(rows, cols, 1);
           imshow(obj.image);
           title('Original Image');
            
           for i = 1:obj.number_of_translations
               % sample points
               figure(h), subplot(rows, cols, 2);
               obj.show_sampled_translations_image(i);
               title('Translated Images');
%                xlabel(sprintf('(dx, dy) = (%d, %d)', ...
%                     obj.x_values(i), ...
%                     obj.y_values(i)...
%                 ));
               
               % overlaid image (zoomed in)
               figure(h), subplot(rows, cols, 3);
               obj.show_target_image(i);
               title('Target Area');
%                xlabel(sprintf('intensity = %d', ...
%                    obj.image(...
%                     round(obj.sampled_translations(i, 1)),...
%                     round(obj.sampled_translations(i, 2)))...
%                ));

               % x
               figure(h), subplot(rows, cols, 4:6);
               obj.plot_x_time_series(i);
               title('Time Series');
               xlabel('');
%                ylabel(sprintf('dx_{px} = [%d, %d]', x_min, x_max));
               ylabel('dx_{px}');
               ylim([x_min, x_max]);
               set(gca, ...
                   'XTick', [], ...
                   'YTick', [x_min, x_max], ...
                   'Box', 'off' ...
               );
               grid('on');

               % y
               figure(h), subplot(rows, cols, 7:9);
               obj.plot_y_time_series(i);
               xlabel('sample');
%                ylabel(sprintf('dy_{px} = [%d, %d]', y_min, y_max));
               ylabel('dy_{px}');
               % set(gca, 'XTickLabel', []);
               ylim([y_min, y_max]);
               set(gca, ...
                   'XTick', [], ...
                   'YTick', [y_min, y_max], ...
                   'Box', 'off' ...
               );
               grid('on');
               
               if obj.is_video_saved
                   writeVideo(vw, getframe(h));
               end
               
               pause(delay);
           end
           
           if obj.is_video_saved
               close(vw);
           end
        end
        
        function d = generate_random_space_step_px(obj)
            % generate a random step in the random walk process
            
            % d = obj.um2px(obj.step_size_space_um) * ((-1) ^ randi([0, 1]));
            d = obj.um2px(obj.step_size_space_um) * randi([-1, 1]);
            return
        end
        
        function generate_sampled_translations(obj)
            % genrate sampled-points
            
            obj.sampled_translations = zeros(obj.number_of_translations, 2);
            obj.sampled_translations(1, :) = [0, 0];
            current_point = [0, 0];
            
            cx = 1;
            if strcmp(obj.sampling_method, 'vertical')
               cx = 0; 
            end
            cy = 1;
            if strcmp(obj.sampling_method, 'horizental')
               cy = 0; 
            end
            for i = 2:obj.number_of_translations
                dx = cx * obj.generate_random_space_step_px();
                dy = cy * obj.generate_random_space_step_px();
                
                current_point = current_point + [dx, dy];
                
                obj.sampled_translations(i, :) = current_point;
            end
        end
        
        function get_intensity_values(obj)
            obj.intensity_values = zeros(obj.number_of_translations, 1);
            
            for i = 1:obj.number_of_translations
                obj.intensity_values(i) = obj.image(...
                            round(obj.sampled_translations(i, 1)),...
                            round(obj.sampled_translations(i, 2)));
            end
            
        end
        
        function get_x_values(obj)
            obj.x_values = obj.sampled_translations(:, 1);
        end
        
        function get_y_values(obj)
            obj.y_values = obj.sampled_translations(:, 2);
        end
        
        function run(obj)
           % run the simulation and show result
           obj.init();
           obj.generate_sampled_translations();
           % obj.get_intensity_values();
           obj.get_x_values();
           obj.get_y_values();
           obj.show_results(100);
        end
    end
    
end

