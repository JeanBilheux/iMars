function checkBAcombineBatchModeGUI(hObject)
    % this will make sure the COMBINE button is validated if all the
    % requested infos are there.
    % -> output_folder
    % -> base_file_name
    % -> list of files
    % -> numbr of files to gather
    % -> compatible number of files loaded and to gather
    
    atLeastOneFieldMissing = false;
    
    handles = guidata(hObject);
    
    goodFieldColor = [0.929, 0.929, 0.929];
    missingFieldColor = [1,0,0];
    
    % output folder
    outputfolder = get(handles.editBAcombineBatchPath,'string');
    if strcmp(strtrim(outputfolder),'')
        set(handles.editBAcombineBatchPath,'BackgroundColor',...
            missingFieldColor);
        atLeastOneFieldMissing = true;
    else
        set(handles.editBAcombineBatchPath,'BackgroundColor',...
            goodFieldColor);
    end
    
    % base file name
    baseFileName = get(handles.editBAcombineBatchBaseFileName,'string');
    if strcmp(strtrim(baseFileName),'')
        set(handles.editBAcombineBatchBaseFileName,'BackgroundColor', ...
            missingFieldColor);
        atLeastOneFieldMissing = true;
    else
        set(handles.editBAcombineBatchBaseFileName,'BackgroundColor', ...
            goodFieldColor);
    end
    
    % combine groups of ? files
    combineNumber = get(handles.editBAcombineBatchNbrFiles,'string');
    if strcmp(strtrim(combineNumber),'')
        set(handles.editBAcombineBatchNbrFiles,'BackgroundColor', ...
            missingFieldColor);
        atLeastOneFieldMissing = true;
    else
        set(handles.editBAcombineBatchNbrFiles,'BackgroundColor', ...
            goodFieldColor);
    end
    
    % list box
    listFileName = get(handles.listboxBAcombineBatchListFiles,'string');
    sz = size(listFileName);
    if ((sz(1)==1) && strcmp(listFileName,'List of files to combine here'))
        set(handles.listboxBAcombineBatchListFiles,'BackgroundColor', ...
            missingFieldColor);
        atLeastOneFieldMissing = true;
    else
        set(handles.listboxBAcombineBatchListFiles,'BackgroundColor', ...
            goodFieldColor);
        % make sure the number of files is compatible with the number of
        % files to group together
        if ~strcmp(strtrim(combineNumber),'')
           nbr_combine = str2double(combineNumber);
           nbr_files = numel(listFileName);
           % display error message about not compatible number of files and
           % group number
           if mod(nbr_files, nbr_combine) ~=0
            atLeastOneFieldMissing = true;
            warningStatus = 'on';
           else
               warningStatus = 'off';
           end
           set(handles.textBAcombineWarning,'visible',warningStatus);
        end    
    end
    
    if atLeastOneFieldMissing
        set(handles.pushbuttonBAcombineBatchCombine,'enable','off');
    else
        set(handles.pushbuttonBAcombineBatchCombine,'enable','on');
    end
    
end