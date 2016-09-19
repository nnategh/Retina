function varargout = GratingStimulusGUI(varargin)
% GRATINGSTIMULUSGUI MATLAB code for GratingStimulusGUI.fig
%      GRATINGSTIMULUSGUI, by itself, creates a new GRATINGSTIMULUSGUI or raises the existing
%      singleton*.
%
%      H = GRATINGSTIMULUSGUI returns the handle to a new GRATINGSTIMULUSGUI or the handle to
%      the existing singleton*.
%
%      GRATINGSTIMULUSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRATINGSTIMULUSGUI.M with the given input arguments.
%
%      GRATINGSTIMULUSGUI('Property','Value',...) creates a new GRATINGSTIMULUSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GratingStimulusGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GratingStimulusGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GratingStimulusGUI

% Last Modified by GUIDE v2.5 23-Aug-2016 19:04:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GratingStimulusGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GratingStimulusGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GratingStimulusGUI is made visible.
function GratingStimulusGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GratingStimulusGUI (see VARARGIN)

% Choose default command line output for GratingStimulusGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GratingStimulusGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GratingStimulusGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function step_size_time_ms_Callback(hObject, eventdata, handles)
% hObject    handle to step_size_time_ms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_size_time_ms as text
%        str2double(get(hObject,'String')) returns contents of step_size_time_ms as a double


% --- Executes during object creation, after setting all properties.
function step_size_time_ms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_size_time_ms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration_ms_Callback(hObject, eventdata, handles)
% hObject    handle to duration_ms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration_ms as text
%        str2double(get(hObject,'String')) returns contents of duration_ms as a double


% --- Executes during object creation, after setting all properties.
function duration_ms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration_ms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixel_size_um_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_size_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_size_um as text
%        str2double(get(hObject,'String')) returns contents of pixel_size_um as a double


% --- Executes during object creation, after setting all properties.
function pixel_size_um_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_size_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function step_size_space_um_Callback(hObject, eventdata, handles)
% hObject    handle to step_size_space_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_size_space_um as text
%        str2double(get(hObject,'String')) returns contents of step_size_space_um as a double


% --- Executes during object creation, after setting all properties.
function step_size_space_um_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_size_space_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in condition.
function condition_Callback(hObject, eventdata, handles)
% hObject    handle to condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns condition contents as cell array
%        contents{get(hObject,'Value')} returns selected item from condition


% --- Executes during object creation, after setting all properties.
function condition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gs = GratingStimulus();

gs.step_size_time_ms =              str2double(get(handles.step_size_time_ms, 'string'));
gs.duration_ms =                    str2double(get(handles.duration_ms, 'string'));
gs.pixel_size_um =                  str2double(get(handles.pixel_size_um, 'string'));
gs.step_size_space_um =             str2double(get(handles.step_size_space_um, 'string'));

condition_index =                   get(handles.condition, 'value');
conditions =                        get(handles.condition, 'string');
gs.condition =                      lower(conditions{condition_index});

jittered_method_index =             get(handles.jittered_method, 'value');
jittered_methods =                  get(handles.jittered_method, 'string');
gs.jittered_method =                lower(jittered_methods{jittered_method_index});

direction_of_motion_index =         get(handles.direction_of_motion, 'value');
if direction_of_motion_index == 2
    gs.is_transposed = true;
end

gs.spatial_frequency_um =           str2double(get(handles.spatial_frequency_um, 'string'));
gs.annulus_diameter_um =            str2double(get(handles.annulus_diameter_um, 'string'));

background_region_size_um_height =  str2double(get(handles.background_region_size_um_height, 'string'));
background_region_size_um_width =   str2double(get(handles.background_region_size_um_width, 'string'));
gs.background_region_size_um =      [background_region_size_um_height, background_region_size_um_width];

gs.annulus_thickness_um =           str2double(get(handles.annulus_thickness_um, 'string'));

gs.is_video_saved =                 boolean(get(handles.is_video_saved, 'value'));
gs.video_filename =                 get(handles.video_filename, 'string');
gs.video_frame_rate =               str2double(get(handles.video_frame_rate, 'string'));

gs.run();

% --- Executes on selection change in jittered_method.
function jittered_method_Callback(hObject, eventdata, handles)
% hObject    handle to jittered_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns jittered_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from jittered_method


% --- Executes during object creation, after setting all properties.
function jittered_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jittered_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spatial_frequency_um_Callback(hObject, eventdata, handles)
% hObject    handle to spatial_frequency_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spatial_frequency_um as text
%        str2double(get(hObject,'String')) returns contents of spatial_frequency_um as a double


% --- Executes during object creation, after setting all properties.
function spatial_frequency_um_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spatial_frequency_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function annulus_diameter_um_Callback(hObject, eventdata, handles)
% hObject    handle to annulus_diameter_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of annulus_diameter_um as text
%        str2double(get(hObject,'String')) returns contents of annulus_diameter_um as a double


% --- Executes during object creation, after setting all properties.
function annulus_diameter_um_CreateFcn(hObject, eventdata, handles)
% hObject    handle to annulus_diameter_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function background_region_size_um_height_Callback(hObject, eventdata, handles)
% hObject    handle to background_region_size_um_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of background_region_size_um_height as text
%        str2double(get(hObject,'String')) returns contents of background_region_size_um_height as a double


% --- Executes during object creation, after setting all properties.
function background_region_size_um_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to background_region_size_um_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function annulus_thickness_um_Callback(hObject, eventdata, handles)
% hObject    handle to annulus_thickness_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of annulus_thickness_um as text
%        str2double(get(hObject,'String')) returns contents of annulus_thickness_um as a double


% --- Executes during object creation, after setting all properties.
function annulus_thickness_um_CreateFcn(hObject, eventdata, handles)
% hObject    handle to annulus_thickness_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function background_region_size_um_width_Callback(hObject, eventdata, handles)
% hObject    handle to background_region_size_um_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of background_region_size_um_width as text
%        str2double(get(hObject,'String')) returns contents of background_region_size_um_width as a double


% --- Executes during object creation, after setting all properties.
function background_region_size_um_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to background_region_size_um_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in is_video_saved.
function is_video_saved_Callback(hObject, eventdata, handles)
% hObject    handle to is_video_saved (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of is_video_saved

if get(hObject, 'Value')
    enable = 'on';
else
    enable = 'off';
end

set(handles.txt_video_filename, 'Enable', enable);
set(handles.video_filename, 'Enable', enable);
set(handles.txt_video_frame_rate, 'Enable', enable);
set(handles.video_frame_rate, 'Enable', enable);



function video_filename_Callback(hObject, eventdata, handles)
% hObject    handle to video_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of video_filename as text
%        str2double(get(hObject,'String')) returns contents of video_filename as a double


% --- Executes during object creation, after setting all properties.
function video_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to video_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function video_frame_rate_Callback(hObject, eventdata, handles)
% hObject    handle to video_frame_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of video_frame_rate as text
%        str2double(get(hObject,'String')) returns contents of video_frame_rate as a double


% --- Executes during object creation, after setting all properties.
function video_frame_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to video_frame_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in direction_of_motion.
function direction_of_motion_Callback(hObject, eventdata, handles)
% hObject    handle to direction_of_motion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns direction_of_motion contents as cell array
%        contents{get(hObject,'Value')} returns selected item from direction_of_motion


% --- Executes during object creation, after setting all properties.
function direction_of_motion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to direction_of_motion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
