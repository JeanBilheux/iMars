function flag = openListOfFiles(hObject, filenames, pathName, ...
        nbrHandlesFiles, bSingleFile, sourceType)
    % load the list of files given
    
    handles = guidata(hObject);
    
    handles.path = pathName;
    
    if bSingleFile
        nbrFiles = 1;
    else
        nbrFiles = size(filenames,2);
    end
    
    %         % inform user that he is working with a lot of files
    %         if nbrFiles > handles.files.maxFilesNbr
    %             str = sprintf('This version does not allow to load more than %d at the same time', handles.files.maxFilesNbr);
    %             msgbox(str, 'Too many files selected !','error');
    %             return;
    %         end
    
    %initialize progress bar
    handles.myProgress = statusProgressBar(nbrFiles, ...
        handles.backgroundProgressBar, ...
        handles.movingProgressBar);
    guidata(hObject, handles);
    
    listOfFilesRejected = {};
    index_rejected = 1;
    
    for i=1:nbrFiles
        if bSingleFile
            filename = filenames;
        else
            filename = filenames{i};
        end
        fullFileName = fullfile(pathName, filename);
        
        %load image file
        [statusLoad, handles] = m_OpenImage(hObject, handles, ...
            fullFileName, ...
            nbrHandlesFiles+1, ...
            sourceType);
        
        %if load was successful, add image to list
        if statusLoad
            nbrHandlesFiles = nbrHandlesFiles + 1;
            
            switch sourceType
                case 'data'
                    handles.files.fileNames{nbrHandlesFiles} = filename;
                    handles.files.paths{nbrHandlesFiles} = pathName;
                    %update list box
                    if isempty(get(handles.listboxDataFile,'string'))
                        set(handles.listboxDataFile,'value',1);
                    end
                    set(handles.listboxDataFile,'string', handles.files.fileNames);
                case 'openBeam'
                    handles.obfiles.fileNames{nbrHandlesFiles} = filename;
                    handles.obfiles.paths{nbrHandlesFiles} = pathName;
                    %update list box
                    if isempty(get(handles.listboxOpenBeam,'string'))
                        set(handles.listboxOpenBeam,'value',1);
                    end
                    set(handles.listboxOpenBeam, 'string', handles.obfiles.fileNames);
                case 'darkField'
                    handles.dffiles.fileNames{nbrHandlesFiles} = filename;
                    handles.dffiles.paths{nbrHandlesFiles} = pathName;
                    %update list box
                    if isempty(get(handles.listboxDarkField,'string'))
                        set(handles.listboxDarkField,'value',1)
                    end
                    set(handles.listboxDarkField, 'string', handles.dffiles.fileNames);
            end
            
        else
            
            listOfFilesRejected{index_rejected} = fullFileName; %#ok<AGROW>
            index_rejected = index_rejected + 1;
            
        end
        
        %update progress bar
        handles.myProgress = handles.myProgress.nextStep();
        
    end
    
    switch sourceType
        case 'data'
            %new number of files loaded
            handles.files.nbr = nbrHandlesFiles;
        case 'openBeam'
            handles.obfiles.nbr = nbrHandlesFiles;
        case 'darkField'
            handles.dffiles.nbr = nbrHandlesFiles;
    end
    
    % Update handles structure
    guidata(hObject, handles);
    
    flag = true;
    
    guidata(hObject,handles);
    progressDone(hObject);
    
    if ~isempty(listOfFilesRejected)
        
        msgbox(listOfFilesRejected, 'Error loading some of the files',...
            'error');
        
    end
    
end