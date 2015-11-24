function combineBatchMode(hObject)
    % run the batch mode
    
    % check that everything is ok to move on
    checkStatus = checkEverythingIsReadyToGo(hObject);
    
    % something is wrong, stop right now
    if ~checkStatus
        errordlg('Incompatible number of files and algorithm selected!', ...
            'Batch Error!');
        return
    end
    
    % everything is ok, we can move on
    handles = guidata(hObject);
    
    % show message saying that it will take a while
    lastString = get(handles.saveSessionMessageTag,'String');
    set(handles.saveSessionMessageTag,'String',...
        {'PROCESSING CALCULATION ...','','Please Be Patient!'});
    set(handles.saveSessionMessageTag,'visible','on');
    drawnow update;
    
    % get mode selected
    modeSelected = getCombineModeSelected(handles);
    
    % output folder
    outputFolder = get(handles.editBAcombineBatchPath,'string');
    
    %  base file name
    baseFileName = get(handles.editBAcombineBatchBaseFileName,'string');
    
    % folder of files
    inputFolder = handles.inputPathnameOfBAcombine;
    
    % group the list of files together
    groupFilesByNbr = str2double(get(handles.editBAcombineBatchNbrFiles, ...
        'string'));
    listFiles = get(handles.listboxBAcombineBatchListFiles,'string');
    nbrFiles = numel(listFiles);
    nbrProcess = nbrFiles / groupFilesByNbr;
    
    for proIndex=0:(nbrProcess-1)
        
        fromIndex = proIndex * groupFilesByNbr+1;
        toIndex = (proIndex+1) * groupFilesByNbr;
        %         fprintf('from %d to %d\n', fromIndex, toIndex);
        tmpListFiles = listFiles(fromIndex:toIndex);
        runCombineInBatch(inputFolder, ...
            tmpListFiles, ...
            outputFolder, ...
            baseFileName, ...
            proIndex, ...
            modeSelected);
        
    end
    
    set(handles.saveSessionMessageTag,'visible','off');
    set(handles.saveSessionMessageTag,'String',lastString);
    drawnow update;
    
end


function modeSelected = getCombineModeSelected(handles)
    
    if get(handles.radiobuttonBAcombineBatchAverage,'value')
        modeSelected = 'add';
        return
    end
    
    if get(handles.radiobuttonBAcombineBatchMedian,'value')
        modeSelected = 'median';
        return
    end
    
    if get(handles.radiobuttonBAcombineBatchSum,'value')
        modeSelected = 'sum';
        return
    end
    
end


function runCombineInBatch(inputFolder, ...
        listFiles, ...
        outputFolder, ...
        baseFileName, ...
        proIndex, ...
        modeSelected)
    % will run in background the process
    
    % make output file name
    index = sprintf('%.3d',proIndex+1);
    outputFileName = [outputFolder,'/',baseFileName,'_',index,'.fits'];
    
    imagesArray = loadImages(inputFolder, listFiles);
    switch modeSelected
        case 'add'
            finalImage = averageImages(imagesArray);
        case 'median'
            finalImage = medianImages(imagesArray);
        case 'sum'
            finalImage = addImages(imagesArray);
            
    end
    finalImage = single(squeeze(finalImage));
    fitswrite(finalImage, outputFileName);
    
end


function finalImage = addImages(imagesSelected)
    % add the images
    
    sz = size(imagesSelected);
    nbrImages = sz(2);
    finalImage = zeros(size(imagesSelected{1}));
    for i=1:nbrImages
        finalImage = finalImage + imagesSelected{i};
    end
    
end


function finalImage = averageImages(imagesSelected)
    % add the images
    
    sz = size(imagesSelected);
    nbrImages = sz(2);
    finalImage = zeros(size(imagesSelected{1}));
    for i=1:nbrImages
        finalImage = finalImage + imagesSelected{i};
    end
    finalImage = finalImage / nbrImages;
    
end


function finalImage = medianImages(imagesSelected)
    % will calculate the median image
    
    nbrImagesTmp = size(imagesSelected);
    nbrImages = nbrImagesTmp(2);
    [h,w] = size(imagesSelected{1});
    bigArray = zeros(nbrImages,h,w);
    
    for i=1:nbrImages
        bigArray(i,:,:) = imagesSelected{i};
    end
    
    sortedFinalImage = sort(bigArray,1);
    medianIndex = fix(nbrImages/2);
    finalImage = sortedFinalImage(medianIndex,:,:);
    
end


function imagesArray = loadImages(inputFolder, listFiles)
    % load images
    
    % are we dealing with fits or tiff
    [~,~,ext] = fileparts(listFiles{1});
    imagesArray = {};
    nbrFiles = numel(listFiles);
    switch ext
        case '.fits'
            for i=1:nbrFiles
                fullFileName = [inputFolder,listFiles{i}];
                imagesArray{i}= fitsread(fullFileName); %#ok<AGROW>
            end
        otherwise
            for i=1:nbrFiles
                fullFileName = [inputFolder,listFiles{i}];
                imagesArray{i}= imread(fullFileName); %#ok<AGROW>
            end
    end
    
end


function  checkStatus = checkEverythingIsReadyToGo(hObject)
    % check that everything  is ok
    % for example, that we have at least 3 files with Median mode
    % at least 2 files in average modes
    
    handles = guidata(hObject);
    
    % get mode selected
    isAverageSelected = get(handles.radiobuttonBAcombineBatchAverage,...
        'value');
    
    % get number of files listed
    listfile = get(handles.listboxBAcombineBatchListFiles,'string');
    sz = size(listfile);
    if sz(1) == 1
        checkStatus = false;
        return
    end
    
    numberFiles = numel(listfile);
    if isAverageSelected
        if numberFiles>1
            checkStatus = true;
            return
        end
    else
        if numberFiles>2
            checkStatus = true;
            return
        end
    end
    
    checkStatus = false;
    return;
    
end