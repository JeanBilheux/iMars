function updateBAprofileInputGUI(hObject)
    %this update the Input UIpanel of the BA profile tab
    
    handles = guidata(hObject);
    
    listProfile = get(handles.listboxBAprofile,'string');
    listProfileRowSelected = get(handles.listboxBAprofile,'value');
    if (isempty(listProfile)) || (numel(listProfileRowSelected) > 1)
        statusEditOnOff = 'off';
    else
        statusEditOnOff = 'on';
    end

    childHandles = get(handles.uipanelBAprofileManualInput,'children');
    set(childHandles(:),'enable',statusEditOnOff);
    
end