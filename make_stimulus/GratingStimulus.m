classdef GratingStimulus < handle
    %SamplingEye simulate random walk movement of an eye
    %   input parameters: movement step size in space and time (default 9.2 ?m and 15 ms); spatial frequency of grating stimulus (default 184 ?m), diameter of the object region (default 800 ?m); size of the background region (default 5900 × 4400 ?m); thickness of the object annulus (default 92 ?m); condition ("global" or "differential").
    
    properties
        step_size_time_ms           % step size time (mili second)
        duration_ms                 % duration of simulation (mili second)
        number_of_runs              % number of runs
        
        pixel_size_um               % size of a pixel (micro meter)
        step_size_space_um          % step size space (micro meters)
        
        condition                   % ('global' or 'differential')
        jittered_method             % ('random' or 'no')
        
        spatial_frequency_um        % default 184 um
        annulus_diameter_um         % default 800 um
        background_region_size_um   % default 5900 × 4400 um
        annulus_thickness_um        % default 92 um
        
        is_transposed               % transpose the maked stimulus
        
        is_video_saved              % save the video of simulation
        video_filename              % name of video which must be saved
        video_frame_rate            % frame-reate of video which must be saved
        
    end
    
    methods
        function obj = GratingStimulus()
            % is a constructor, and set the independant variables to thier
            % default values
            
            obj.step_size_time_ms = 15;
            obj.duration_ms = 5 * 1000;
            
            obj.pixel_size_um = 100;
            obj.step_size_space_um = 9.2;
            
            obj.condition = 'differential';
            obj.jittered_method = 'random';
            obj.spatial_frequency_um = 184;
            obj.annulus_diameter_um = 800;
            obj.background_region_size_um = [5900, 4400];
            obj.annulus_thickness_um = 92;
            
            obj.is_transposed = false;
            
            obj.is_video_saved = false;
            obj.video_filename = 'result';
            obj.video_frame_rate = 15;
        end
        
        function init(obj)
            % initialize the dependant variables
            obj.number_of_runs = round(obj.duration_ms / obj.step_size_time_ms);
        end
        
        function px = um2px(obj, um)
            % convert um(micro meter) to px(pixel)
            px = round(um / obj.pixel_size_um);
        end
        
        function d = generate_random_space_step_px(obj)
            % generate a random step in the random walk process
            d = obj.um2px(obj.step_size_space_um) * randi([-1, 1]);
            return
        end
        
        function mat = jitter(obj, mat, K)
            K = K * obj.um2px(obj.step_size_space_um);
            switch obj.jittered_method
                case 'random'
                    % mat = GratingStimulus.random_circshift(mat, K);
                    mat = circshift(mat, K * randi([-1, 1]));
                otherwise
                    mat = circshift(mat, K);
            end
        end
        
        function make_grating_stimulus(obj)
            % properties
            frame_rate = 25;
            
            delay = 1 / frame_rate;
            

            background.strip.width = obj.um2px(obj.background_region_size_um(2));
            background.strip.height = ceil(obj.um2px(obj.spatial_frequency_um) / 2);
            background.number_of_strips = ceil(obj.um2px(obj.background_region_size_um(1)) / background.strip.height);
            % for perfect circular shift!
            if mod(background.number_of_strips, 2) == 1
                background.number_of_strips = background.number_of_strips + 1;
            end


            circle.radius = round(obj.um2px(obj.annulus_diameter_um) / 2);
            circle.thickness = obj.um2px(obj.annulus_thickness_um);
            circle.color = [128 128 128];


            % background.strip
            background.strip.black = zeros(background.strip.height, background.strip.width, 'uint8');
            background.strip.white = 255 - background.strip.black;

            % background
            background.shape = background.strip.white;
            for i = 2:background.number_of_strips
                if mod(i, 2) == 0
                    background.shape = vertcat(background.shape, background.strip.black);
                else
                    background.shape = vertcat(background.shape, background.strip.white);
                end
            end
            background.inv_shape = background.shape;

            % square
            [height, width] = size(background.shape);
            h_2 = height / 2;
            w_2 = width / 2;


            square.width = 2 * circle.radius;
            square.top_left = [h_2 w_2] - [circle.radius circle.radius];
            r1 = square.top_left(1);
            r2 = square.top_left(1) + square.width;
            c1 = square.top_left(2);
            c2 = square.top_left(2) + square.width;

            circle.points = [];
            for r = r1:r2
                for c = c1:c2
                    if (r - h_2) ^ 2 + (c - w_2) ^ 2 <= circle.radius ^ 2
                        circle.points(end + 1) = (c - 1) * height + r;
                    end
                end
            end
            
            if obj.is_video_saved
                % directory for save frames
                frames_dir = [obj.video_filename '_frames'];
                if exist(frames_dir, 'dir')
                    rmdir(frames_dir, 's');
                end
                mkdir(frames_dir);
                
                vw = VideoWriter(obj.video_filename, 'MPEG-4');
                vw.FrameRate = obj.video_frame_rate;
                open(vw);
            end
            
            % movie
