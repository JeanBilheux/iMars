function m_toggleBATabButton(hObject, indexSelected)
    %toggle the Basic Analysis tab button (Profile, ROI)
    
    handles = guidata(hObject);
    
    %array of toggle buttons
    toggleArray = [handles.togglebuttonBAProfile, ...
        handles.togglebuttonBARoi, ...
        handles.togglebuttonBAvoids, ...
        handles.togglebuttonBAgeoCorrection, ...
        handles.togglebuttonBACombine];
    
    %array of uipanel
    toggleUIpanel = [handles.uipanelBAProfile, ...
        handles.uipanelBARoi, ...
        handles.uipanelBAvoids, ...
        handles.uipanelBAgeoCorrection, ...
        handles.uipanelBACombine];
    
    %first, hide all the panels
    for i=1:numel(toggleArray)
        set(toggleUIpanel(i), 'visible', 'off');
    end
    
    %init array
    uipanelActivation = {'off','off','off','off','off'};
    uipanelActivation{indexSelected} = 'on';
    uibuttonActivation = [0 0 0 0 0];
    uibuttonActivation(indexSelected) = 1;
    
    for i=1:numel(toggleArray)
        set(toggleArray(i), 'value', uibuttonActivation(i));
        set(toggleUIpanel(i), 'visible', uipanelActivation{i});
    end
    
end