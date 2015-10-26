function varargout = exportSegmentationHistogramFigure(varargin)
% EXPORTSEGMENTATIONHISTOGRAMFIGURE MATLAB code for exportSegmentationHistogramFigure.fig
%      EXPORTSEGMENTATIONHISTOGRAMFIGURE, by itself, creates a new EXPORTSEGMENTATIONHISTOGRAMFIGURE or raises the existing
%      singleton*.
%
%      H = EXPORTSEGMENTATIONHISTOGRAMFIGURE returns the handle to a new EXPORTSEGMENTATIONHISTOGRAMFIGURE or the handle to
%      the existing singleton*.
%
%      EXPORTSEGMENTATIONHISTOGRAMFIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPORTSEGMENTATIONHISTOGRAMFIGURE.M with the given input arguments.
%
%      EXPORTSEGMENTATIONHISTOGRAMFIGURE('Property','Value',...) creates a new EXPORTSEGMENTATIONHISTOGRAMFIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exportSegmentationHistogramFigure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exportSegmentationHistogramFigure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exportSegmentationHistogramFigure

% Last Modified by GUIDE v2.5 03-Dec-2013 11:20:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exportSegmentationHistogramFigure_OpeningFcn, ...
                   'gui_OutputFcn',  @exportSegmentationHistogramFigure_OutputFcn, ...
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


% --- Executes just before exportSegmentationHistogramFigure is made visible.
function exportSegmentationHistogramFigure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exportSegmentationHistogramFigure (see VARARGIN)

% Choose default command line output for exportSegmentationHistogramFigure
handles.output = hObject;

handles.handlesMainGui = varargin{2};
handles.hObjectMainGui = varargin{1};

handles.defaultPath = handles.handlesMainGui.defaultPath;

% Update handles structure
guidata(hObject, handles);

%populate listbox
initExportSegmentationHistogramListbox(hObject);

% UIWAIT makes exportSegmentationHistogramFigure wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exportSegmentationHistogramFigure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listboxExportSegmentationHistogram.
function listboxExportSegmentationHistogram_Callback(hObject, eventdata, handles)
% hObject    handle to listboxExportSegmentationHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxExportSegmentationHistogram contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxExportSegmentationHistogram


% --- Executes during object creation, after setting all properties.
function listboxExportSegmentationHistogram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxExportSegmentationHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exportSegmentationHistogramExportButton.
function exportSegmentationHistogramExportButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportSegmentationHistogramExportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exportSegmentationHistogramExportButton(hObject);
close force    


% --- Executes when user attempts to close figure1.
function  exportSegmentationHistogramFigure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
