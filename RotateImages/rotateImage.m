function varargout = rotateImage(varargin)
% ROTATEIMAGE MATLAB code for rotateImage.fig
%      ROTATEIMAGE, by itself, creates a new ROTATEIMAGE or raises the existing
%      singleton*.
%
%      H = ROTATEIMAGE returns the handle to a new ROTATEIMAGE or the handle to
%      the existing singleton*.
%
%      ROTATEIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROTATEIMAGE.M with the given input arguments.
%
%      ROTATEIMAGE('Property','Value',...) creates a new ROTATEIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rotateImage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rotateImage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rotateImage

% Last Modified by GUIDE v2.5 26-Feb-2013 14:50:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rotateImage_OpeningFcn, ...
                   'gui_OutputFcn',  @rotateImage_OutputFcn, ...
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


% --- Executes just before rotateImage is made visible.
function rotateImage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rotateImage (see VARARGIN)

% Choose default command line output for rotateImage
handles.output = hObject;

data = varargin{1};
angle = varargin{2};
handles.mainhObject = varargin{3};
handles.rawdata = data;
guidata(hObject, handles);

manualRotateData(hObject, angle);

str = sprintf('%.2f', angle);
set(handles.editAngleToRotate,'string',str);

% axes(handles.axesRotateImage);
% imagesc(data{1});
%plotGrid(hObject);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rotateImage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rotateImage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonMinusLevel3.
function pushbuttonMinusLevel3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonMinusLevel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
autoRotateData(hObject, '-5');


% --- Executes on button press in pushbuttonMinusLevel2.
function pushbuttonMinusLevel2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonMinusLevel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
autoRotateData(hObject, '-1');


% --- Executes on button press in pushbuttonMinusLevel1.
function pushbuttonMinusLevel1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonMinusLevel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
autoRotateData(hObject, '-0.1');


function editAngleToRotate_Callback(hObject, eventdata, handles)
% hObject    handle to editAngleToRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAngleToRotate as text
%        str2double(get(hObject,'String')) returns contents of editAngleToRotate as a double
angle = str2num(get(hObject,'string'));
manualRotateData(hObject, angle);


% --- Executes during object creation, after setting all properties.
function editAngleToRotate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAngleToRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonPlusLevel3.
function pushbuttonPlusLevel3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlusLevel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
autoRotateData(hObject, '5');


% --- Executes on button press in pushbuttonPlusLevel2.
function pushbuttonPlusLevel2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlusLevel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
autoRotateData(hObject, '1');


% --- Executes on button press in pushbuttonPlusLevel1.
function pushbuttonPlusLevel1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlusLevel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
autoRotateData(hObject, '0.1');


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%save angle of rotation
saveRotationAngle(hObject);
delete(handles.figure1);


% --- Executes on button press in pushbuttonCancel.
function pushbuttonCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