%             h = figure('Name','Grating-Stimulus Simulation','NumberTitle','off', 'Units','normalized','OuterPosition',[0 0 1 1]);
            h = figure('Name','Grating-Stimulus Simulation','NumberTitle','off');
            
            blue_bar = 255 * ones(size(background.shape, 1), obj.number_of_runs, 'uint8');
            for i = 1:obj.number_of_runs
                background_shape_copy = background.shape;
                
                if strcmp(obj.condition, 'differential')
                    background_shape_copy(circle.points) = background.inv_shape(circle.points);
                    
                    % draw circle
                    background_shape_copy = insertShape(background_shape_copy, 'circle', [w_2 h_2 circle.radius], 'LineWidth', circle.thickness, 'Color', circle.color);
                end
                
                % copy of stimulus without blue bar
                stimulus = background_shape_copy;
                
                % draw line
                blue_bar(:, i) = background_shape_copy(:, w_2);                    
                background_shape_copy = insertShape(background_shape_copy, 'line', [w_2 0 w_2 height], 'LineWidth', 2, 'Color', [0, 0, 255]);

                figure(h);
                subplot(1, 2, 1);
                if obj.is_transposed
                    imshow(permute(background_shape_copy, [2, 1, 3]));
                else
                    imshow(background_shape_copy);
                end
                
                title(sprintf('(%d/%d)', i, obj.number_of_runs));

                subplot(1, 2, 2);
                if obj.is_transposed
                    imshow(permute(blue_bar, [2, 1, 3]));
                else
                    imshow(blue_bar);
                end
                
                title([upper(obj.condition(1)) obj.condition(2: end)]);

                if obj.is_video_saved
                    writeVideo(vw, getframe(h));                    
                    
%                     if obj.is_transposed
%                         stimulus = permute(stimulus, [2, 1, 3]);
%                     end
%                     
%                     writeVideo(vw, stimulus);                   
%                     imwrite(stimulus, fullfile(frames_dir, sprintf('frame_%06d.jpg', i)), 'jpg');            
                end
                
                pause(delay);
                
                background.shape = obj.jitter(background.shape, 1);
                background.inv_shape = obj.jitter(background.inv_shape, -1); 
            end
            
            if obj.is_video_saved
                blue_bar = blue_bar(1: obj.um2px(obj.background_region_size_um(1)), :);
                
                if obj.is_transposed
                    blue_bar = permute(blue_bar, [2, 1, 3]);
                end
                imwrite(blue_bar, [obj.video_filename '.png'], 'png');
                close(vw);
            end

        end
        
        function run(obj)
           % run the simulation and show result
           obj.init();
           obj.make_grating_stimulus();
        end
    end
    
    methods (Static)
        function mat = random_circshift(mat, K)
            n = size(mat, 2);
            for c = 1:n
                mat(:, c) = circshift(mat(:, c), K * randi([0, 1]));
            end
        end
    end
end