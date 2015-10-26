function runBatchNormalization(hObject)
    % run the normalizations as batch processes
    
    handles = guidata(hObject);
    
    %     lastString = get(handles.saveSessionMessageTag,'String');
    %     set(handles.saveSessionMessageTag,'String',{'PROCESSING CALCULATION ...','','Please Be Patient!'});
    %     set(handles.saveSessionMessageTag,'visible','on');
    %     drawnow update;
    
    % collect general informations
    outputFolderName = get(handles.editNormalizationBatchFolder,'string');
    
    % base file name
    baseFileName = get(handles.editNormalizationBatchBaseFileName,'string');
    
    % list data files
    listDataFiles = get(handles.listboxNormalizationBatchListOfFiles,'string');
    nbrFiles = numel(listDataFiles);
    
    % initialize progress bar
    handles.myProgress = statusProgressBar(nbrFiles, ...
        handles.backgroundProgressBar, ...
        handles.movingProgressBar);
    guidata(hObject, handles);
    
    % input folder
    inputFolderName = handles.inputPathnameOfBatchNormalization;
    
    % take average of all open beam
    averageTotalOpenBeam = getAverageArray(hObject, 'OB');
   
    % get roi selection
    [roiLogicalArray, isWithRoi] = getRoiLogicalArray(hObject);
    
    % take average of all open beam
    if isWithRoi
        averageRoiOpenBeam = getAverageOfRoi(averageTotalOpenBeam, roiLogicalArray);
    end
    
    % take average of all dark fields
    averageTotalDarkField = getAverageArray(hObject, 'DF');
    
    for i=1:nbrFiles
        
        shortFileName = listDataFiles{i};
        fullFileName = [inputFolderName, shortFileName];
        outputFileName = makeOutputFileName(baseFileName, shortFileName);
        
        tmpData = loadData(hObject, fullFileName);
        if isempty(tmpData)
            continue;
        end
        
        % apply gamma filtering
        tmpDataFiltered = applyGammaFiltering(hObject, tmpData);
        
        if isWithRoi
            averageTmpData = getAverageOfRoi(tmpDataFiltered, roiLogicalArray);
            ratio = averageTmpData / averageRoiOpenBeam;
            tmpDataFiltered = tmpDataFiltered / ratio;
        end
        
        topRatio = tmpDataFiltered - averageTotalDarkField;
        bottomRatio = averageTotalOpenBeam - averageTotalDarkField;
        normalizedImage = topRatio ./ bottomRatio;
        
        % bring to zero all the counts < 0
        lessThanZero = normalizedImage < 0;
        normalizedImage(lessThanZero) = 0;
        
        %bring to 1 all the counts > 1
        moreThanOne = normalizedImage > 1;
        normalizedImage(moreThanOne) = 1;
        
        createNormalizedFile(normalizedImage, outputFolderName, outputFileName);
        
        % update progress bar
        handles.myProgress = handles.myProgress.nextStep();
        
    end
    
    % Update handles structure
    guidata(hObject, handles);
    progressDone(hObject);
    
    %     set(handles.saveSessionMessageTag,'visible','off');
    %     set(handles.saveSessionMessageTag,'String',lastString);
    %     drawnow update;
    
end

function outputFileName = makeOutputFileName(baseFileName, shortFileName)
    % make the new short output file name (without full path)
    
    [~,name,~] = fileparts(shortFileName);
    outputFileName = [baseFileName,'_',name,'.fits'];
    
end

function createNormalizedFile(data, folder, fileName)
    %this routine will create the output normalized file in the folder
    %specified
    
    fullFileName = [folder '/' fileName];
    fitswrite(data, fullFileName);
    
end

function data = loadData(hObject, fullFileName)
    
    [~,~,ext] = fileparts(fullFileName);
    switch lower(ext)
        case '.fits'
            data = fitsread(fullFileName);
        case '.tiff'
            data = imread(fullFileName);
        case '.tif'
            data = imread(fullFileName);
        case ''
            data = textread(fullFileName);
        otherwise
            data = {};
    end
    
    handles = guidata(hObject);
    % apply chips offset if flag is on
    if strcmpi(get(handles.fileMenuMCPflag,'checked'),'on')
        try
            data = shiftChips(hObject, data);
        catch err
            data = {};
        end
    end
    
end