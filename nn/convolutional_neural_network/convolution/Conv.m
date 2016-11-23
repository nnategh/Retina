classdef Conv < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        in
        kernel
        out
    end
    
    methods
        function obj = Conv(in, kernel)
            obj.in = in;
            obj.kernel = kernel;
            
            obj.out = zeros(...
                size(in, 1) - 2 * floor(size(kernel, 1) / 2), ...
                size(in, 2) - 2 * floor(size(kernel, 2) / 2) ...
            );
        end
        
        function clear(obj)
            obj.in = zeros(size(obj.in));
            obj.kernel = zeros(size(obj.kernel));
            obj.out = zeros(size(obj.out));
        end
        
        function show(obj)
            figure('Name', 'In', 'NumberTitle', 'off');
            imshow(obj.in);
            title('In');
            
            figure('Name', 'Kernel', 'NumberTitle', 'off');
            imshow(obj.kernel);
            title('Kernel');
            
            figure('Name', 'Out', 'NumberTitle', 'off');
            imshow(obj.out);
            title('Out');
        end
        
        function [r, c] = get_center_of_kernel(obj)
            r = ceil(size(obj.kernel, 1) / 2);
            c = ceil(size(obj.kernel, 2) / 2);
        end
        
        function coords = in_to_out(obj, r, c)
            [dr, dc] = obj.get_center_of_kernel();
            tmp = [];
            for rr = 1:size(obj.kernel, 1)
                for cc = 1:size(obj.kernel, 2)
                    tmp(end + 1, :) = [r + (rr - dr) - dr + 1, c + (cc - dc) - dc + 1];
                end
            end
            
            min_r = 1;
            max_r = size(obj.out, 1);
            
            min_c = 1;
            max_c = size(obj.out, 2);
            
            coords = [];
            for i = 1:size(tmp, 1)
                if tmp(i, 1) >= min_r && tmp(i, 1) <= max_r && tmp(i, 2) >= min_c && tmp(i, 2) <= max_c
                    coords(end + 1, :) = tmp(i, :);
                end
            end
        end
        
        function show_coords_on_out(obj, r, c)
            % in
            obj.in(r, c) = 1;
            
            % out
            coords = obj.in_to_out(r, c);
            for i = 1:size(coords, 1)
                obj.out(coords(i, 1), coords(i, 2)) = 1;
            end
            
            % show
            obj.show();
        end
        
        function coords = out_to_in(obj, r, c)
            coords = [];
            for dr = 0:(size(obj.kernel, 1) - 1)
                for dc = 0:(size(obj.kernel, 2) - 1)
                    coords(end + 1, :) = [r + dr, c + dc];
                end
            end
        end
        
        function show_coords_on_in(obj, r, c)
            % out
            obj.out(r, c) = 1;
            
            % in
            coords = obj.out_to_in(r, c);
            for i = 1:size(coords, 1)
                obj.in(coords(i, 1), coords(i, 2)) = 1;
            end
            
            % show
            obj.show();
        end
    end
    
end

