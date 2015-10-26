function removeCurrentSelectedProfile(hObject)
    % This function will remove the selected profile
    
    handles = guidata(hObject);
    
    [listProfile] = get(handles.listboxBAprofile,'string');
    if isempty(listProfile)
        return
    end
    
    rowIndex = get(handles.listboxBAprofile,'value');
    
    %in case we removed everything
    if length(rowIndex) == length(listProfile)
        set(handles.listboxBAprofile,'string',[]);
        set(handles.axesBAprofile,'visible','off')
        
        listChildren = get(handles.axesBAprofile,'children');
        set(listChildren(:),'visible','off');
        
        return
    end
    
    set(handles.listboxBAprofile,'value',1);
    listProfile(rowIndex) = [];
    set(handles.listboxBAprofile,'string',listProfile);
    
end
