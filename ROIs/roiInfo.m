function varargout = roiInfo(varargin)
    % ROIINFO MATLAB code for roiInfo.fig
    %      ROIINFO, by itself, creates a new ROIINFO or raises the existing
    %      singleton*.
    %
    %      H = ROIINFO returns the handle to a new ROIINFO or the handle to
    %      the existing singleton*.
    %
    %      ROIINFO('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in ROIINFO.M with the given input arguments.
    %
    %      ROIINFO('Property','Value',...) creates a new ROIINFO or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before roiInfo_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to roiInfo_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help roiInfo
    
    % Last Modified by GUIDE v2.5 18-Dec-2012 20:27:08
    
    % Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @roiInfo_OpeningFcn, ...
        'gui_OutputFcn',  @roiInfo_OutputFcn, ...
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
    
    
    % --- Executes just before roiInfo is made visible.
function roiInfo_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to roiInfo (see VARARGIN)
    
    %recover arguments
%     roiRectangle = varargin{1};
%     isRoiRectangleEllipse = varargin{2};
%     image = varargin{3};
    path = varargin{4};
    
    handles.path = path;
    
    % Choose default command line output for roiInfo
    handles.output = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes roiInfo wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    
    % --- Outputs from this function are returned to the command line.
function varargout = roiInfo_OutputFcn(~, ~, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    
    % --------------------------------------------------------------------
function menubarFile_Callback(~, ~, ~)
    % hObject    handle to menubarFile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function roiInfoSaveAs_Callback(hObject, ~, ~) 
    % hObject    handle to roiInfoSaveAs (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    saveRoiInfo(hObject);
    
    
    
