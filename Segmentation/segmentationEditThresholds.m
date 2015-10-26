function varargout = segmentationEditThresholds(varargin)
    % SEGMENTATIONEDITTHRESHOLDS MATLAB code for segmentationEditThresholds.fig
    %      SEGMENTATIONEDITTHRESHOLDS, by itself, creates a new SEGMENTATIONEDITTHRESHOLDS or raises the existing
    %      singleton*.
    %
    %      H = SEGMENTATIONEDITTHRESHOLDS returns the handle to a new SEGMENTATIONEDITTHRESHOLDS or the handle to
    %      the existing singleton*.
    %
    %      SEGMENTATIONEDITTHRESHOLDS('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in SEGMENTATIONEDITTHRESHOLDS.M with the given input arguments.
    %
    %      SEGMENTATIONEDITTHRESHOLDS('Property','Value',...) creates a new SEGMENTATIONEDITTHRESHOLDS or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before segmentationEditThresholds_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to segmentationEditThresholds_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help segmentationEditThresholds
    
    % Last Modified by GUIDE v2.5 22-Jan-2013 10:00:21
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @segmentationEditThresholds_OpeningFcn, ...
        'gui_OutputFcn',  @segmentationEditThresholds_OutputFcn, ...
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
    
    
    % --- Executes just before segmentationEditThresholds is made visible.
function segmentationEditThresholds_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to segmentationEditThresholds (see VARARGIN)
    
    % Choose default command line output for segmentationEditThresholds
    handles.output = hObject;
    
    handles.handlesMainGui = varargin{2};
    handles.hObjectMainGui = varargin{1};
    
    handles.defaultRoiPath = handles.handlesMainGui.defaultRoiPath;
    
    % Update handles structure
    guidata(hObject, handles);
    
    %populate the list box
    initSegmentationEditList(hObject);
    
    % UIWAIT makes segmentationEditThresholds wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    
    % --- Outputs from this function are returned to the command line.
function varargout = segmentationEditThresholds_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    
    % --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
    % hObject    handle to figure1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on selection change in listboxThresholdValues.
function listboxThresholdValues_Callback(hObject, eventdata, handles)
    % hObject    handle to listboxThresholdValues (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listboxThresholdValues contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listboxThresholdValues
    
    
    % --- Executes during object creation, after setting all properties.
function listboxThresholdValues_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listboxThresholdValues (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    loadThreshold(hObject);
    
    % --- Executes on button press in pushbuttonSaveThreshold.
function pushbuttonSaveThreshold_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonSaveThreshold (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    saveThreshold(hObject);
    
    
    % --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
function edit1_Callback(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit1 as text
    %        str2double(get(hObject,'String')) returns contents of edit1 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on key press with focus on listboxThresholdValues and none of its controls.
function listboxThresholdValues_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listboxThresholdValues (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    switch eventdata.Key
        case 'delete'
            removeSelectedThreshold(hObject);
        case 'backspace'
            removeSelectedThreshold(hObject);
        otherwise
    end
    
