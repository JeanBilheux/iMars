function exportAlignmentImages(hObject, bReload)
    % This function will create the new realigned images and will reload
    % them into the application if bReload is true
    
    handles = guidata(hObject);
    
    % ask where the user wants to create the new "alignment" folder
    path = handles.path;
    outputFolder = uigetdir(path, ...
        'Where do you want to create the new realigned images');
    
    if outputFolder == 0
        return;
    end
    
    set(gcf,'pointer','watch');
    
    % get alignment table
    bigTable = get(handles.uitableAlignment,'data');
    
    % get images and names of files
    images = handles.files.images;
    fileNames = handles.files.fileNames;
    
    % nbr of files
    nbrFiles = numel(fileNames);
    
    nbrSteps = nbrFiles;    
    % initialize progress bar
    handles.myProgress = statusProgressBar(nbrSteps, ...
        handles.backgroundProgressBar, ...
        handles.movingProgressBar);
    guidata(hObject, handles);
    
    for i=1:nbrFiles
        
        newFileName = createOutputFileName(outputFolder, ...
            fileNames{i}, ...
            'aligned_', ...
            'fits');
        
        newImage = applyAlignmentParameters(images{i}, ...
            bigTable(i,:));
        
        fitswrite(newImage, newFileName);
        
        if bReload
            
            [~,file,ext] = fileparts(newFileName);
            fileName = [file, ext];
            
            flag = openListOfFiles(hObject, fileName, outputFolder, ...
                handles.files.nbr, true, 'data');
            handles = guidata(hObject);
            
        end
        
        % update progress bar
        handles.myProgress = handles.myProgress.nextStep();
        
    end
    
    if bReload
        % replace data
        % #1 first, select everything in the data file
        set(handles.listboxDataFile,'value',1:nbrFiles);
        % #2 remove all the files
        m_deleteSelectedFile(hObject,'data');
        
    end
    
    guidata(hObject, handles);
    progressDone(hObject);
    
    set(gcf,'pointer','arrow');
    
end
