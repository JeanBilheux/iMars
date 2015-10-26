function m_activateNormalizationWidgets(handles, status)
    % activate the various widgets if needed
    
    %activate open beam widgets only if there is at least 1 open beam file
    openBeam = get(handles.listboxOpenBeam,'string');
    if ~isempty(openBeam)
        openBeamStatus = 'on';
    else
        openBeamStatus = 'off';
    end
    set(handles.textOpenBeam,'enable',openBeamStatus);
    set(handles.listboxOpenBeam,'enable',openBeamStatus);
    
    %display delete button
    delete_icon = imread('UtilityFiles/delete.jpg','jpg');
    set(handles.pushbuttonOBdelete,'CData',delete_icon, ...
        'visible',openBeamStatus);
    
    %activate dark field widgets only if there is at least 1 dark field file
    darkField = get(handles.listboxDarkField, 'string');
    if ~isempty(darkField)
        darkFieldStatus = 'on';
    else
        darkFieldStatus = 'off';
    end
    set(handles.textDarkField,'enable',darkFieldStatus);
    set(handles.listboxDarkField,'enable',darkFieldStatus);
    
    m_activateAllWidgets(handles.uipanelROI, status);
    
    %display delete button
    delete_icon = imread('UtilityFiles/delete.jpg','jpg');
    set(handles.pushbuttonDFdelete,'CData',delete_icon, ...
        'visible',darkFieldStatus);
   
    %validate or not the normalize button
    if strcmp(openBeamStatus,'on') && ...
            strcmp(darkFieldStatus,'on')
        normalizeButtonStatus = 'on';
    else
        normalizeButtonStatus = 'off';
    end
    set(handles.pushbuttonNormalize,'enable',normalizeButtonStatus);
    
end