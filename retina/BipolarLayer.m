classdef BipolarLayer < CellLayer
    %Bipolar Layer contains an array of bipolar cells
    
    properties (Constant)
        name = 'Bipolar Layer';
    end
    
    properties
        stimulus
        kernel
        
        nonlinear_transform_params
    end
    
    methods
        function obj = BipolarLayer(number_of_cells, stimulus, kernel, nonlinear_transform_params)
            % cells
            obj@CellLayer(number_of_cells, @Bipolar);
            
            % stimulus
            obj.stimulus = stimulus;
            
            % receptive field
            obj.make_receptive_field_of_cells();
            
            % kernel
            obj.kernel = kernel;
            if isempty(obj.kernel)
                obj.simulate_kernel();
            end
            
            % nonlinear transform parameters
            obj.nonlinear_transform_params = nonlinear_transform_params;
            if isempty(obj.nonlinear_transform_params)
                obj.nonlinear_transform_params.threshold = 0;
                obj.nonlinear_transform_params.slope = 1;
            end
        end
        
        function y = nonlinear_transform(obj, x)            
            threshold = obj.nonlinear_transform_params.threshold;
            slope = obj.nonlinear_transform_params.slope;
            
            y = zeros(size(x));
            i = x > threshold;
            y(i) = slope * x(i) - threshold;
        end
        
        function simulate_kernel(obj)
            % parameters
            signal_surround = load('surround.mat', 'data');
            signal_surround = signal_surround.data;
            signal_center = load('center.mat', 'data');
            signal_center = signal_center.data;

            % bipolar kernel
            bk = BipolarKernel();

            bk.signal_surround = signal_surround;
            bk.signal_center = signal_center;
            bk.height = floor(size(obj.stimulus, 1) / length(obj.cells));
            
            % run
            bk.run(false);
            obj.kernel = bk.kernel;
        end
        
        function make_receptive_field_of_cells(obj)
            width = size(obj.stimulus, 1) - 1;
            
            for i = 1:length(obj.cells)
                center = obj.cells{i}.center;
                radius = obj.cells{i}.radius;
                
                obj.cells{i}.rf = [...
                    center - radius, ...
                    center + radius
                ];
                
                obj.cells{i}.rf = floor(width * obj.cells{i}.rf) + 1;
            end
        end
        
        function run(obj)
            for i = 1:length(obj.cells)
                bipolar = obj.cells{i};
                
                % convolution
                part_of_stimulus = obj.stimulus(bipolar.rf(1):bipolar.rf(2), :);
                part_of_stimulus = part_of_stimulus(1: size(obj.kernel, 1), :);
                
                bipolar.output = Retina.temporal_conv2(part_of_stimulus, obj.kernel);
                
                % sum
                bipolar.output = sum(bipolar.output);
                
                % non-linear transform
                bipolar.output = obj.nonlinear_transform(bipolar.output);
            end
        end
        
    end
    
end

