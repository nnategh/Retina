function varargout = SamplingEyeGUI(varargin)
% SAMPLINGEYEGUI MATLAB code for SamplingEyeGUI.fig
%      SAMPLINGEYEGUI, by itself, creates a new SAMPLINGEYEGUI or raises the existing
%      singleton*.
%
%      H = SAMPLINGEYEGUI returns the handle to a new SAMPLINGEYEGUI or the handle to
%      the existing singleton*.
%
%      SAMPLINGEYEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLINGEYEGUI.M with the given input arguments.
%
%      SAMPLINGEYEGUI('Property','Value',...) creates a new SAMPLINGEYEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SamplingEyeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SamplingEyeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SamplingEyeGUI

% Last Modified by GUIDE v2.5 23-Aug-2016 12:50:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SamplingEyeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SamplingEyeGUI_OutputFcn, ...
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


% --- Executes just before SamplingEyeGUI is made visible.
function SamplingEyeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SamplingEyeGUI (see VARARGIN)

% Choose default command line output for SamplingEyeGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SamplingEyeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

filename = get(handles.filename, 'string');
image = imread(filename);
height = size(image, 1);
width = size(image, 2);
set(handles.start_point_x, 'string', num2str(width / 2));
set(handles.start_point_y, 'string', num2str(height / 2));


% --- Outputs from this function are returned to the command line.
function varargout = SamplingEyeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in sampling_method.
function sampling_method_Callback(hObject, eventdata, handles)
% hObject    handle to sampling_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sampling_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sampling_method


% --- Executes during object creation, after setting all properties.
function sampling_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampling_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_run.
function btn_run_Callback(hObject, eventdata, handles)
% hObject    handle to btn_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

se = SamplingEye();

se.filename =               get(handles.filename, 'string');
se.start_point =            [str2double(get(handles.start_point_y, 'string')), str2double(get(handles.start_point_x, 'string'))];
se.step_size_time_ms =      str2double(get(handles.step_size_time_ms, 'string'));
se.duration_ms =            str2double(get(handles.duration_ms, 'string'));
se.pixel_size_um =          str2double(get(handles.pixel_size_um, 'string'));
se.step_size_space_um =     str2double(get(handles.step_size_space_um, 'string'));          % 9.2 is very tiny!!!

sampling_method_index =     get(handles.sampling_method, 'value');
sampling_methods =          get(handles.sampling_method, 'string');
se.sampling_method =        lower(sampling_methods{sampling_method_index});                 % (both | horizental | vertical)

se.is_video_saved =         boolean(get(handles.is_video_saved, 'value'));
se.video_filename =         get(handles.video_filename, 'string');
se.video_frame_rate =       str2double(get(handles.video_frame_rate, 'string'));

se.run();


% --- Executes on button press in btn_browse.
function btn_browse_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },...
          'Select an image');
      
set(handles.filename, 'string', [pathname filename]);
image = imread([pathname filename]);
height = size(image, 1);
width = size(image, 2);
set(handles.start_point_x, 'string', num2str(width / 2));
set(handles.start_point_y, 'string', num2str(height / 2));


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



function start_point_x_Callback(hObject, eventdata, handles)
% hObject    handle to start_point_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_point_x as text
%        str2double(get(hObject,'String')) returns contents of start_point_x as a double


% --- Executes during object creation, after setting all properties.
function start_point_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_point_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_point_y_Callback(hObject, eventdata, handles)
% hObject    handle to start_point_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_point_y as text
%        str2double(get(hObject,'String')) returns contents of start_point_y as a double


% --- Executes during object creation, after setting all properties.
function start_point_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_point_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_set_start_point.
function btn_set_start_point_Callback(hObject, eventdata, handles)
% hObject    handle to btn_set_start_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = get(handles.filename, 'string');
image = imread(filename);
h = figure('Name', filename, 'NumberTitle', 'off');
imshow(image);
[x, y] = ginput(1);
x = int32(x);
y = int32(y);
set(handles.start_point_x, 'string', num2str(x));
set(handles.start_point_y, 'string', num2str(y));
close(h);
