function removeCurrentSelectedBAroi(hObject)
    % Remove the selected row of the BA roi list box
    
    handles = guidata(hObject);
    
    [listRoi] = get(handles.listboxBAroi,'string');
    if isempty(listRoi)
        return
    end
    
    rowIndex = get(handles.listboxBAroi,'value');
    
    %if we want to remove everything
    if length(rowIndex) == length(listRoi)
        set(handles.listboxBAroi,'string',[]);
        set(handles.axesBAroi,'visible', 'off');
        lastChildren = get(handles.axesBAroi,'children');
        set(lastChildren(:),'visible','off');
    return
    end
    
    set(handles.listboxBAroi,'value',1);
    listRoi(rowIndex) = [];
    set(handles.listboxBAroi,'string',listRoi);
    
end