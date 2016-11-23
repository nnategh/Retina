classdef DrawFunction < handle
    %Draw Function
    % Start (right click), Stop (left click)
    
    properties
        precision
        data
 
        h_figure
        h_axes
        
        is_symmetry
        x_label
        y_label
    end
    
    methods
        function obj = DrawFunction()
            obj.precision = 2;
            obj.data = [];
            
            obj.h_figure = [];
            obj.h_axes = [];
            
            obj.is_symmetry = false;
            obj.x_label = '';
            obj.y_label = '';
        end
        
        function init(obj)
            % data
            if isempty(obj.data)
                dt = 10 ^ -(obj.precision);
                time = (0:dt:1)';
                value = zeros(size(time));
                obj.data = [time, value];
            end
            
            % h_figure
            obj.h_figure = figure(...
                'Name', 'Draw Function', ...
                'NumberTitle', 'off', ...
                'Units', 'normalized', ...
                'OuterPosition', [0.25, 0.25, 0.5, 0.5], ...
                'WindowButtonMotionFcn', @obj.window_button_motion_callback ...
            );
            
            % h_axes
            obj.h_axes = axes(...
                'Parent', obj.h_figure, ...
                'XTick', [0, 0.5, 1], ...
                'YTick', [0, 0.5, 1], ...
                'XTickLabel', [], ...
                'YTickLabel', [], ...
                'XGrid', 'on', ...
                'XMinorGrid', 'on', ...
                'YGrid', 'on', ...
                'YMinorGrid', 'on', ...
                'DataAspectRatio', [1, 1, 1], ...
                'XLim', [0, 1], ...
                'YLim', [0, 1] ...
            );
            xlabel(obj.h_axes, obj.x_label);
            ylabel(obj.h_axes, obj.y_label);
        
            % line
            line(...
                'Parent', obj.h_axes, ...
                'XData', obj.data(:, 1), ...
                'YData', obj.data(:, 2), ...
                'LineWidth', 2, ...
                'Color', [0, 0, 1] ...
            );
        end
        
        function window_button_motion_callback (obj, ~, ~)
            st = get(obj.h_figure,'SelectionType');
            if ~strcmp(st, 'alt')
                return
            end
            
            cp = get(obj.h_axes, 'CurrentPoint');

            x = cp(1, 1);
            x = round(x, obj.precision);
            if x < 0 || x > 1
                return;
            end

            y = cp(1, 2);
            if y < 0 || y > 1
                return
            end
            
            obj.add_point([x, y]);
            obj.update_ydata();
        end
        
        function close_request_callback(obj, ~, ~)
            obj.save_data();
            
            pause();
                        
            delete(obj.h_figure);
        end
        
        function add_point(obj, p)
            x = int32(round(p(1), obj.precision) * (10 ^ obj.precision)) + 1;
            obj.data(x, 2) = p(2); % update
            
            % symmetry
            if obj.is_symmetry
                x = int32(round(1 - p(1), obj.precision) * (10 ^ obj.precision)) + 1;
                obj.data(x, 2) = p(2);
            end
        end
        
        function update_ydata(obj)
            obj.h_axes.Children(1).YData = obj.data(:, 2);
        
            drawnow();
        end
        
        function plot_smooth_data(obj)
            xq = 0: 10 ^ -(obj.precision + 1): 1;
            yq = interp1(obj.data(:, 1), obj.data(:, 2), xq, 'spline');
            
            figure(obj.h_figure);
            hold on;
            plot(xq, yq, 'Color', 'red', 'LineStyle', '--');
            hold off;
        end
        
        function run(obj)
            obj.init();
        end
    end
end

