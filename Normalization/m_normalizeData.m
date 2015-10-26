function m_normalizeData(hObject)
    %this will run the normalization
    
    message = sprintf('Running normalization ...');
    statusBarMessage(hObject, message, 0, false);
    
    handles = guidata(hObject);
    
    %ask where to create the normalized data folder
    path = handles.path;
    folderName = uigetdir(path, 'Where do you want to create the Normalized data folder?');
    if folderName == 0
        return %we did not select a folder
    end
    folderName = [folderName '/Normalized'];
    [~, ~] = mkdir(folderName);
    
    listDataFiles = handles.files.fileNames;
    nbrFiles = numel(listDataFiles);
    
    [roiLogicalArray, isWithRoi] = getRoiLogicalArray(hObject);
    
    %take average of all open beam
    averageTotalOpenBeam = getAverageArray(hObject, 'OB');
    if isWithRoi
        averageRoiOpenBeam = getAverageOfRoi(averageTotalOpenBeam, roiLogicalArray);
    end
    
    %take average of all dark field
    averageTotalDarkField = getAverageArray(hObject, 'DF');
    data = handles.files.images;
    
    for i=1:nbrFiles
        
        tmpData = data{i};
        tmpDataFiltered = applyGammaFiltering(hObject, tmpData);
        
        imshow(tmpDataFiltered,[]);
        colorbar;
        
        if isWithRoi
            averageTmpData = getAverageOfRoi(tmpDataFiltered, roiLogicalArray);
            ratio = averageTmpData / averageRoiOpenBeam;
            tmpDataFiltered = tmpDataFiltered / ratio;
        end
        
        topRatio = tmpDataFiltered - averageTotalDarkField;
        bottomRatio = averageTotalOpenBeam - averageTotalDarkField;
        
        normalizedImage = topRatio ./ bottomRatio;
        
        %bring to zero all the counts < 0
        lessThanZero = normalizedImage < 0;
        normalizedImage(lessThanZero) = 0;
        
        %bring to 1 all the counts > 1
        moreThanOne = normalizedImage > 1;
        normalizedImage(moreThanOne) = 1;
        
        %normalizedImage = cast(normalizedImage,'int16');
        
        createNormalizedFile(normalizedImage, folderName, listDataFiles{i});
        
    end
    
    message = sprintf('Normalization is Done !');
    statusBarMessage(hObject, message, 5, false);
    
end

function createNormalizedFile(data, folder, fileName)
    %this routine will create the output normalized file in the folder
    %specified
    
    [path, name, ~] = fileparts(fileName);
    fileName = fullfile(path, [name, '.fits']);
    
    fullFileName = [folder '/' fileName];
    %    imwrite(data,fullFileName,'tif');
    % data = im2int16(data);
    fitswrite(data, fullFileName);
    
end

