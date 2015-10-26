function varargout = iMars(varargin)
    % iMars MATLAB code for iMars.fig
    %      iMars, by itself, creates a new iMars or raises the existing
    %      singleton*.
    %
    %      H = iMars returns the handle to a new iMars or the handle to
    %      the existing singleton*.
    %
    %      iMars('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in iMars.M with the given input arguments.
    %
    %      iMars('Property','Value',...) creates a new iMars or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before iMars_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to iMars_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help iMars
    
    % Last Modified by GUIDE v2.5 30-Sep-2014 14:34:54
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @iMars_OpeningFcn, ...
        'gui_OutputFcn',  @iMars_OutputFcn, ...
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
    
    
    % --- Executes just before iMars is made visible.
function iMars_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to iMars (see VARARGIN)
    
    % Choose default command line output for vtkCreator
    handles.output = hObject;
    
    %add folders to path
    warning off;
    myStartup();
    
    %Initialize the handles
    %m_InitHandles(hObject);
    
    % retrieve input arguments (for debugging)
    default_path = '/Users/j35/SVN/NeutronImagingTools/data/raw/';
    default_roi_path = '/Users/j35/SVN/NeutronImagingTools/trunk/iMars/UnitTests/Data/';
    
    %about text file
    handles.aboutFileName = 'UtilityFiles/aboutFile.txt';
    
    %name of hidden session file
    
    if ispc
        handles.sessionFile = [getenv('USERPROFILE') '\.iMarsSession.cfg'];
    else
        handles.sessionFile = '~/.iMarsSession.cfg';
    end
    
    %loading image path
    handles.defaultPath = default_path;
    handles.defaultRoiPath = default_roi_path;
    handles.path = [];
    
    %default radio button of Image Domain
    handles.previousImageDomain = '';
    
    %colormap
    handles.colormap = 'Gray';
    
    %status bar timer
    handles.sbTimer = 0;
    %progress bar timer
    handles.progresstimer = 0;
    
    %preview
    handles.preview.imshow = 0;
    handles.preview.xlabel = 0;
    handles.preview.ylabel = 0;
    handles.preview.colorbar = 0;
    
    handles.files.ext = '';         %'fits' or 'tif'
    handles.files.class = '';%'uint8','double','uint16'
    
    % limit the number of data files loaded
    handles.files.maxFilesNbr = 300;
    
    % angle of rotation of images (degrees)
    handles.rotationAngle = 0;
    
    %data files infos
    handles.files.nbr = 0;
    handles.files.fileNames = {};
    handles.files.paths = {};
    handles.files.images = {};
    %calculated when retrieving data
    %255, 65535 or max(max(image))
    handles.files.globalMaxIntensity = 0;
    handles.inputPathnameOfBatchNormalization = '';
    
    %open beam
    handles.obfiles.nbr = 0;
    handles.obfiles.fileNames = {};
    handles.obfiles.paths = {};
    handles.obfiles.images = {};
    %calculated when retrieving data
    %255, 65535 or max(max(image))
    handles.obfiles.globalMaxIntensity = 0;
    
    %dark field
    handles.dffiles.nbr = 0;
    handles.dffiles.maxCounts = 920;
    handles.dffiles.fileNames = {};
    handles.dffiles.paths = {};
    handles.dffiles.images = {};
    %calculated when retrieving data
    %255, 65535 or max(max(image))
    handles.dffiles.globalMaxIntensity = 0;
    
    %make it tif use that DataType as well instead of class
    %FIXME
    handles.files.DataType = '';
    
    handles.files.maxIntensity = 0; %used to preview
    handles.files.minIntensity = 0; %used to preview
    
    handles.activeListbox = 'data'; %['data','openBeam','darkField']
    handles.currentImagePreviewed =  {}; %copy of the array of the image previewed
    
    %Used by the ROI figure
    %handles.roiCurrentSelection = [-1, -1, -1, -1];
    %handles.roiHaxes = 0;
    handles.roiRectangleSelection = {};
    handles.isRoiRectangleEllipse = {};
    handles.listboxNormalizationRoiString = {};
    handles.listboxNormalizationRoiRowSelection = [];
    handles.listboxBAprofileString = {};
    handles.listboxBAprofileSelection = [];
    handles.gammaFilteringFlag = 1;
    
    
    %Used by the BasicAnalysis Roi
    handles.baRoiRectangleSelection = {};
    handles.listboxBAroiString = {};
    handles.listboxBAroiSelection = {};
    
    %segmentation tab
    handles.histoThresholdValues = [];
    handles.histoThresholdTypes = {};  %'left','right'
    handles.liveThresholdValue = [];
    handles.liveThresholdType = 'left';
    handles.isExcludedLeftButtonSelected = 1;   %0 for false, 1 for true
    handles.maxValueOfHistogramPlot = -1;
    % handles.histo.live = {};  %the histogram currently plotted
    handles.histo.live = [];  %the histogram currently plotted
    handles.histo.maxCounts = -1;
    handles.histo.maxX = -1;
    handles.isMouseButtonDown = false;
    
    %ellipse selection
    handles.ellipsePreciseSelectionId = -1;
    
    % BA combine tab
    handles.baCombineSelection = {};
    handles.baCombineSignalSelection  = {};
    handles.baCombineBackgroundSelection = {};
    handles.inputPathnameOfBAcombine = '';
    handles.outputPathnameOfBAcombine = '';
    handles.listboxBAcombineString = {};
    handles.listboxBAcombineSelection = [];
    handles.isBAcombineAverageSelected = 0;
    handles.BAcombineBaseFileName = '';
    handles.BAcombineGroupNumber = '';
    
    % normalization batch mode
    handles.normalizationBatchListDataFiles = {};
    handles.normalizationBatchOutputFolder = '';
    handles.normalizationBatchBaseFileName = '';
    
    % cylindrical shape position
    handles.cylinderX1Y1X2Y2 = [];
    handles.secondCylinderX1Y1X2Y2 = [];
    handles.calculationRegion = [];
    
    % alignment tab - alignement parameters array
    handles.isNewAlignment = true;
    handles.alignmentMarkers = {};
    handles.alignmentMarkersTable = {};
    handles.blockAlignmentButton = false;
    
    handles.BAvoidsWorkingImages = [];
    
    % chips nMCP
    % [xoffset, yoffset]
    handles.chips.low_offset.chip1 = [0,0];
    handles.chips.low_offset.chip2 = [2,1];
    handles.chips.low_offset.chip3 = [0,3];
    handles.chips.low_offset.chip4 = [2,3];
    % [x,y]
    handles.chips.low_offset.deadPixels = {{[[194, 190];[200,195]]}};
    
    handles.chips.high_offset.chip1 = [0,0];
    handles.chips.high_offset.chip2 = [16,0];
    handles.chips.high_offset.chip3 = [0,16];
    handles.chips.high_offset.chip4 = [8,16];
    handles.chips.high_offset.deadPixels = {{[[1555,2535];[1598,2579]]}};
    
    % region to use to interpolate
    % {{[from_y,from_x],[to_y,to_x]},'interpolation direction'}
    
    handles.chips.low_offset.ip.region1 = {{[254,1];[262,256]},'y'};
    handles.chips.low_offset.ip.region2 = {{[255,258];[262,512]},'y'};
    handles.chips.low_offset.ip.region3 = {{[1,254];[257,261]},'x'};
    handles.chips.low_offset.ip.region4 = {{[260,254];[512,261]},'x'};
    
    guidata(hObject, handles);
    
    %Initialize the GUI
    [~,os] = system('hostname');
    os = strtrim(os);
    if strcmp(os,'ubuntu')
        opengl software
    end
    
    % disable the right widgets that are not supposed to be available yet
    m_toggleTabButtonHandles(handles, 1);
    % m_toggleTabButton(hObject, 1);
    %     m_activateRightGuiHandles(handles);
    % m_activateRightGui(hObject);
    
    %%bottom side of GUI
    m_activateLeftGuiHandles(handles);
    %m_activateLeftGui(hObject);
    
    %set up size and position of GUI
    screen_size = get(0, 'ScreenSize');
    old_units = get(handles.iMarsGUI, 'units');
    set(handles.iMarsGUI, 'units', 'pixels');
    set(handles.iMarsGUI, 'position', [screen_size(3)/2, ...
        0, ...          %screen_size(4)/2, ...
        1080, 840]);
    set(handles.iMarsGUI, 'units', old_units);
    
    % Update handles structure
    guidata(hObject, handles);
    
    %load previous session or not
    loadLastSession(hObject);
    checkNormalizationBatchGui(hObject);
    
    % will draw the Alignment widgets
    designAlignmentControls(hObject);
    
    % UIWAIT makes iMars wait for user response (see UIRESUME)
    uiwait(handles.iMarsGUI);
    
    % --- Outputs from this function are returned to the command line.
function varargout = iMars_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    % varargout{1} = handles.output;
    
    
    % --- Executes on selection change in listboxDataFile.
function listboxDataFile_Callback(hObject, eventdata, handles)
    % hObject    handle to listboxDataFile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listboxDataFile contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listboxDataFile
    set(gcf,'pointer','watch');
    m_displayImage(hObject,'data');
    checkNormalizationBatchGui(hObject)
    set(gcf,'pointer','arrow');
    
    % --- Executes during object creation, after setting all properties.
function listboxDataFile_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listboxDataFile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    % --- Executes on button press in toggleNormalization.
function toggleNormalization_Callback(hObject, eventdata, handles)
    % hObject    handle to toggleNormalization (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(gcf,'pointer','watch');
    m_toggleTabButton(hObject, 1);
    m_refreshPreviewRoi(hObject, true);
    set(gcf,'pointer','arrow');
    
    % --- Executes on button press in toggleBasicAnalysis.
function toggleBasicAnalysis_Callback(hObject, eventdata, handles)
    % hObject    handle to toggleBasicAnalysis (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % set(gcf,'pointer','watch');
    m_toggleTabButton(hObject, 2);
    m_refreshPreviewRoi(hObject, true);
    % set(gcf,'pointer','arrow');
    
    % --- Executes on button press in toggleSegmentation.
function toggleSegmentation_Callback(hObject, eventdata, handles)
    % hObject    handle to toggleSegmentation (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(gcf,'pointer','watch');
    m_toggleTabButton(hObject, 3);
    m_refreshPreviewRoi(hObject, true);
    set(gcf,'pointer','arrow');
    
    % --- Executes on button press in toggleAlignment.
function toggleAlignment_Callback(hObject, eventdata, handles)
    % hObject    handle to toggleAlignment (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(gcf,'pointer','watch');
    m_toggleTabButton(hObject, 4);
    m_refreshPreviewRoi(hObject, true);
    set(gcf,'pointer','arrow');
    
    % --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
    % hObject    handle to FileMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    %% load data file
    % --------------------------------------------------------------------
function MenuDataFile_Callback(hObject, eventdata, handles)
    % hObject    handle to MenuDataFile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    if (m_OpenFile(hObject, 'data'))
        m_updateGui(hObject);
        m_displayImage(hObject, 'data');
        checkNormalizationBatchGui(hObject);
    end
    
    % --------------------------------------------------------------------
function menuOpenBeam_Callback(hObject, eventdata, handles)
    % hObject    handle to menuOpenBeam (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if (m_OpenFile(hObject, 'openBeam'))
        m_updateGui(hObject);
        checkNormalizationBatchGui(hObject);
    end
    
    % --------------------------------------------------------------------
function menuDarkField_Callback(hObject, eventdata, handles)
    % hObject    handle to menudarkfield (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if (m_OpenFile(hObject, 'darkField'))
        m_updateGui(hObject);
        checkNormalizationBatchGui(hObject);
    end
    
    
    % --- Executes on mouse motion over figure - except title and menu.
function iMarsGUI_WindowButtonMotionFcn(hObject, eventdata, handles)
    % hObject    handle to iMarsGUI (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %
    % This function will be used mostly by the segmentation tab to
    % interact with the plot
    %     iMars_mouseAction(hObject,'mouseMove');
    
    
    % --- Executes on selection change in listboxOpenBeam.
function listboxOpenBeam_Callback(hObject, eventdata, handles)
    % hObject    handle to listboxOpenBeam (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listboxOpenBeam contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listboxOpenBeam
    m_displayImage(hObject, 'openBeam');
    
    
    % --- Executes on selection change in listboxDarkField.
function listboxDarkField_Callback(hObject, eventdata, handles)
    % hObject    handle to listboxDarkField (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listboxDarkField contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listboxDarkField
    m_displayImage(hObject, 'darkField');
    
    
    % --- Executes during object creation, after setting all properties.
function listboxOpenBeam_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listboxOpenBeam (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
    % --- Executes during object creation, after setting all properties.
function listboxDarkField_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listboxDarkField (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- If Enable == 'on', executes on mouse press in 5 pixel border.
    % --- Otherwise, executes on mouse press in 5 pixel border or over toggleNormalization.
function toggleNormalization_ButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to toggleNormalization (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %has to be there to make GUI happy when clicking within the edge of button
    
    
    % --- If Enable == 'on', executes on mouse press in 5 pixel border.
    % --- Otherwise, executes on mouse press in 5 pixel border or over toggleBasicAnalysis.
function toggleBasicAnalysis_ButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to toggleBasicAnalysis (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %has to be there to make GUI happy when clicking within the edge of button
    
    
    % --- If Enable == 'on', executes on mouse press in 5 pixel border.
    % --- Otherwise, executes on mouse press in 5 pixel border or over toggleSegmentation.
function toggleSegmentation_ButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to toggleSegmentation (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %has to be there to make GUI happy when clicking within the edge of button
    
    
    % --- If Enable == 'on', executes on mouse press in 5 pixel border.
    % --- Otherwise, executes on mouse press in 5 pixel border or over toggleAlignment.
function toggleAlignment_ButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to toggleAlignment (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %has to be there to make GUI happy when clicking within the edge of button
    
    
    % --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on selection change in listboxNormalizationRoi.
function listboxNormalizationRoi_Callback(hObject, eventdata, handles)
    % hObject    handle to listboxNormalizationRoi (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listboxNormalizationRoi contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listboxNormalizationRoi
    ctm = get(hObject,'UIContextMenu');
    m_updateManualRoiSelection(hObject);
    checkNormalizationBatchGui(hObject);
    
    % --- Executes during object creation, after setting all properties.
function listboxNormalizationRoi_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listboxNormalizationRoi (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbuttonLoadRoi.
function pushbuttonLoadRoi_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonLoadRoi (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_loadROI(hObject, handles);
    m_updateManualRoiSelection(hObject);
    checkNormalizationBatchGui(hObject);
    
    % --- Executes on button press in pushbuttonSaveRoi.
function pushbuttonSaveRoi_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonSaveRoi (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_saveRoi(hObject);
    
    
    % --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- If Enable == 'on', executes on mouse press in 5 pixel border.
    % --- Otherwise, executes on mouse press in 5 pixel border or over listboxDataFile.
function listboxDataFile_ButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to listboxDataFile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % has to be there to make GUI happy when user clicks disabled widget
    
    
    % --- Executes on selection change in listbox7.
function listbox7_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listbox7 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox7
    
    
    % --- Executes during object creation, after setting all properties.
function listbox7_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- If Enable == 'on', executes on mouse press in 5 pixel border.
    % --- Otherwise, executes on mouse press in 5 pixel border or over listboxNormalizationRoi.
function listboxNormalizationRoi_ButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to listboxNormalizationRoi (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbuttonNormalizationSelectRoi.
function pushbuttonNormalizationSelectRoi_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonNormalizationSelectRoi (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_selectROI(hObject)
    
    
    
function editRoiHeight_Callback(hObject, eventdata, handles)
    % hObject    handle to editRoiHeight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editRoiHeight as text
    %        str2double(get(hObject,'String')) returns contents of editRoiHeight as a double
    
    
    % --- Executes during object creation, after setting all properties.
function editRoiHeight_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editRoiHeight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function editRoiWidth_Callback(hObject, eventdata, handles)
    % hObject    handle to editRoiWidth (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editRoiWidth as text
    %        str2double(get(hObject,'String')) returns contents of editRoiWidth as a double
    
    
    % --- Executes during object creation, after setting all properties.
function editRoiWidth_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editRoiWidth (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function editRoiY0_Callback(hObject, eventdata, handles)
    % hObject    handle to editRoiY0 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editRoiY0 as text
    %        str2double(get(hObject,'String')) returns contents of editRoiY0 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function editRoiY0_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editRoiY0 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function editRoiX0_Callback(hObject, eventdata, handles)
    % hObject    handle to editRoiX0 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editRoiX0 as text
    %        str2double(get(hObject,'String')) returns contents of editRoiX0 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function editRoiX0_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editRoiX0 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in checkboxRoiEllipse.
function checkboxRoiEllipse_Callback(hObject, eventdata, handles)
    % hObject    handle to checkboxRoiEllipse (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(hObject,'value',1);
    set(handles.checkboxRoiRectangle,'value',0);
    
    
    % --- Executes on button press in checkboxRoiRectangle.
function checkboxRoiRectangle_Callback(hObject, eventdata, handles)
    % hObject    handle to checkboxRoiRectangle (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(hObject,'value',1);
    set(handles.checkboxRoiEllipse,'value',0);
    
    
    % --- Executes on key press with focus on listboxNormalizationRoi and none of its controls.
function listboxNormalizationRoi_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listboxNormalizationRoi (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    switch eventdata.Key
        case 'uparrow'
            m_updateManualRoiSelection(hObject);
        case 'downarrow'
            m_updateManualRoiSelection(hObject);
        case 'backspace'
            m_removeSelectedRoiSelection(hObject);
            m_updateManualRoiSelection(hObject);
            m_plotPreviewROIs(hObject, false);
        case 'delete'
            m_removeSelectedRoiSelection(hObject);
            m_updateManualRoiSelection(hObject);
            m_plotPreviewROIs(hObject, false);
        otherwise
    end
    checkNormalizationBatchGui(hObject);
    
    % --- Executes on button press in pushbuttonRoiReplace.
function pushbuttonRoiReplace_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonRoiReplace (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_addReplaceRoiFieldWithManualEntry(hObject, true)
    m_plotPreviewROIs(hObject, false);
    
    
    % --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_addReplaceRoiFieldWithManualEntry(hObject, false)
    m_plotPreviewROIs(hObject, false);
    checkNormalizationBatchGui(hObject)
    
    % --------------------------------------------------------------------
function DeleteROI_Callback(hObject, eventdata, handles)
    % hObject    handle to DeleteROI (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbuttonDataDelete.
function pushbuttonDataDelete_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonDataDelete (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_deleteSelectedFile(hObject,'data');
    %if no more data and BA tab activated, come back to first tab
    checkMainTabsStatus(hObject);
    checkNormalizationBatchGui(hObject);
    
    
    % --- Executes on key press with focus on listboxDataFile and none of its controls.
function listboxDataFile_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listboxDataFile (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    switch eventdata.Key
        case 'delete'
            m_deleteSelectedFile(hObject,'data');
        case 'backspace'
            m_deleteSelectedFile(hObject,'data');
        otherwise
    end
    %if no more data and BA tab activated, come back to first tab
    checkMainTabsStatus(hObject);
    checkNormalizationBatchGui(hObject);
    
    
    
    % --- Executes on button press in pushbuttonOBdelete.
function pushbuttonOBdelete_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonOBdelete (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_deleteSelectedFile(hObject,'openBeam');
    checkNormalizationBatchGui(hObject);
    
    % --- Executes on key press with focus on listboxOpenBeam and none of its controls.
function listboxOpenBeam_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listboxOpenBeam (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    switch eventdata.Key
        case 'delete'
            m_deleteSelectedFile(hObject,'openBeam');
        case 'backspace'
            m_deleteSelectedFile(hObject,'openBeam');
        otherwise
    end
    checkNormalizationBatchGui(hObject);
    
    
    % --- Executes on button press in pushbuttonDFdelete.
function pushbuttonDFdelete_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonDFdelete (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_deleteSelectedFile(hObject,'darkField');
    checkNormalizationBatchGui(hObject);
    
    
    % --- Executes on key press with focus on listboxDarkField and none of its controls.
function listboxDarkField_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listboxDarkField (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    switch eventdata.Key
        case 'delete'
            m_deleteSelectedFile(hObject,'darkField');
        case 'backspace'
            m_deleteSelectedFile(hObject,'darkField');
        otherwise
    end
    checkNormalizationBatchGui(hObject);
    
    
    % --- Executes on selection change in listbox8.
function listbox8_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listbox8 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox8
    
    
    % --- Executes during object creation, after setting all properties.
function listbox8_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton10 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton11 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on selection change in listbox9.
function listbox9_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listbox9 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox9
    
    
    % --- Executes during object creation, after setting all properties.
function listbox9_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton12 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton13 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    
function edit7_Callback(hObject, eventdata, handles)
    % hObject    handle to edit7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit7 as text
    %        str2double(get(hObject,'String')) returns contents of edit7 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit8_Callback(hObject, eventdata, handles)
    % hObject    handle to edit8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit8 as text
    %        str2double(get(hObject,'String')) returns contents of edit8 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit8 (see GCBO)
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
    
    
    
function edit10_Callback(hObject, eventdata, handles)
    % hObject    handle to edit10 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit10 as text
    %        str2double(get(hObject,'String')) returns contents of edit10 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit10 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of checkbox3
    
    
    % --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of checkbox4
    
    
    % --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton14 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function helpMenu_Callback(hObject, eventdata, handles)
    % hObject    handle to helpMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function aboutMenu_Callback(hObject, eventdata, handles)
    % hObject    handle to aboutMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_displayAboutMessage(hObject);
    
    
    % --- Executes on button press in pushbuttonNormalize.
function pushbuttonNormalize_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonNormalize (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_normalizeData(hObject);
    
    % --------------------------------------------------------------------
function menuOpenConfiguration_Callback(hObject, eventdata, handles)
    % hObject    handle to menuOpenConfiguration (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_loadConfiguration(hObject);
    checkNormalizationBatchGui(hObject);
    %     m_updateManualRoiSelection(hObject);
    
    % --------------------------------------------------------------------
function menuSaveConfiguration_Callback(hObject, eventdata, handles)
    % hObject    handle to menuSaveConfiguration (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_saveConfiguration(hObject);
    
    % --- If Enable == 'on', executes on mouse press in 5 pixel border.
    % --- Otherwise, executes on mouse press in 5 pixel border or over radiobuttonIntensityValue.
function radiobuttonIntensityValue_ButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to radiobuttonIntensityValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on mouse press over figure background, over a disabled or
    % --- inactive control, or over an axesSegmentationPreview background.
function iMarsGUI_WindowButtonUpFcn(hObject, eventdata, handles)
    % hObject    handle to iMarsGUI (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    iMars_mouseAction(hObject,'mouseUp');
    
    
    % --- Executes on key press with focus on iMarsGUI or any of its controls.
function iMarsGUI_WindowKeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to iMarsGUI (see GCBO)
    % eventdata  structure with the following fields (see FIGURE)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on key release with focus on iMarsGUI or any of its controls.
function iMarsGUI_WindowKeyReleaseFcn(hObject, eventdata, handles)
    % hObject    handle to iMarsGUI (see GCBO)
    % eventdata  structure with the following fields (see FIGURE)
    %	Key: name of the key that was released, in lower case
    %	Character: character interpretation of the key(s) that was released
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on scroll wheel click while the figure is in focus.
function iMarsGUI_WindowScrollWheelFcn(hObject, eventdata, handles)
    % hObject    handle to iMarsGUI (see GCBO)
    % eventdata  structure with the following fields (see FIGURE)
    %	VerticalScrollCount: signed integer indicating direction and number of clicks
    %	VerticalScrollAmount: number of lines scrolled for each click
    % handles    structure with handles and user data (see GUIDATA)
    
    %% iMars closing
    % --- Executes when user attempts to close iMarsGUI.
function iMarsGUI_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to iMarsGUI (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    %close all figures
    closeAllFigure(handles)
    
    closingSessionMessage(hObject);
    delete(hObject);
    
    
    % --- Executes during object deletion, before destroying properties.
function iMarsGUI_DeleteFcn(hObject, eventdata, handles)
    % hObject    handle to iMarsGUI (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %     saveSession(hObject);
    
    if isfield(handles, 'sbTimer') && isobject(handles.sbTimer)
        stop(handles.sbTimer);
        delete(handles.sbTimer);
    end
    
    if isfield(handles, 'progressTimer') && isobject(handles.progressTimer)
        stop(handles.progressTimer);
        delete(handles.progressTimer);
    end
    
    
    % --- Executes on button press in togglebuttonBAProfile.
function togglebuttonBAProfile_Callback(hObject, eventdata, handles)
    % hObject    handle to togglebuttonBAProfile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %     set(handles.togglebuttonBAProfile,'value',1);
    %     set(handles.togglebuttonBARoi,'value',0);
    m_toggleBATabButton(hObject, 1);
    m_refreshPreviewRoi(hObject, true);
    
    
    % --- Executes on button press in togglebuttonBARoi.
function togglebuttonBARoi_Callback(hObject, eventdata, handles)
    % hObject    handle to togglebuttonBARoi (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %     set(handles.togglebuttonBAProfile,'value',0);
    %     set(handles.togglebuttonBARoi,'value',1);
    m_toggleBATabButton(hObject, 2);
    m_refreshPreviewRoi(hObject, true);
    
    
    % --- Executes on button press in pushbuttonBASelectProfile.
function pushbuttonBASelectProfile_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBASelectProfile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    profileSelection(hObject);
    
    
    % --- Executes on selection change in listboxBAprofile.
function listboxBAprofile_Callback(hObject, eventdata, handles)
    % hObject    handle to listboxBAprofile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listboxBAprofile contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listboxBAprofile
    updateBAprofile2d(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function listboxBAprofile_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listboxBAprofile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbuttonBAexportProfile.
function pushbuttonBAexportProfile_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAexportProfile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    exportBAprofile(hObject);
    
    
    % --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton25 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on key press with focus on listboxBAprofile and none of its controls.
function listboxBAprofile_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listboxBAprofile (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    switch eventdata.Key
        case 'delete'
            removeCurrentSelectedProfile(hObject);
            updateBAprofileGUI(hObject)
            updateBAprofile2d(hObject);
            m_refreshPreviewRoi(hObject,true);
            
        case 'backspace'
            removeCurrentSelectedProfile(hObject);
            updateBAprofileGUI(hObject)
            updateBAprofile2d(hObject);
            m_refreshPreviewRoi(hObject,true);
            
        otherwise
    end
    
    
    % --- Executes on button press in radiobuttonBAprofileXaxis.
function radiobuttonBAprofileXaxis_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBAprofileXaxis (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of radiobuttonBAprofileXaxis
    set(handles.radiobuttonBAprofileYaxis,'value',0);
    updateBAprofile2d(hObject);
    
    
    % --- Executes on button press in radiobuttonBAprofileYaxis.
function radiobuttonBAprofileYaxis_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBAprofileYaxis (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of radiobuttonBAprofileYaxis
    set(handles.radiobuttonBAprofileXaxis,'value',0);
    updateBAprofile2d(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function radiobuttonIntensityValue_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to radiobuttonIntensityValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    
    % --- Executes on key press with focus on radiobuttonIntensityValue and none of its controls.
function radiobuttonIntensityValue_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to radiobuttonIntensityValue (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes when selected object is changed in uipanelImageDomain.
function uipanelImageDomain_SelectionChangeFcn(hObject, eventdata, handles)
    % hObject    handle to the selected object in uipanelImageDomain
    % eventdata  structure with the following fields (see UIBUTTONGROUP)
    %	EventName: string 'SelectionChanged' (read only)
    %	OldValue: handle of the previously selected object or empty if none was selected
    %	NewValue: handle of the currently selected object
    % handles    structure with handles and user data (see GUIDATA)
    m_displayImage(hObject, 'data');
    
    
    % --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton26 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_selectROI(hObject, true);
    
    
    
    % --- Executes on selection change in listboxBAroi.
function listboxBAroi_Callback(hObject, eventdata, handles)
    % hObject    handle to listboxBAroi (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listboxBAroi contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listboxBAroi
    %     updateBAroi2D(hObject);
    m_refreshPreviewRoi(hObject, true);
    
    
    
    % --- Executes during object creation, after setting all properties.
function listboxBAroi_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listboxBAroi (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton27 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton28 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    
function edit12_Callback(hObject, eventdata, handles)
    % hObject    handle to edit12 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit12 as text
    %        str2double(get(hObject,'String')) returns contents of edit12 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit12 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit13_Callback(hObject, eventdata, handles)
    % hObject    handle to edit13 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit13 as text
    %        str2double(get(hObject,'String')) returns contents of edit13 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit13 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit14_Callback(hObject, eventdata, handles)
    % hObject    handle to edit14 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit14 as text
    %        str2double(get(hObject,'String')) returns contents of edit14 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit14 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit15_Callback(hObject, eventdata, handles)
    % hObject    handle to edit15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit15 as text
    %        str2double(get(hObject,'String')) returns contents of edit15 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of checkbox5
    
    
    % --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of checkbox6
    
    
    % --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton29 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton30 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in radiobuttonBARoiBevington.
function radiobuttonBARoiBevington_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBARoiBevington (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of radiobuttonBARoiBevington
    
    
    % --- Executes on button press in radiobuttonBARoi3xSTD.
function radiobuttonBARoi3xSTD_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBARoi3xSTD (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of radiobuttonBARoi3xSTD
    
    
    % --- Executes on button press in radiobuttonBARoi2xSTD.
function radiobuttonBARoi2xSTD_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBARoi2xSTD (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of radiobuttonBARoi2xSTD
    
    
    % --- Executes on button press in radiobuttonBARoiSTD.
function radiobuttonBARoiSTD_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBARoiSTD (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of radiobuttonBARoiSTD
    
    
    
function editBAprofileManualX1input_Callback(hObject, eventdata, handles)
    % hObject    handle to editBAprofileManualX1input (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editBAprofileManualX1input as text
    %        str2double(get(hObject,'String')) returns contents of editBAprofileManualX1input as a double
    
    
    % --- Executes during object creation, after setting all properties.
function editBAprofileManualX1input_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editBAprofileManualX1input (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function editBAprofileManualY1input_Callback(hObject, eventdata, handles)
    % hObject    handle to editBAprofileManualY1input (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editBAprofileManualY1input as text
    %        str2double(get(hObject,'String')) returns contents of editBAprofileManualY1input as a double
    
    
    % --- Executes during object creation, after setting all properties.
function editBAprofileManualY1input_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editBAprofileManualY1input (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function editBAprofileManualX2orWidthInput_Callback(hObject, eventdata, handles)
    % hObject    handle to editBAprofileManualX2orWidthInput (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editBAprofileManualX2orWidthInput as text
    %        str2double(get(hObject,'String')) returns contents of editBAprofileManualX2orWidthInput as a double
    
    
    % --- Executes during object creation, after setting all properties.
function editBAprofileManualX2orWidthInput_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editBAprofileManualX2orWidthInput (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function editBAprofileManualY2orHeightInput_Callback(hObject, eventdata, handles)
    % hObject    handle to editBAprofileManualY2orHeightInput (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editBAprofileManualY2orHeightInput as text
    %        str2double(get(hObject,'String')) returns contents of editBAprofileManualY2orHeightInput as a double
    
    
    % --- Executes during object creation, after setting all properties.
function editBAprofileManualY2orHeightInput_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editBAprofileManualY2orHeightInput (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit20_Callback(hObject, eventdata, handles)
    % hObject    handle to edit20 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit20 as text
    %        str2double(get(hObject,'String')) returns contents of edit20 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit20 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit21_Callback(hObject, eventdata, handles)
    % hObject    handle to edit21 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit21 as text
    %        str2double(get(hObject,'String')) returns contents of edit21 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit21 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbuttonBAprofileManualAdd.
function pushbuttonBAprofileManualAdd_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAprofileManualAdd (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(gcf,'pointer','watch');
    addOrReplaceBAprofileInputEntry(hObject, 'add');
    set(gcf,'pointer','arrow');
    
    
    % --- Executes on button press in pushbuttonBAprofileManualReplace.
function pushbuttonBAprofileManualReplace_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAprofileManualReplace (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(gcf,'pointer','watch');
    addOrReplaceBAprofileInputEntry(hObject, 'false');
    set(gcf,'pointer','arrow');
    
function edit26_Callback(hObject, eventdata, handles)
    % hObject    handle to edit26 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit26 as text
    %        str2double(get(hObject,'String')) returns contents of edit26 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit26 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit27_Callback(hObject, eventdata, handles)
    % hObject    handle to edit27 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit27 as text
    %        str2double(get(hObject,'String')) returns contents of edit27 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit27 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit28_Callback(hObject, eventdata, handles)
    % hObject    handle to edit28 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit28 as text
    %        str2double(get(hObject,'String')) returns contents of edit28 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit28 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit29_Callback(hObject, eventdata, handles)
    % hObject    handle to edit29 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of edit29 as text
    %        str2double(get(hObject,'String')) returns contents of edit29 as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit29 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton35 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton36 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    
function baRoiInputLeft_Callback(hObject, eventdata, handles)
    % hObject    handle to baRoiInputLeft (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of baRoiInputLeft as text
    %        str2double(get(hObject,'String')) returns contents of baRoiInputLeft as a double
    
    
    % --- Executes during object creation, after setting all properties.
function baRoiInputLeft_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to baRoiInputLeft (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function baRoiInputTop_Callback(hObject, eventdata, handles)
    % hObject    handle to baRoiInputTop (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of baRoiInputTop as text
    %        str2double(get(hObject,'String')) returns contents of baRoiInputTop as a double
    
    
    % --- Executes during object creation, after setting all properties.
function baRoiInputTop_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to baRoiInputTop (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function baRoiInputWidth_Callback(hObject, eventdata, handles)
    % hObject    handle to baRoiInputWidth (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of baRoiInputWidth as text
    %        str2double(get(hObject,'String')) returns contents of baRoiInputWidth as a double
    
    
    % --- Executes during object creation, after setting all properties.
function baRoiInputWidth_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to baRoiInputWidth (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function baRoiInputHeight_Callback(hObject, eventdata, handles)
    % hObject    handle to baRoiInputHeight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of baRoiInputHeight as text
    %        str2double(get(hObject,'String')) returns contents of baRoiInputHeight as a double
    
    
    % --- Executes during object creation, after setting all properties.
function baRoiInputHeight_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to baRoiInputHeight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbuttonBAroiInputReplace.
function pushbuttonBAroiInputReplace_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAroiInputReplace (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    addOrReplaceBAroiInputEntry(hObject, 'replace');
    
    
    % --- Executes on button press in pushbuttonBAroiInputAdd.
function pushbuttonBAroiInputAdd_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAroiInputAdd (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    addOrReplaceBAroiInputEntry(hObject, 'add');
    
    
    % --- Executes on button press in pushbuttonBAroiLoad.
function pushbuttonBAroiLoad_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAroiLoad (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    loadBAroi(hObject);
    
    
    
    % --- Executes on button press in pushbuttonBAroiSave.
function pushbuttonBAroiSave_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAroiSave (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_saveBAroi(hObject);
    
    
    % --- Executes when selected object is changed in uipanelBAroiPlotType.
function uipanelBAroiPlotType_SelectionChangeFcn(hObject, eventdata, handles)
    % hObject    handle to the selected object in uipanelBAroiPlotType
    % eventdata  structure with the following fields (see UIBUTTONGROUP)
    %	EventName: string 'SelectionChanged' (read only)
    %	OldValue: handle of the previously selected object or empty if none was selected
    %	NewValue: handle of the currently selected object
    % handles    structure with handles and user data (see GUIDATA)
    m_refreshPreviewRoi(hObject, true);
    
    
    % --- Executes on key press with focus on listboxBAroi and none of its controls.
function listboxBAroi_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listboxBAroi (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    switch eventdata.Key
        case 'delete'
            removeCurrentSelectedBAroi(hObject);
            m_refreshPreviewRoi(hObject, true);
        case 'backspace'
            removeCurrentSelectedBAroi(hObject);
            m_refreshPreviewRoi(hObject, true);
        otherwise
    end
    
    
    % --- Executes on key press with focus on toggleNormalization and none of its controls.
function toggleNormalization_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to toggleNormalization (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in togglebuttonSegmentationExcludeLeft.
function togglebuttonSegmentationExcludeLeft_Callback(hObject, eventdata, handles)
    % hObject    handle to togglebuttonSegmentationExcludeLeft (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hint: get(hObject,'Value') returns toggle state of togglebuttonSegmentationExcludeLeft
    enableSegmentationExcludeButton(hObject, 'left');
    
    
    % --- Executes on button press in togglebuttonSegmentationExcludeRight.
function togglebuttonSegmentationExcludeRight_Callback(hObject, eventdata, handles)
    % hObject    handle to togglebuttonSegmentationExcludeRight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hint: get(hObject,'Value') returns toggle state of togglebuttonSegmentationExcludeRight
    enableSegmentationExcludeButton(hObject, 'right');
    
    
    % --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton40 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton41 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton42 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbuttonBAroiExport.
function pushbuttonBAroiExport_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAroiExport (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    exportBAroi(hObject);
    
    % --- Executes on button press in pushbuttonSegmentationEditThreshold.
function pushbuttonSegmentationEditThreshold_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonSegmentationEditThreshold (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    launchSegmentationEditThreshold(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function uipanelSegmentation_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to uipanelSegmentation (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    
    % --- Executes during object creation, after setting all properties.
function uipanelImageDomain_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to uipanelImageDomain (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    
    % --- Executes on key press with focus on radiobuttonBAroiAllrois and none of its controls.
function radiobuttonBAroiAllrois_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBAroiAllrois (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on mouse press over figure background, over a disabled or
    % --- inactive control, or over an axes background.
function iMarsGUI_WindowButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to iMarsGUI (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    iMars_mouseAction(hObject,'mouseDown');
    
    
    % --- Executes on button press in pushbuttonAddLiveThreshold.
function pushbuttonAddLiveThreshold_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAddLiveThreshold (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(gcf,'pointer','watch');
    set(handles.pushbuttonSegmentationRun,'enable','on');
    refreshSegmentation(hObject, true);
    handles = addLiveSegmentationThreshold(handles, false);
    guidata(hObject, handles);
    set(handles.pushbuttonAddLiveThreshold,'enable','off');
    set(handles.pushbuttonCancelLiveThreshold,'enable','off');
    set(gcf,'pointer','arrow');
    
    
    % --- Executes on button press in pushbuttonCancelLiveThreshold.
function pushbuttonCancelLiveThreshold_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonCancelLiveThreshold (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(gcf,'pointer','watch');
    set(handles.pushbuttonSegmentationRun,'enable','on');
    cancelLiveSegmentationThreshold(hObject);
    set(handles.pushbuttonAddLiveThreshold,'enable','off');
    set(handles.pushbuttonCancelLiveThreshold,'enable','off');
    set(gcf,'pointer','arrow');
    
    
    % --- Executes during object creation, after setting all properties.
function axesSegmentationHistogram_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to axesSegmentationHistogram (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    
    % --- Executes on button press in pushbuttonSegmentationExportHistogram.
function pushbuttonSegmentationExportHistogram_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonSegmentationExportHistogram (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    launchExportSegmentationHistogram(hObject);
    
    
function editSegmentationMinValue_Callback(hObject, eventdata, handles)
    % hObject    handle to editSegmentationMinValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editSegmentationMinValue as text
    %        str2double(get(hObject,'String')) returns contents of editSegmentationMinValue as a double
    set(gcf,'pointer','watch');
    m_refreshPreviewRoi(hObject, false)
    set(gcf,'pointer','arrow');
    
    
    % --- Executes during object creation, after setting all properties.
function editSegmentationMinValue_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editSegmentationMinValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
function editSegmentationMaxValue_Callback(hObject, eventdata, handles)
    % hObject    handle to editSegmentationMaxValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editSegmentationMaxValue as text
    %        str2double(get(hObject,'String')) returns contents of editSegmentationMaxValue as a double
    set(gcf,'pointer','watch');
    m_refreshPreviewRoi(hObject, false)
    set(gcf,'pointer','arrow');
    
    
    % --- Executes during object creation, after setting all properties.
function editSegmentationMaxValue_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editSegmentationMaxValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --------------------------------------------------------------------
function colormapMenu_Callback(hObject, eventdata, handles)
    % hObject    handle to colormapMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % --------------------------------------------------------------------
function menuJet_Callback(hObject, eventdata, handles)
    % hObject    handle to menuJet (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    % --------------------------------------------------------------------
function menuHsv_Callback(hObject, eventdata, handles)
    % hObject    handle to menuHsv (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    % --------------------------------------------------------------------
function menuHot_Callback(hObject, eventdata, handles)
    % hObject    handle to menuHot (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuCool_Callback(hObject, eventdata, handles)
    % hObject    handle to menuCool (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuSpring_Callback(hObject, eventdata, handles)
    % hObject    handle to menuSpring (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuSummer_Callback(hObject, eventdata, handles)
    % hObject    handle to menuSummer (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuAutumn_Callback(hObject, eventdata, handles)
    % hObject    handle to menuAutumn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuWinter_Callback(hObject, eventdata, handles)
    % hObject    handle to menuWinter (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuGray_Callback(hObject, eventdata, handles)
    % hObject    handle to menuGray (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuBone_Callback(hObject, eventdata, handles)
    % hObject    handle to menuBone (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuCopper_Callback(hObject, eventdata, handles)
    % hObject    handle to menuCopper (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuPink_Callback(hObject, eventdata, handles)
    % hObject    handle to menuPink (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --------------------------------------------------------------------
function menuLines_Callback(hObject, eventdata, handles)
    % hObject    handle to menuLines (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    colormapSelection(hObject);
    
    
    % --- Executes on button press in pushbuttonSegmentationRun.
function pushbuttonSegmentationRun_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonSegmentationRun (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    launchExportSegmentationFigure(hObject);
    
    
    % --- Executes on key press with focus on toggleSegmentation and none of its controls.
function toggleSegmentation_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to toggleSegmentation (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on key press with focus on toggleBasicAnalysis and none of its controls.
function toggleBasicAnalysis_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to toggleBasicAnalysis (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    % --------------------------------------------------------------------
function menuTakeScreenshot_Callback(hObject, eventdata, handles)
    % hObject    handle to menuTakeScreenshot (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    menuSaveAsPng(hObject);
    
    
    % --- Executes on key press with focus on togglebuttonBAProfile and none of its controls.
function togglebuttonBAProfile_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to togglebuttonBAProfile (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in togglebuttonBAvoids.
function togglebuttonBAvoids_Callback(hObject, eventdata, handles)
    % hObject    handle to togglebuttonBAvoids (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_toggleBATabButton(hObject, 3);
    m_refreshPreviewRoi(hObject, false);
    
    % --- Executes on key press with focus on togglebuttonBARoi and none of its controls.
function togglebuttonBARoi_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to togglebuttonBARoi (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    
    
function editMaskMinValue_Callback(hObject, eventdata, handles)
    % hObject    handle to editMaskMinValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editMaskMinValue as text
    %        str2double(get(hObject,'String')) returns contents of editMaskMinValue as a double
    updateBAvoidsMaskHistogram(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function editMaskMinValue_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editMaskMinValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
function editMaskMaxValue_Callback(hObject, eventdata, handles)
    % hObject    handle to editMaskMaxValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    updateBAvoidsMaskHistogram(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function editMaskMaxValue_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editMaskMaxValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
function editBAvoidsValue_Callback(hObject, eventdata, handles)
    % hObject    handle to editBAvoidsValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    updateBAvoidsMaskHistogram(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function editBAvoidsValue_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editBAvoidsValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton46 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    displayPorosityVsFiles(hObject);
    
    
    % --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton47 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    exportPorosityVsFiles(hObject);
    
    % --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton18 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function editMenu_Callback(hObject, eventdata, handles)
    % hObject    handle to editMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function menuRotateAllImages_Callback(hObject, eventdata, handles)
    % this function is reached by the Rotate menu button and will allow the
    % user to rotate all the images loaded or selected
    rotateData(hObject, 'allImages')
    
    % --------------------------------------------------------------------
function menuRotateSelectedImages_Callback(hObject, eventdata, handles)
    % hObject    handle to menuRotateSelectedImages (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    rotateData(hObject, 'selectedImages');
    
    
function textBAprofileBinSizeValue_Callback(hObject, eventdata, handles)
    % hObject    handle to textBAprofileBinSizeValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes during object creation, after setting all properties.
function textBAprofileBinSizeValue_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to textBAprofileBinSizeValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in togglebuttonBAgeoCorrection.
function togglebuttonBAgeoCorrection_Callback(hObject, eventdata, handles)
    % hObject    handle to togglebuttonBAgeoCorrection (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of togglebuttonBAgeoCorrection
    m_toggleBATabButton(hObject, 4);
    m_refreshPreviewRoi(hObject, true);
    
    
    % --- Executes on button press in pushbuttonBAgeoCorrectionSelection.
function pushbuttonBAgeoCorrectionSelection_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAgeoCorrectionSelection (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    geometryCorrectionSelection(hObject);
    
    
    % --- Executes during object deletion, before destroying properties.
function uipanelNormalization_DeleteFcn(hObject, eventdata, handles)
    % hObject    handle to uipanelNormalization (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbuttonBAgeoCorrectionExport.
function pushbuttonBAgeoCorrectionExport_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAgeoCorrectionExport (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    exportBAgeoCorrection(hObject);
    
    
    % --- Executes on button press in radiobuttonBAgeoCorrectionAutoRefresh.
function radiobuttonBAgeoCorrectionAutoRefresh_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBAgeoCorrectionAutoRefresh (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if get(hObject,'Value')
        set(handles.pushbuttonBAgeoCorrectionRefreshPreview,'visible','off')
    else
        set(handles.pushbuttonBAgeoCorrectionRefreshPreview,'visible','on')
    end
    
    
    % --- Executes on button press in pushbuttonBAgeoCorrectionRefreshPreview.
function pushbuttonBAgeoCorrectionRefreshPreview_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAgeoCorrectionRefreshPreview (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    updateBAgeoCorrection(hObject, true)
    
    
    % --- Executes on button press in pushbuttonBAgeoCorrectionExportReload.
function pushbuttonBAgeoCorrectionExportReload_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAgeoCorrectionExportReload (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    exportBAgeoCorrection(hObject, true);
    
    
    % --- Executes on button press in togglebuttonBACombine.
function togglebuttonBACombine_Callback(hObject, eventdata, handles)
    % hObject    handle to togglebuttonBACombine (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    m_toggleBATabButton(hObject, 5);
    m_refreshPreviewRoi(hObject, true);
    
    
    % --- Executes on button press in pushbuttonBAcombineSelect.
function pushbuttonBAcombineSelect_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAcombineSelect (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    selectBAcombineROIs(hObject);
    
    
    % --- Executes on button press in pushbuttonBAcombineCreate.
function pushbuttonBAcombineCreate_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAcombineCreate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    createAndLoadCombineImages(hObject);
    
    
    % --- Executes on button press in radiobuttonBAcombineBatchAverage.
function radiobuttonBAcombineBatchAverage_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBAcombineBatchAverage (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    setBatchModeMode(hObject, 'average');
    % Hint: get(hObject,'Value') returns toggle state of radiobuttonBAcombineBatchAverage
    
    
    % --- Executes on button press in radiobuttonBAcombineBatchMedian.
function radiobuttonBAcombineBatchMedian_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBAcombineBatchMedian (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    setBatchModeMode(hObject, 'median');
    % Hint: get(hObject,'Value') returns toggle state of radiobuttonBAcombineBatchMedian
    
    
    
function editBAcombineBatchPath_Callback(hObject, eventdata, handles)
    % hObject    handle to editBAcombineBatchPath (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    checkBAcombineBatchModeGUI(hObject);
    
    % --- Executes during object creation, after setting all properties.
function editBAcombineBatchPath_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editBAcombineBatchPath (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbuttonBAbatchSelectPath.
function pushbuttonBAbatchSelectPath_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAbatchSelectPath (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    selectBAcombineBatchFolder(hObject);
    checkBAcombineBatchModeGUI(hObject);
    
function editBAcombineBatchBaseFileName_Callback(hObject, eventdata, handles)
    % hObject    handle to editBAcombineBatchBaseFileName (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    checkBAcombineBatchModeGUI(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function editBAcombineBatchBaseFileName_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editBAcombineBatchBaseFileName (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on selection change in listboxBAcombineBatchListFiles.
function listboxBAcombineBatchListFiles_Callback(hObject, eventdata, handles)
    % hObject    handle to listboxBAcombineBatchListFiles (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listboxBAcombineBatchListFiles contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listboxBAcombineBatchListFiles
    
    
    % --- Executes during object creation, after setting all properties.
function listboxBAcombineBatchListFiles_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listboxBAcombineBatchListFiles (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbutton65.
function pushbutton65_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton65 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    loadBAcombineBatchFiles(hObject);
    checkBAcombineBatchModeGUI(hObject);
    
    
function editBAcombineBatchNbrFiles_Callback(hObject, eventdata, handles)
    % hObject    handle to editBAcombineBatchNbrFiles (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    checkBAcombineBatchModeGUI(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function editBAcombineBatchNbrFiles_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editBAcombineBatchNbrFiles (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbuttonBAcombineBatchCombine.
function pushbuttonBAcombineBatchCombine_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonBAcombineBatchCombine (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    combineBatchMode(hObject);
    
    % --- Executes on key press with focus on editBAcombineBatchNbrFiles and none of its controls.
function editBAcombineBatchNbrFiles_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to editBAcombineBatchNbrFiles (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on key press with focus on listboxBAcombineBatchListFiles and none of its controls.
function listboxBAcombineBatchListFiles_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listboxBAcombineBatchListFiles (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    switch eventdata.Key
        case 'delete'
            deleteSelectedBAcombineListLine(hObject);
        case 'backspace'
            deleteSelectedBAcombineListLine(hObject);
        otherwise
    end
    checkBAcombineBatchModeGUI(hObject);
    
    
    
    % --- Executes on button press in pushbuttonNormalizationBatchFolder.
function pushbuttonNormalizationBatchFolder_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonNormalizationBatchFolder (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    selectNormalizationBatchOutputFolder(hObject);
    checkNormalizationBatchGui(hObject)
    
function editNormalizationBatchFolder_Callback(hObject, eventdata, handles)
    % hObject    handle to editNormalizationBatchFolder (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    checkNormalizationBatchGui(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function editNormalizationBatchFolder_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editNormalizationBatchFolder (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function editNormalizationBatchBaseFileName_Callback(hObject, eventdata, handles)
    % hObject    handle to editNormalizationBatchBaseFileName (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    checkNormalizationBatchGui(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function editNormalizationBatchBaseFileName_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editNormalizationBatchBaseFileName (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbutton70.
function pushbutton70_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton70 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes on button press in pushbuttonNormalizationBatchRun.
function pushbuttonNormalizationBatchRun_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonNormalizationBatchRun (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    runBatchNormalization(hObject);
    
    
    % --- Executes on button press in pushbutton72.
function pushbutton72_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton72 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    loadNormalizationBatchFiles(hObject);
    checkNormalizationBatchGui(hObject);
    
    
    % --- Executes on selection change in listboxNormalizationBatchListOfFiles.
function listboxNormalizationBatchListOfFiles_Callback(hObject, eventdata, handles)
    % hObject    handle to listboxNormalizationBatchListOfFiles (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listboxNormalizationBatchListOfFiles contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listboxNormalizationBatchListOfFiles
    
    
    % --- Executes during object creation, after setting all properties.
function listboxNormalizationBatchListOfFiles_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listboxNormalizationBatchListOfFiles (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbuttonNormalizationBatchFolder.
function pushbutton73_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonNormalizationBatchFolder (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    
function edit54_Callback(hObject, eventdata, handles)
    % hObject    handle to editNormalizationBatchFolder (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editNormalizationBatchFolder as text
    %        str2double(get(hObject,'String')) returns contents of editNormalizationBatchFolder as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editNormalizationBatchFolder (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    
function edit55_Callback(hObject, eventdata, handles)
    % hObject    handle to editNormalizationBatchBaseFileName (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of editNormalizationBatchBaseFileName as text
    %        str2double(get(hObject,'String')) returns contents of editNormalizationBatchBaseFileName as a double
    
    
    % --- Executes during object creation, after setting all properties.
function edit55_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editNormalizationBatchBaseFileName (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in pushbuttonNormalizationBatchRun.
function pushbutton74_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonNormalizationBatchRun (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    
    
    % --- Executes on key press with focus on listboxNormalizationBatchListOfFiles and none of its controls.
function listboxNormalizationBatchListOfFiles_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listboxNormalizationBatchListOfFiles (see GCBO)
    % eventdata  structure with the following fields (see UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    switch eventdata.Key
        case 'delete'
            deleteSelectedNormalizationBatchListLine(hObject);
        case 'backspace'
            deleteSelectedNormalizationBatchListLine(hObject);
        otherwise
    end
    checkNormalizationBatchGui(hObject);
    
    
    % --- Executes on button press in radiobuttonScaleLinear.
function radiobuttonScaleLinear_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonScaleLinear (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(gcf,'pointer','watch');
    changeScale(hObject, 'linear');
    m_displayImage(hObject,'data');
    set(gcf,'pointer','arrow');
    
    
    % --- Executes on button press in radiobuttonScaleLog.
function radiobuttonScaleLog_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonScaleLog (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(gcf,'pointer','watch');
    changeScale(hObject, 'log');
    m_displayImage(hObject,'data');
    set(gcf,'pointer','arrow');
    
    
    % --- Executes on button press in pushbuttonAlignmentLeft.
function pushbuttonAlignmentLeft_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentLeft (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'left');
    
    
    % --- Executes on button press in pushbuttonAlignmentRight.
function pushbuttonAlignmentRight_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentRight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'right');
    
    % --- Executes on button press in pushbuttonAlignmentDown.
function pushbuttonAlignmentDown_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentDown (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'down');
    
    
    % --- Executes on button press in pushbuttonAlignmentUp.
function pushbuttonAlignmentUp_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentUp (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'up');
    
    
    % --- Executes on button press in pushbuttonAlignmentRotateRight.
function pushbuttonAlignmentRotateRight_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentRotateRight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'rotate_right');
    
    
    % --- Executes on button press in pushbuttonAlignmentRotateLeft.
function pushbuttonAlignmentRotateLeft_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentRotateLeft (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'rotate_left');
    
    
    % --- Executes on button press in pushbuttonAlignmentDM.
function pushbuttonAlignmentDM_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentDM (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    defineAlignmentMarkers(hObject);
    
    % --- Executes on button press in pushbuttonFullReset.
function pushbuttonFullReset_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonFullReset (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    resetAlignment(hObject);
    refreshAlignmentPreview(hObject);
    
    % --- Executes on button press in pushbuttonResetSelectionOnly.
function pushbuttonResetSelectionOnly_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonResetSelectionOnly (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    resetAlignmentSelection(hObject);
    refreshAlignmentPreview(hObject);
    
    % --- Executes on button press in pushbuttonExportAlignmentImages.
function pushbuttonExportAlignmentImages_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonExportAlignmentImages (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    exportAlignmentImages(hObject, false);
    
    % --- Executes on button press in pushbuttonExportReloadAlignmentImages.
function pushbuttonExportReloadAlignmentImages_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonExportReloadAlignmentImages (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    exportAlignmentImages(hObject, true);
    
    % --- Executes on selection change in listbox15.
function listbox15_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns listbox15 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox15
    
    
    % --- Executes during object creation, after setting all properties.
function listbox15_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    % --- Executes on button press in pushbuttonAlignmentLoadConfiguration.
function pushbuttonAlignmentLoadConfiguration_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentLoadConfiguration (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    loadAlignmentConfiguration(hObject);
    
    % --- Executes on button press in pushbuttonAlignmentSaveConfiguration.
function pushbuttonAlignmentSaveConfiguration_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentSaveConfiguration (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    saveAlignmentConfiguration(hObject);
    
    % --- Executes on button press in pushbuttonAlignmentPreviousImage.
function pushbuttonAlignmentPreviousImage_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentPreviousImage (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if handles.blockAlignmentButton
        return;
    end
    set(gcf,'pointer','watch');
    alignmentChangeImage(hObject, 'prev');
    set(gcf,'pointer','arrow');
    handles.blockAlignmentButton = false;
    guidata(hObject, handles);
    
    % --- Executes on button press in pushbuttonAlignmentNextImage.
function pushbuttonAlignmentNextImage_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentNextImage (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if handles.blockAlignmentButton
        return
    end
    set(gcf,'pointer','watch');
    alignmentChangeImage(hObject, 'next');
    set(gcf,'pointer','arrow');
    handles.blockAlignmentButton = false;
    guidata(hObject, handles);
    
    % --- Executes on button press in pushbuttonAlignmentRightRight.
function pushbuttonAlignmentRightRight_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentRightRight (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'rightright');
    
    % --- Executes on button press in pushbuttonAlignmentLeftLeft.
function pushbuttonAlignmentLeftLeft_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentLeftLeft (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'leftleft');
    
    
    % --- Executes on button press in pushbuttonAlignmentUpUp.
function pushbuttonAlignmentUpUp_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentUpUp (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'upup');
    
    
    % --- Executes on button press in pushbuttonAlignmentDownDown.
function pushbuttonAlignmentDownDown_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentDownDown (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    alignmentMove(hObject,'downdown');
    
    
    % --------------------------------------------------------------------
function menuEmptyDarkField_Callback(hObject, eventdata, handles)
    % hObject    handle to menuEmptyDarkField (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    createEmptyDarkField(hObject);
    m_updateGui(hObject);
    checkNormalizationBatchGui(hObject);
    
    
    
function editAlignmentAngleValue_Callback(hObject, eventdata, handles)
    % hObject    handle to editAlignmentAngleValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    manualRotation(hObject);
    
    
    % --- Executes during object creation, after setting all properties.
function editAlignmentAngleValue_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editAlignmentAngleValue (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in checkboxGammaFilteringFlag.
function checkboxGammaFilteringFlag_Callback(hObject, eventdata, handles)
    % hObject    handle to checkboxGammaFilteringFlag (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of checkboxGammaFilteringFlag
    
    
    % --- Executes on button press in pushbuttonAlignmentLoadMarkers.
function pushbuttonAlignmentLoadMarkers_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentLoadMarkers (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    loadAlignmentMarkers(hObject);
    validateManualAlignmentEntries(hObject);
    refreshAlignmentPreview(hObject);
    
    % --- Executes on button press in pushbuttonAlignmentSaveMarkers.
function pushbuttonAlignmentSaveMarkers_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbuttonAlignmentSaveMarkers (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    saveAlignmentMarkers(hObject);
    
    
    % --- Executes on key press with focus on uitableAlignmentMarkers and none of its controls.
function uitableAlignmentMarkers_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to uitableAlignmentMarkers (see GCBO)
    % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --- Executes when entered data in editable cell(s) in uitableAlignmentMarkers.
function uitableAlignmentMarkers_CellEditCallback(hObject, eventdata, handles)
    % hObject    handle to uitableAlignmentMarkers (see GCBO)
    % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
    %	Indices: row and column indices of the cell(s) edited
    %	PreviousData: previous data for the cell(s) edited
    %	EditData: string(s) entered by the user
    %	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
    %	Error: error string when failed to convert EditData to appropriate value for Data
    % handles    structure with handles and user data (see GUIDATA)
    validateManualAlignmentEntries(hObject);
    refreshAlignmentPreview(hObject);
    
    
    
    % --------------------------------------------------------------------
function fileMenuMCPflag_Callback(hObject, eventdata, handles)
    % hObject    handle to fileMenuMCPflag (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if strcmp(get(handles.fileMenuMCPflag,'checked'),'on')
        set(handles.fileMenuMCPflag,'checked','off')
    else
        set(handles.fileMenuMCPflag,'checked','on')
    end
    
    
    % --- Executes on button press in radiobuttonBAcombineBatchSum.
function radiobuttonBAcombineBatchSum_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobuttonBAcombineBatchSum (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    setBatchModeMode(hObject, 'sum');
    
    % Hint: get(hObject,'Value') returns toggle state of radiobuttonBAcombineBatchSum
