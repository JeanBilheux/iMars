function updateBAroiInputGUI(hObject)

    %this update the Input UIpanel of the BA profile tab
    
    handles = guidata(hObject);
    
    listRoi = get(handles.listboxBAroi,'string');
    listRoiRowSelected = get(handles.listboxBAroi,'value');
    if (isempty(listRoi)) || (numel(listRoiRowSelected) > 1)
        statusEditOnOff = 'off';
    else
        statusEditOnOff = 'on';
    end

    childHandles = get(handles.uipanelBAroiManualInput,'children');
    set(childHandles(:),'enable',statusEditOnOff);
    
end