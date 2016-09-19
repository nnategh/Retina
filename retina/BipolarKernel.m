classdef BipolarKernel < handle
    %Bipolar Kernel
    
    properties
        step_size_time_s            % step size time (second)
        duration_s                  % duration of simulation (second)
        
        width
        height
        center_percent
        signal_center
        signal_surround
        kernel
    end
    
    methods
        function obj = BipolarKernel()
            obj.step_size_time_s = 0.015;
            obj.duration_s = 0.6;        
            
            obj.center_percent = 0.4;
            obj.signal_center = [(1:obj.height)',  -1 + 2 * rand(obj.height, 1)]; % random signal in [-1, 1]
            obj.signal_surround = [(1:obj.height)', -1 + 2 * rand(obj.height, 1)]; % random signal in [-1, 1]
            obj.kernel = [];
        end
        
        function init(obj)
            obj.width = obj.duration_s / obj.step_size_time_s;
        end
        
        function make_kernel(obj)
            t = 0:obj.step_size_time_s:obj.duration_s;
            
            surround_row = interp1(obj.signal_surround(:, 1), obj.signal_surround(:, 2), t);
            center_row = interp1(obj.signal_center(:, 1), obj.signal_center(:, 2), t);
            
            surround_diameter = floor(obj.height * (1 - obj.center_percent) / 2);
            center_diameter = obj.height - (2 * surround_diameter);
            
            surround = repmat(surround_row, surround_diameter, 1);
            center = repmat(center_row, center_diameter, 1);
            
            obj.kernel = [surround; center; surround];
        end
        
        function show_kernel(obj)
            figure('Name', 'Bipolar Kernel', 'NumberTitle', 'off', 'Units', 'normalize', 'OuterPosition', [0, 0, 1, 1]);
            rows = 1;
            cols = 6;              
            
            % center, surround signals
            subplot(rows, cols, 1);
            plot(obj.signal_center(:, 1), obj.signal_center(:, 2), 'Color', 'blue', 'LineWidth', 2);
            hold on;
            plot(obj.signal_surround(:, 1), obj.signal_surround(:, 2), 'Color', 'red', 'LineWidth', 2);
            hold off;
            
            grid on, grid minor;
            xlabel('Time (s)');
            ylim([-1, 1]);
            legend('Center', 'Surround');
            
            % total
            subplot(rows, cols, 2);
            plot(obj.signal_center(:, 1), obj.signal_center(:, 2) + obj.signal_surround(:, 2), 'Color', 'black', 'LineWidth', 2);
            
            grid on, grid minor;
            xlabel('Time (s)');
            ylim([-1, 1]);
            set(gca, 'YTick', []);
            legend('Total');
            
            % surface
            subplot(rows, cols, [3, 4]);
            x = linspace(0, obj.duration_s, size(obj.kernel, 2));
            y = linspace(1, size(obj.kernel, 1), size(obj.kernel, 1));
            [x, y] = meshgrid(x, y);
            
            surf(x, y, obj.kernel);
            xlabel('Time (s)', 'Interpreter', 'latex');
            ylabel('Space ($$px$$)', 'Interpreter', 'latex');
            zlim([-1, 1]);
            colormap gray;
            shading flat;
            hcb = colorbar;
            set(hcb, 'Ticks', (-1:0.5:1));
            
            % image
            subplot(rows, cols, [5, 6]);
            imshow(obj.kernel, [min(obj.kernel(:)), max(obj.kernel(:))]);
        end
        
        function save_kernel(obj)
            data = obj.kernel;
            save('bipolar_kernel.mat', 'data');
            clear data;
        end
        
        function run(obj, show)
            if nargin < 1
                show = True; 
            end
            
            obj.init();            
            obj.make_kernel();
            
            if show
                obj.show_kernel();
            end
            
            obj.save_kernel();
        end
    end
    
end

