classdef KernelDesigner < handle
    %Kernel Designer
    
    properties
        precision               % determines percision in the axes
        filler                  % handle of filler functions
        
        space_df                % space draw funciton
        time_df                 % time draw funciton
    end
    
    methods
        function obj = KernelDesigner()
            obj.precision = 2;
            obj.filler = @zeros;
            
            obj.time_df = [];
            obj.space_df = [];
        end
        
        function init(obj)
            % space
            obj.space_df = DrawFunction();
            obj.space_df.precision = obj.precision;
            obj.space_df.is_symmetry = true;
            obj.space_df.x_label = 'Space';
            obj.space_df.y_label = 'Sensitivity';
            obj.space_df.run();
            
            % time
            obj.time_df = DrawFunction();
            obj.time_df.precision = obj.precision;
            obj.time_df.is_symmetry = false;
            obj.time_df.x_label = 'Time';
            obj.time_df.y_label = 'Sensitivity';
            obj.time_df.run();
        end
        
        
        function kernel = get_kernel(obj, size_, space_value_limits, time_value_limits)
            M = size_(1);
            N = size_(2);
            P = size_(3);
            
            y = KernelDesigner.interp_value(obj.space_df.data, [1, M], space_value_limits); % data.space -> [(1:M), y]
            x = KernelDesigner.interp_value(obj.space_df.data, [1, N], space_value_limits); % data.space -> [(1:N), x]
            z = KernelDesigner.interp_value(obj.time_df.data, [1, P], time_value_limits); % data.time -> [(1:P), z]
        
            % kernel
            kernel = zeros(M, N, P);
            for i = 1:M
                for j = 1:N
                    for k = 1:P
                        kernel(i, j, k) = y(i) * x(j) * z(k);
                    end
                end
            end
        end
        
        function save(obj, filename)
            save(filename, 'obj');
        end
    end
    
    methods (Static)
        function array = linear_transform(array, new_limits)
            % [0, 1] -> new_limits
            % y = b + m * x
            A = [1, 0; 1, 1];
            B = new_limits';
            sol = A \ B;
            
            array = sol(1) + sol(2) * array;
        end
        
        function value = interp_value(time_value, new_time_limits, new_value_limits)
            % interpolation b after discretize a
            value = interp1(...
                KernelDesigner.linear_transform(time_value(:, 1), new_time_limits), ...
                KernelDesigner.linear_transform(time_value(:, 2), new_value_limits), ...
                new_time_limits(1):new_time_limits(2), ...
                'spline' ...
            );
        end
        
        function obj = load(filename)
            obj = load(filename);
            obj = obj.(char(fieldnames(obj)));
        end
    end
    
end
