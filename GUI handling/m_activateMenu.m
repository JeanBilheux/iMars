function m_activateMenu(hObject)
    
    handles = guidata(hObject);
    
    if nargin == 2
        status = forceStatus;
    else
        if handles.files.nbr > 0
            status = 'on';
        else
            status = 'off';
        end
    end 
    
    set(handles.colormapMenu,'enable',status);
    set(handles.editMenu,'enable',status);
    set(handles.menuEmptyDarkField,'enable',status);
    
end