function exportSegmentationHistogramExportButton(hObject)
    
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
    listFiles = get(handles.listboxExportSegmentationHistogram,'string');
    
    % get selection
    selection = get(handles.listboxExportSegmentationHistogram,'value');
    
    % get list of files selected
    listFilesSelected = listFiles(selection);
    
    % if nothing selected, stop right there
    if isempty(listFilesSelected)
        return
    end
    
    images = handlesMainGui.files.images;
    imagesSelected = images(selection);
    
    guidata(hObjectMainGui, handlesMainGui);
    
    parfor i=1:numel(listFilesSelected)
        
        tmpFileName = listFilesSelected{i};
        
        % define new output file name
        [~, name, ~] = fileparts(tmpFileName);
        prefix = '_histogram';
        newFileName = [path filesep name prefix '.txt'];
        
        tmpImage = imagesSelected{i};
        
        % create histogram array
        tmpHist = uint16(tmpImage);
        [counts,x] = imhist(tmpHist);
        
        comments = {sprintf('Source file name: %s', tmpFileName)};
        create2columnsCsv(newFileName, comments, x, counts);
        
    end
    
    % update progress bar
    handlesMainGui.myProgress = handlesMainGui.myProgress.nextStep();
    
    guidata(hObjectMainGui, handlesMainGui);
    progressDone(hObjectMainGui);
    
end


