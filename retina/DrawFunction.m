classdef DrawFunction < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        limits
        x_round_digits
        delay
        
        h_figure
        h_axes
        data

    end
    
    methods
        function obj = DrawFunction()
            obj.name = 'signal';
            obj.limits = [-1, 1, -1, 1];
            obj.x_round_digits = 1;
            obj.delay = 0.1;
        end
        
        function init(obj)
            obj.h_figure = figure('Name', 'Draw Function', 'NumberTitle', 'off');
            set(obj.h_figure, 'WindowButtonMotionFcn', @obj.window_button_motion_callback);
%             set(obj.h_figure, 'CloseRequestFcn', @obj.close_request_callback);
            
            obj.h_axes = axes();
            
            obj.data = [];
            
            obj.plot_data();
        end
        
        function window_button_motion_callback (obj, src, ~)
            st = get(obj.h_figure,'SelectionType');
            if ~strcmp(st, 'alt')
                return
            end
            
            cp = get(obj.h_axes, 'CurrentPoint');

            x = cp(1, 1);
            x = round(x, obj.x_round_digits);
            if x < obj.limits(1) || x > obj.limits(2)
                return;
            end

            y = cp(1, 2);
            if y < obj.limits(3) || y > obj.limits(4)
                return
            end

            % title(obj.h_axes, ['(X,Y) = (', num2str(x), ', ',num2str(y), ')']);
            
            obj.add_point([x, y]);
            obj.plot_data();
            pause(obj.delay);
        end
        
        function close_request_callback(obj, src, ~)                        
            obj.save_data();
            
            pause();
                        
            delete(obj.h_figure);
        end
        
        function add_point(obj, p)
            x = p(1);
            index = [];
            for i = 1:size(obj.data, 1)
                if obj.data(i, 1) >= x
                    index = i;
                    break;
                end
            end
            
            if isempty(index)
                obj.data = [obj.data; p];
                return;
            end
            
            if obj.data(index, 1) == x
                obj.data(i, 2) = p(2);
            else
                obj.data = [obj.data(1:index-1, :); p; obj.data(index:end, :)]; 
            end
        end
        
        function plot_data(obj)
            if ~isempty(obj.data)
                plot(obj.data(:, 1), obj.data(:, 2), 'LineWidth', 2);
            end
            axis(obj.h_axes, obj.limits);
            grid on; grid minor;
        end
        
        function plot_smooth_data(obj)            
            xq = obj.limits(1): 10 ^ -(2 * obj.x_round_digits): obj.limits(2);
            % xq = linspace(obj.limits(1), obj.limits(2), 10 * size(obj.data, 1));
            yq = interp1(obj.data(:, 1), obj.data(:, 2), xq, 'spline');
            
            figure(obj.h_figure);
            hold on;
            plot(xq, yq, 'Color', 'red', 'LineStyle', '--');
            hold off;
        end
        
        function save_data(obj)
            obj.plot_smooth_data();
            data = obj.data;
            save([obj.name '.mat'], 'data');
        end
        
        function run(obj)
            obj.init();
        end
    end
end

