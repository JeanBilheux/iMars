function createAndLoadCombineImages(hObject)
    
    handles = guidata(hObject);
    
    lastString = get(handles.saveSessionMessageTag,'String');
    set(handles.saveSessionMessageTag,'String',{'PROCESSING CALCULATION ...','','Please Be Patient!'});
    set(handles.saveSessionMessageTag,'visible','on');
    drawnow update;
    
    path = handles.path;
    path = [path, filesep];
    
    selection = get(handles.listboxDataFile,'value');
    sz_selection = (size(selection));
    nbr_selection = sz_selection(2);
    
    images = handles.files.images;
    imagesSelected = images(selection);
    
    filenames = {};
    
    if nbr_selection > 1
        % create add image and export it (save and reload)
        finalImage = addImages(imagesSelected);
        tmpFileName = [path,'preview_combine_average.fits'];
        
        fitswrite(finalImage, tmpFileName);
        [~,file1,ext] = fileparts(tmpFileName);
        fileName1 = [file1, ext];
    end
    
    if nbr_selection > 2
        % create median image and export it (save and reload)
        finalImage = medianImages(imagesSelected);
        
        tmpFileName = [path,'preview_combine_median.fits'];
        fitswrite(finalImage, tmpFileName);
        [~,file2,ext] = fileparts(tmpFileName);
        fileName2 = [file2, ext];
    end
    
    if nbr_selection > 2
        filenames = {fileName1, fileName2};
    elseif nbr_selection == 2
        filenames = {fileName1};
    end
    
    if ~isempty(filenames)
        flag = openListOfFiles(hObject, filenames, path, ...
            handles.files.nbr, false, 'data');
        handles = guidata(hObject);
        
        guidata(hObject, handles);
    end
    
    set(handles.saveSessionMessageTag,'visible','off');
    set(handles.saveSessionMessageTag,'String',lastString);
    drawnow update;
    
end

function finalImage = addImages(imagesSelected)
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
    finalImage = squeeze(sortedFinalImage(medianIndex,:,:));
    
end
