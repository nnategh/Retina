%% (1) SamplingEye - GUI
close all;
clear;
clc;

SamplingEyeGUI

%% (1) SamplingEye - Code
close all;
clear;
clc;

se = SamplingEye();

se.filename =                   'lena.jpg';            
se.step_size_time_ms =          15;
se.duration_ms =                5000;
se.pixel_size_um =              100;
se.step_size_space_um =         100;                        % 9.2 is very tiny!!!
se.sampling_method =            'both';                     % (both | horizental | vertical)
se.is_video_saved =             false;
se.video_filename =            'result';
se.video_frame_rate =           15;

se.run();

%% (2) GratingStimulus - GUI
close all;
clear;
clc;

GratingStimulusGUI

%% (2) GratingStimulus - Code
close all;
clear;
clc;

gs = GratingStimulus();

gs.step_size_time_ms =          15;
gs.duration_ms =                5000;
gs.pixel_size_um =              100;
gs.step_size_space_um =         100;                        % 9.2 is very tiny!!!
gs.condition =                  'differential';             % ('global' or 'differential')
gs.jittered_method =            'random';                   % ('random' or 'no')
gs.spatial_frequency_um =       184 * 10;                   % 10 times more!!!
gs.annulus_diameter_um =        800 * 10 * 2;               % 10 times more!!!
gs.background_region_size_um =  [5900 * 10, 4400 * 10];     % 10 times more!!!
gs.annulus_thickness_um =       92 * 10;                    % 10 times more!!!
gs.is_transposed =              false;

gs.run();

%% (3) MovingImage - GUI
close all;
clear;
clc;

MovingImageGUI

%% (3) MovingImage - Code
close all;
clear;
clc;

mi = MovingImage();

mi.filename =                   'lena.jpg';            
mi.step_size_time_ms =          15;
mi.duration_ms =                5000;
mi.pixel_size_um =              100;
mi.step_size_space_um =         100;                        % 9.2 is very tiny!!!
mi.sampling_method =            'both';                     % (both | horizental | vertical)
mi.is_video_saved =             false;
mi.video_filename =             'result';
mi.video_frame_rate =           15;

mi.run();
