function selectNormalizationBatchOutputFolder(hObject)
   % will allow user to select output folder
   
    handles = guidata(hObject);
    
    path = handles.path;
    
    folder_name = uigetdir(path, 'Select output folder');
    
    % no folder selected
    if folder_name == 0
        return;
    end
    
    handles.path = folder_name;
    guidata(hObject, handles);
    
    set(handles.editNormalizationBatchFolder,'string',folder_name);
    
end