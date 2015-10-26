function exportSegmentationExportButton(hObject)
    
    handles = guidata(hObject);
    
    handlesMainGui = handles.handlesMainGui;
    hObjectMainGui = handles.hObjectMainGui;
    
    path = handles.defaultPath;
    path = uigetdir(path, 'Select destination folder');
    
    % initialize progress bar
    handlesMainGui.myProgress = statusProgressBar(1, ...
        handlesMainGui.backgroundProgressBar, ...
        handlesMainGui.movingProgressBar);
    
    % get list of files
    listFiles = get(handles.listboxExportSegmentation,'string');
    
    % get selection
    selection = get(handles.listboxExportSegmentation,'value');
    
    % get list of files selected
    listFilesSelected = listFiles(selection);
    
    % if nothing selected, stop right there
    if isempty(listFilesSelected)
        return
    end
    
    images = handlesMainGui.files.images;
    imagesSelected = images(selection);
    
    histoThresholdValues = handlesMainGui.histoThresholdValues;
    histoThresholdTypes = handlesMainGui.histoThresholdTypes;
    
    guidata(hObjectMainGui, handlesMainGui);
    
    parfor i=1:numel(listFilesSelected)
        
        tmpFileName = listFilesSelected{i};
        
        % define new output file name
        [~, name, ext] = fileparts(tmpFileName);
        prefix = '_segmented';
        newFileName = [path filesep name prefix ext];
        
        % create image segmented
        tmpImage = imagesSelected{i};
        
        finalImage = segmentImage(tmpImage, ...
            histoThresholdValues, ...
            histoThresholdTypes);
        
        fitswrite(finalImage, newFileName);
        
    end
    
    % update progress bar
    handlesMainGui.myProgress = handlesMainGui.myProgress.nextStep();
    
    guidata(hObjectMainGui, handlesMainGui);
    progressDone(hObjectMainGui);
    
end