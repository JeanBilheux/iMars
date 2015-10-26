function m_updateManualBAroiSelection(hObject)
    % will update the Basic Analysis ROI tab input fields
    % with the field currently selected by the list box
    
    updateBAroiInputGUI(hObject);
    
    handles = guidata(hObject);
    
    %get full list of roi
    [listRoi] = get(handles.listboxBAroi,'string');
    
    if isempty(listRoi)
        return
    end
    
    %get full list of roi selected
    listRoiRowSelected = get(handles.listboxBAroi,'value');
    if listRoiRowSelected == 0
        return
    end
    drawnow
    listRoiSelected = listRoi(listRoiRowSelected);
    nbrRoi = numel(listRoiSelected);
    
    %if nothing selected or more than 1 field
    if isempty(listRoi) || nbrRoi > 1 %reset contains
        
        left = '';
        top = '';
        width = '';
        height = '';
        
    else
        expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
        tmpRoi = listRoiSelected{1};
        [result] = regexp(tmpRoi, expression,'tokens');
        tmpFormatedRoi = result{1};
        
        left = str2double(tmpFormatedRoi(2));
        top = str2double(tmpFormatedRoi(3));
        width = str2double(tmpFormatedRoi(4));
        height = str2double(tmpFormatedRoi(5));
        
    end
    
    set(handles.baRoiInputLeft,'string',left);
    set(handles.baRoiInputTop,'string',top);
    set(handles.baRoiInputWidth,'string',width);
    set(handles.baRoiInputHeight,'string',height);
    
end
