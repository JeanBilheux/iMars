function loadHandles(hObject, fullFileName)
    
    handles = guidata(hObject);
    
    %     try
    
    set(handles.loadSessionMessageTag,'visible','on');
    drawnow
    
    message = ['Loading Configuration File: ' ...
        fullFileName];
    statusBarMessage(hObject, message, 0, false);
    drawnow;
    
    newHandles = load(fullFileName,'-mat');
    replaceHandles(hObject, newHandles);
    
    m_updateGui(hObject);
    m_updateManualRoiSelection(hObject);
    
    set(handles.loadSessionMessageTag,'visible','off');
    drawnow
    
    statusBarMessage(hObject, '', 0, false);
    
    %     catch errMessage
    %
    %         set(handles.loadSessionMessageTag,'visible','off');
    %         drawnow
    %
    %         message = sprintf('Error loading the configuration file %s - %s -> %s', ...
    %             fullFileName, errMessage.identifier, errMessage.message);
    %
    %         statusBarMessage(hObject, message, 5, true);
    %
    %     end
    
end

function replaceHandles(hObject, newHandles)
    
    handles = guidata(hObject);
    
    handles.defaultPath = newHandles.defaultPath;
    handles.defaultRoiPath = newHandles.defaultRoiPath;
    handles.path = newHandles.path;
    if isfield(newHandles,'inputPathnameOfBAcombine')
        handles.inputPathnameOfBAcombine = newHandles.inputPathnameOfBAcombine;
    end
    
    handles.files.ext = newHandles.files.ext;
    handles.files.class = newHandles.files.class;
    
    handles.files.nbr = newHandles.files.nbr;
    handles.files.fileNames = newHandles.files.fileNames;
    handles.files.paths = newHandles.files.paths;
    handles.files.images = newHandles.files.images;
    handles.files.globalMaxIntensity = newHandles.files.globalMaxIntensity;
    
    handles.obfiles.nbr = newHandles.obfiles.nbr;
    handles.obfiles.fileNames = newHandles.obfiles.fileNames;
    handles.obfiles.paths = newHandles.obfiles.paths;
    handles.obfiles.images = newHandles.obfiles.images;
    handles.obfiles.globalMaxIntensity = newHandles.obfiles.globalMaxIntensity;
    
    handles.dffiles.nbr = newHandles.dffiles.nbr;
    handles.dffiles.fileNames = newHandles.dffiles.fileNames;
    handles.dffiles.paths = newHandles.dffiles.paths;
    handles.dffiles.images = newHandles.dffiles.images;
    handles.dffiles.globalMaxIntensity = newHandles.dffiles.globalMaxIntensity;
    
    handles.files.DataType = newHandles.files.DataType;
    
    handles.files.maxIntensity = newHandles.files.maxIntensity;
    handles.files.minIntensity = newHandles.files.minIntensity;
    
    handles.activeListbox = newHandles.activeListbox;
    handles.currentImagePreviewed = newHandles.currentImagePreviewed;
    
    handles.roiRectangleSelection = newHandles.roiRectangleSelection;
    handles.isRoiRectangleEllipse = newHandles.isRoiRectangleEllipse;
    
    handles.listboxNormalizationRoiString = newHandles.listboxNormalizationRoiString;
    handles.listboxNormalizationRoiRowSelection = newHandles.listboxNormalizationRoiRowSelection;
    
    if isfield(newHandles, 'cylinderX1Y1X2Y2')
        handles.cylinderX1Y1X2Y2 = newHandles.cylinderX1Y1X2Y2;
    else
        handles.cylinderX1Y1X2Y2 = {};
    end
    
    if isfield(newHandles, 'secondCylinderX1Y1X2Y2')
        handles.secondCylinderX1Y1X2Y2 = newHandles.secondCylinderX1Y1X2Y2;
    else
        handles.secondCylinderX1Y1X2Y2 = {};
    end
    
    if isfield(newHandles, 'calculationRegion')
        handles.calculationRegion = newHandles.calculationRegion;
    else
        handles.calculationRegion = {};
    end
    
    if isfield(newHandles, 'listboxBAprofileString')
        handles.listboxBAprofileString = newHandles.listboxBAprofileString;
        handles.listboxBAprofileSelection = newHandles.listboxBAprofileSelection;
    end
    
    if isfield(newHandles, 'listboxBAroiString')
        handles.listboxBAroiString = newHandles.listboxBAroiString;
        handles.listboxBAroiSelection = newHandles.listboxBAroiSelection;
    end
    
    if isfield(newHandles,'baCombineSelection')
        handles.baCombineSelection = newHandles.baCombineSelection;
    end
    
    if isfield(newHandles,'baCombineSignalSelection')
        handles.baCombineSignalSelection = newHandles.baCombineSignalSelection;
        handles.baCombineBackgroundSelection = newHandles.baCombineBackgroundSelection;
    end
    
    if isfield(newHandles,'normalizationBatchListDataFiles')
        set(handles.listboxNormalizationBatchListOfFiles,'string', newHandles.normalizationBatchListDataFiles);
        set(handles.editNormalizationBatchFolder,'string', newHandles.normalizationBatchOutputFolder);
        set(handles.editNormalizationBatchBaseFileName, 'string', newHandles.normalizationBatchBaseFileName);
        handles.inputPathnameOfBatchNormalization = newHandles.inputPathnameOfBatchNormalization;
    end
    
    if isfield(newHandles,'gammaFilteringFlag')
       set(handles.checkboxGammaFilteringFlag,'value',newHandles.gammaFilteringFlag);
    end
    
    if isfield(newHandles, 'alignmentMarkersTable')
       set(handles.uitableAlignmentMarkers,'Data',newHandles.alignmentMarkersTable); 
       handles.alignmentMarkers = newHandles.alignmentMarkers;
    end
    
    handles.histoThresholdValues = newHandles.histoThresholdValues;
    handles.histoThresholdTypes = newHandles.histoThresholdTypes;
    
    guidata(hObject, handles);
    
    set(handles.listboxDataFile,'string',handles.files.fileNames);
    set(handles.listboxOpenBeam,'string',handles.obfiles.fileNames);
    set(handles.listboxDarkField,'string',handles.dffiles.fileNames);
    set(handles.listboxNormalizationRoi,'string',handles.listboxNormalizationRoiString);
    set(handles.listboxNormalizationRoi,'value',handles.listboxNormalizationRoiRowSelection);
    
    if isfield(newHandles, 'listboxBAprofileString')
        set(handles.listboxBAprofile,'string', handles.listboxBAprofileString);
        set(handles.listboxBAprofile,'value', handles.listboxBAprofileSelection);
    end
    
    if isfield(newHandles, 'listboxBAroiString')
        set(handles.listboxBAroi,'string', handles.listboxBAroiString);
        set(handles.listboxBAroi,'value', handles.listboxBAroiSelection);
    end
    
    if isfield(newHandles,'listboxBAcombineString')
        
        if ~isempty(newHandles.listboxBAcombineString)
            set(handles.listboxBAcombineBatchListFiles,'string',newHandles.listboxBAcombineString);
        end
        set(handles.editBAcombineBatchPath,'string',newHandles.outputPathnameOfBAcombine);
        set(handles.radiobuttonBAcombineBatchAverage,'value',newHandles.isBAcombineAverageSelected);
        if ~strcmp(newHandles.BAcombineBaseFileName,'')
            set(handles.editBAcombineBatchBaseFileName,'string',newHandles.BAcombineBaseFileName);
        end
        set(handles.editBAcombineBatchNbrFiles,'string',newHandles.BAcombineGroupNumber);
    end
    
    if isfield(newHandles,'mcpFlag')
        set(handles.fileMenuMCPflag,'checked', newHandles.mcpFlag);
    end
    
    guidata(hObject, handles);
    
    m_displayImage(hObject,'data');
    m_refreshPreviewRoi(hObject);
    m_activateRightGui(hObject);
    
end