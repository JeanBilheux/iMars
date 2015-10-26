function handles = m_InitHandles(handles)
% Initialize the handles structure

%handles = guidata(hObject);

% retrieve input arguments (for debugging)
default_path = '/Users/j35/SVN/NeutronImagingTools/data/raw/';
default_roi_path = '/Users/j35/SVN/NeutronImagingTools/trunk/iMars/UnitTests/Data/';

return

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

%data files infos
handles.files.nbr = 0;
handles.files.fileNames = {};
handles.files.paths = {};
handles.files.images = {};
%calculated when retrieving data
%255, 65535 or max(max(image))
handles.files.globalMaxIntensity = 0;  

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

%guidata(hObject, handles);
