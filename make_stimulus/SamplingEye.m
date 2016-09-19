classdef SamplingEye < handle
    %SamplingEye simulate random walk movement of an eye
    %   input: an image (grayscale); pixel size; movement step size in space and time.
    % 
    %   output 1 (numerical): an array containing pixel intensities in that image at the locations sampled by the eye. The sampling_method follows the statistics explained in the paper (or the paragraph) attached in my previous note:
    %   Random walk with horizontal and vertical motion occurring independently; 9.2 ?m every 15 ms (default setting). Some conversion between displacement unit in length and in number of pixels in the image should be implemented in the code.
    % 
    %   options: sampling_method (1) only along horizontal axis; (2) only vertical axis; (3) in two dimensions.
    % 
    %   output 2 (graphical): the same input image overlaid by traces of the eye as it moves around the image.
    
    properties
        filename                % path of input image (image could be any format and colorspace!)
        image                   % input grayscale image
        start_point             % starting point for random-walk
        
        step_size_time_ms       % step size time (mili second)
        duration_ms             % duration of simulation (mili second)
        number_of_points        % number of sampled points
        
        pixel_size_um           % size of a pixel (micro meter)
        step_size_space_um      % step size space (micro meters)
        
        sampling_method         % sampling_method method (both | horizental | vertical)
        
        sampled_points          % array of sample pointnts (nx2)
        intensity_values        % intensity values of sample points
        x_values                % relative x coordinates of sample points
        y_values                % relative y coordinates of sample points
        
        is_video_saved          % save the video of simulation
        video_filename          % name of video which must be saved
        video_frame_rate        % frame-reate of video which must be saved
    end
    
    methods
        function obj = SamplingEye()
            % is a constructor, and set the independant variables to thier
            % default values
            obj.filename = 'lena.jpg';
            obj.start_point = [];
            
            obj.step_size_time_ms = 15;
            obj.duration_ms = 5 * 1000;
            
            obj.pixel_size_um = 100;
            obj.step_size_space_um = 9.2;
            
            obj.sampling_method = 'both';
            
            obj.is_video_saved = false;
            obj.video_filename = 'result';
            obj.video_frame_rate = 15;
        end
        
        function init(obj)
            % initialize the dependant variables
            obj.image = imread(obj.filename);
            if size(obj.image, 3) == 3
                obj.image = rgb2gray(obj.image);
            end
            
            if isempty(obj.start_point)
                [height, width] = size(obj.image);
                obj.start_point = [height / 2, width / 2];
            end
            
            obj.number_of_points = round(obj.duration_ms / obj.step_size_time_ms);
        end
        
        function px = um2px(obj, um)
            % convert um(micro meter) to px(pixel)
            px = round(um / obj.pixel_size_um);
        end
        
        function box = get_box_of_target_area(obj)
            x_min = min(obj.x_values);
            x_max = max(obj.x_values);
            
            neg_y_values = -1 * obj.y_values;
            y_min = min(neg_y_values);
            y_max = max(neg_y_values);
            
            box.x1 = obj.start_point(2) + x_min;
            box.x2 = obj.start_point(2) + x_max;
            box.y1 = obj.start_point(1) + y_min;
            box.y2 = obj.start_point(1) + y_max;
            box.width = x_max - x_min + 1;
            box.height = y_max - y_min + 1;
        end
            
        % Show results
        
        function show_sampled_points_image(obj, n, box)
            % make sample points (balck-white image)
            [height, width] = size(obj.image);
            res = zeros(height, width, 'uint8');
            
            res = cat(3, res, res, res);
                     
            % white first n'th sample points
            for i = 2:(n - 1)
                res(...
                    round(obj.sampled_points(i, 1)),...
                    round(obj.sampled_points(i, 2)),...
                    :) = [255, 255, 255];
            end
            
            % first pixel has different color
            res(...
                    round(obj.sampled_points(1, 1)),...
                    round(obj.sampled_points(1, 2)),...
                    :) = [0, 255, 0];
            
            % last pixel has different color
            res(...
                    round(obj.sampled_points(n, 1)),...
                    round(obj.sampled_points(n, 2)),...
                    :) = [255, 0, 0];
        
            imshow(res(...
                box.y1 : box.y2, ...
                box.x1 : box.x2, ...
                :...
            ));
        end
        
        function show_overlaid_image(obj, n, box, is_zoomed)
            % make overlaid image with sampled points
            [height, width] = size(obj.image);
            tmp = 255 * ones(height, width);
            
            res = round((tmp + double(obj.image)) / 2);
            res = uint8(res);
            res = cat(3, res, res, res);
            
            for i = 2:(n - 1)
                res(...
                    round(obj.sampled_points(i, 1)),...
                    round(obj.sampled_points(i, 2)),...
                    :) = [0, 0, 255];
            end
            
            % first pixel has different color
            res(...
                    round(obj.sampled_points(1, 1)),...
                    round(obj.sampled_points(1, 2)),...
                    :) = [0, 255, 0];
            
            % last pixel has different color
            res(...
                    round(obj.sampled_points(n, 1)),...
                    round(obj.sampled_points(n, 2)),...
                    :) = [255, 0, 0];
            
            % draw rectangle
            if ~is_zoomed
                res = insertShape(res, 'rectangle', [box.x1, box.y1, box.width, box.height], 'LineWidth', 3, 'Color', [255, 0, 0]);
                imshow(res);
            else
                imshow(res(...
                    box.y1 : box.y2, ...
                    box.x1 : box.x2, ...
                    :...
                ));
            end
            
        end
        
        function plot_intensity_time_series(obj, n)
            % show time series of intensity values
            res = zeros(obj.number_of_points, 1, 'uint8');
            
            for i = 1:n
                res(i) = obj.image(...
                            round(obj.sampled_points(i, 1)),...
                            round(obj.sampled_points(i, 2)));
            end
            
            plot(res);
        end
        
        function plot_x_time_series(obj, n)
            % show time series of intensity values
            res = obj.start_point(2) * ones(obj.number_of_points, 1);
            
            for i = 1:n
                res(i) = round(obj.sampled_points(i, 2));
            end
            
            res = res - obj.start_point(2);
            
            plot(res);
        end
        
        function plot_y_time_series(obj, n)
            % show time series of intensity values
            res = obj.start_point(1) * ones(obj.number_of_points, 1);
            
            for i = 1:n
                res(i) = round(obj.sampled_points(i, 1));
            end
            
            res = res - obj.start_point(1);
            res = -1 * res;
                     
            plot(res);
        end
        
        function show_results(obj, framerate)
           % show original image + sampled points + overlaid image
           h = figure('Name','Random-Walk Motion of the Eye','NumberTitle','off', 'Units','normalized','OuterPosition',[0 0 1 1]);
           rows = 4;
           cols = 4;
           
           if obj.is_video_saved
               vw = VideoWriter(obj.video_filename, 'MPEG-4');
               vw.FrameRate = obj.video_frame_rate;
               open(vw);
           end
           
           delay = 1 / framerate;
           box = obj.get_box_of_target_area();
           x_min = min(obj.x_values);
           x_max = max(obj.x_values);
           y_min = min(obj.y_values);
           y_max = max(obj.y_values);
           intensity_min = min(obj.intensity_values);
           intensity_max = max(obj.intensity_values);
           
           % original image
           figure(h), subplot(rows, cols, 1);
           imshow(obj.image);
           title('Original Image');
            
           for i = 1:obj.number_of_points
               % sample points
               figure(h), subplot(rows, cols, 2);
               obj.show_sampled_points_image(i, box);
               title('Sampled Points');
               xlabel(sprintf('(x, y) = (%d, %d)', ...
                    obj.x_values(i), ...
                    obj.y_values(i)...
                ));
               
               % overlaid image (zoomed in)
               figure(h), subplot(rows, cols, 3);
               obj.show_overlaid_image(i, box, true);
               title('Overlaid Image (zoomed in)');
               xlabel(sprintf('intensity = %d', ...
                   obj.image(...
                    round(obj.sampled_points(i, 1)),...
                    round(obj.sampled_points(i, 2)))...
               ));
               
               % overlaid image
               figure(h), subplot(rows, cols, 4);
               obj.show_overlaid_image(i, box, false);
               title('Overlaid Image');
               xlabel(sprintf('sample: %d/%d', i, obj.number_of_points));

               % x
               figure(h), subplot(rows, cols, 5:8);
               obj.plot_x_time_series(i);
               title('Time Series');
               xlabel('');
               ylabel(sprintf('x_{px} = [%d, %d]', x_min, x_max));
               % ylabel('x_{px}');
               ylim([x_min, x_max]);
               set(gca, 'XTickLabel', []);

               % y
               figure(h), subplot(rows, cols, 9:12);
               obj.plot_y_time_series(i);
               xlabel('');
               ylabel(sprintf('y_{px} = [%d, %d]', y_min, y_max));
               % ylabel('y_{px}');
               set(gca, 'XTickLabel', []);
               ylim([y_min, y_max]);
               
               % intensity
               figure(h), subplot(rows, cols, 13:16);
               obj.plot_intensity_time_series(i);
               xlabel('sample');
               ylabel(sprintf('intensity = [%d, %d]', intensity_min, intensity_max));
               % ylabel('intensity');
               ylim([0, 255]);
               
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
        
        function generate_sampled_points(obj)
            % genrate sampled-points
            [height, width] = size(obj.image);
            min_x = 1;
            max_x = width;
            min_y = 1;
            max_y = height;
            
            obj.sampled_points = zeros(obj.number_of_points, 2);
            obj.sampled_points(1, :) = obj.start_point;
            current_point = obj.start_point;
            
            cx = 1;
            if strcmp(obj.sampling_method, 'vertical')
               cx = 0; 
            end
            cy = 1;
            if strcmp(obj.sampling_method, 'horizental')
               cy = 0; 
            end
            for i = 2:obj.number_of_points
                dx = cx * obj.generate_random_space_step_px();
                dy = cy * obj.generate_random_space_step_px();
                
                current_point = current_point + [dy, dx];
                
                % check current point is in valid range
                if current_point(1) < min_y
                    current_point(1) = min_y;
                end
                if current_point(1) > max_y
                    current_point(1) = max_y;
                end
                
                if current_point(2) < min_x
                    current_point(2) = min_x;
                end
                if current_point(2) > max_x
                    current_point(2) = max_x;
                end
                
                obj.sampled_points(i, :) = current_point;
            end
        end
        
        function get_intensity_values(obj)
            obj.intensity_values = zeros(obj.number_of_points, 1);
            
            for i = 1:obj.number_of_points
                obj.intensity_values(i) = obj.image(...
                            round(obj.sampled_points(i, 1)),...
                            round(obj.sampled_points(i, 2)));
            end
            
        end
        
        function get_x_values(obj)
            obj.x_values = zeros(obj.number_of_points, 1);
            
            for i = 1:obj.number_of_points
                obj.x_values(i) = round(obj.sampled_points(i, 2));
            end
            
            obj.x_values = obj.x_values - obj.start_point(2);
        end
        
        function get_y_values(obj)
            obj.y_values = zeros(obj.number_of_points, 1);
            
            for i = 1:obj.number_of_points
                obj.y_values(i) = round(obj.sampled_points(i, 1));
            end
            
            obj.y_values = -1 * (obj.y_values - obj.start_point(1));
        end
        
        function run(obj)
           % run the simulation and show result
           obj.init();
           obj.generate_sampled_points();
           obj.get_intensity_values();
           obj.get_x_values();
           obj.get_y_values();
           obj.show_results(100);
        end
    end
    
end

