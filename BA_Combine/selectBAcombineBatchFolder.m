function selectBAcombineBatchFolder(hObject)
    % select the folder that will be used to create the combine files
    
    handles = guidata(hObject);
    
    path = handles.path;
    
    folder_name = uigetdir(path, 'Select output folder');
    
    % no folder selected
    if folder_name == 0
        return;
    end
    
    handles.path = folder_name;
    guidata(hObject, handles);
    
    set(handles.editBAcombineBatchPath,'string',folder_name);
    
end