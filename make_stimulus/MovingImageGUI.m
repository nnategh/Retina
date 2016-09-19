function varargout = MovingImageGUI(varargin)
% MOVINGIMAGEGUI MATLAB code for MovingImageGUI.fig
%      MOVINGIMAGEGUI, by itself, creates a new MOVINGIMAGEGUI or raises the existing
%      singleton*.
%
%      H = MOVINGIMAGEGUI returns the handle to a new MOVINGIMAGEGUI or the handle to
%      the existing singleton*.
%
%      MOVINGIMAGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVINGIMAGEGUI.M with the given input arguments.
%
%      MOVINGIMAGEGUI('Property','Value',...) creates a new MOVINGIMAGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MovingImageGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MovingImageGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MovingImageGUI

% Last Modified by GUIDE v2.5 24-Aug-2016 12:38:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MovingImageGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MovingImageGUI_OutputFcn, ...
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


% --- Executes just before MovingImageGUI is made visible.
function MovingImageGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MovingImageGUI (see VARARGIN)

% Choose default command line output for MovingImageGUI
handles.output = hObject;
handles.handles.mi = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MovingImageGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

filename = get(handles.filename, 'string');
image = imread(filename);
height = size(image, 1);
width = size(image, 2);

c = 0.2;
box.width = c * width;
box.height = c * height;
box.x = (width / 2) - (box.width / 2);
box.y = (height / 2) - (box.width / 2);

box.x = int32(box.x);
box.y = int32(box.y);
box.width = int32(box.width);
box.height = int32(box.height);

set(handles.box_x, 'string', num2str(box.x));
set(handles.box_y, 'string', num2str(box.y));
set(handles.box_width, 'string', num2str(box.width));
set(handles.box_height, 'string', num2str(box.height));


% --- Outputs from this function are returned to the command line.
function varargout = MovingImageGUI_OutputFcn(hObject, eventdata, handles) 
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

set(handles.btn_plot_intensity_time_series, 'enable', 'off');

handles.mi = MovingImage();

handles.mi.filename =               get(handles.filename, 'string');

handles.mi.box =                    [str2double(get(handles.box_x, 'string')), ...
                                     str2double(get(handles.box_y, 'string')), ...
                                     str2double(get(handles.box_width, 'string')), ...
                                     str2double(get(handles.box_height, 'string'))];

handles.mi.step_size_time_ms =      str2double(get(handles.step_size_time_ms, 'string'));
handles.mi.duration_ms =            str2double(get(handles.duration_ms, 'string'));
handles.mi.pixel_size_um =          str2double(get(handles.pixel_size_um, 'string'));
handles.mi.step_size_space_um =     str2double(get(handles.step_size_space_um, 'string'));          % 9.2 is very tiny!!!

sampling_method_index =             get(handles.sampling_method, 'value');
sampling_methods =                  get(handles.sampling_method, 'string');
handles.mi.sampling_method =        lower(sampling_methods{sampling_method_index});                 % (both | horizental | vertical)

handles.mi.is_video_saved =         boolean(get(handles.is_video_saved, 'value'));
handles.mi.video_filename =         get(handles.video_filename, 'string');
handles.mi.video_frame_rate =       str2double(get(handles.video_frame_rate, 'string'));

handles.mi.run();

set(handles.btn_plot_intensity_time_series, 'enable', 'on');

guidata(hObject, handles);


% --- Executes on button press in btn_browse.
function btn_browse_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },...
          'Select an image');
      
set(handles.filename, 'string', [pathname filename]);
image = imread([pathname filename]);
height = size(image, 1);
width = size(image, 2);

c = 0.2;
box.width = c * width;
box.height = c * height;
box.x = (width / 2) - (box.width / 2);
box.y = (height / 2) - (box.width / 2);

box.x = int32(box.x);
box.y = int32(box.y);
box.width = int32(box.width);
box.height = int32(box.height);

set(handles.box_x, 'string', num2str(box.x));
set(handles.box_y, 'string', num2str(box.y));
set(handles.box_width, 'string', num2str(box.width));
set(handles.box_height, 'string', num2str(box.height));

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



function box_x_Callback(hObject, eventdata, handles)
% hObject    handle to box_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_x as text
%        str2double(get(hObject,'String')) returns contents of box_x as a double


% --- Executes during object creation, after setting all properties.
function box_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_set_box.
function btn_set_box_Callback(hObject, eventdata, handles)
% hObject    handle to btn_set_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = get(handles.filename, 'string');
image = imread(filename);
h = figure('Name', filename, 'NumberTitle', 'off');
imshow(image);

box = getrect;
box = int32(box);

set(handles.box_x, 'string', num2str(box(1)));
set(handles.box_y, 'string', num2str(box(2)));
set(handles.box_width, 'string', num2str(box(3)));
set(handles.box_height, 'string', num2str(box(4)));

close(h);


function box_y_Callback(hObject, eventdata, handles)
% hObject    handle to box_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_y as text
%        str2double(get(hObject,'String')) returns contents of box_y as a double


% --- Executes during object creation, after setting all properties.
function box_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_width_Callback(hObject, eventdata, handles)
% hObject    handle to box_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_width as text
%        str2double(get(hObject,'String')) returns contents of box_width as a double


% --- Executes during object creation, after setting all properties.
function box_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_height_Callback(hObject, eventdata, handles)
% hObject    handle to box_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_height as text
%        str2double(get(hObject,'String')) returns contents of box_height as a double


% --- Executes during object creation, after setting all properties.
function box_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_plot_intensity_time_series.
function btn_plot_intensity_time_series_Callback(hObject, eventdata, handles)
% hObject    handle to btn_plot_intensity_time_series (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.mi.plot_intensity_time_series();
