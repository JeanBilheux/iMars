function exportBAgeoCorrection(hObject, bReload)
    % this function will export all the files selected after cylinder
    % geometry correction
    
    if nargin < 2
        bReload = false;
    end
    
    handles = guidata(hObject);
    
    % do we have a selection
    cylinderX1Y1X2Y2 = handles.cylinderX1Y1X2Y2;
    if isempty(cylinderX1Y1X2Y2)
        return
    end
    
    % get the file(s) currently selected
    activeListBox = handles.listboxDataFile;
    fileHandles = handles.files;
    selection = get(activeListBox,'value');
    sz_selection = (size(selection));
    nbr_selection = sz_selection(2);
    
    % ask for final destination
    path = handles.path;
    folderName = uigetdir(path, 'Where do you want to create the folder geoCorrected?');
    if folderName == 0
        return %we did not select a folder
    end
    folderName = [folderName '/geoCorrected/'];
    [~, ~] = mkdir(folderName);
    
    listFileNames = fileHandles.fileNames;
    
    display_type = getDisplayType(handles);
    
    %initialize progress bar
    handles.myProgress = statusProgressBar(nbr_selection, ...
        handles.backgroundProgressBar, ...
        handles.movingProgressBar);
    guidata(hObject, handles);
    
    for i=1:nbr_selection
        
        tmpFileName = createTmpOutputFileName(folderName, listFileNames{selection(i)});
        
        image = handles.files.images{selection(i)};
        finalImage = getFinalImageGeoCorrection(hObject, image);
        
        [finalImage, ~, ~] = getGeoCorrectionImage(finalImage, display_type);
        
        %         maxValue = max(max(finalImage(:)));
        %         finalImage = finalImage / maxValue;
        
        if ~isempty(finalImage)
            fitswrite(finalImage, tmpFileName);
            
            % reload the image if requested
            if bReload
                
                [~,file,ext] = fileparts(tmpFileName);
                fileName = [file, ext];
                
                flag = openListOfFiles(hObject, fileName, folderName, ...
                    handles.files.nbr, true, 'data');
                handles = guidata(hObject);
                
            end
            
        end
        
        %update progress bar
        handles.myProgress = handles.myProgress.nextStep();
    end
    
    guidata(hObject,handles);
    progressDone(hObject);
    
end

function fileName = createTmpOutputFileName(path, shortFileName)
    % this function will create the output full file name
    
    [~, name, ~] = fileparts(shortFileName);
    fileName = [path, name, '_geoCorrected.fits'];
    
end