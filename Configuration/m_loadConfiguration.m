function m_loadConfiguration(hObject)
    %load the configuration
    
    handles = guidata(hObject);
    cfgPath = handles.path;
    
    [filename, pathName, ~] = uigetfile('*.cfg', ...
        'Select Configuration file', ...
        cfgPath);
    
    if pathName %1 file has been selected
        fullFileName = [pathName filename];
        loadHandles(hObject, fullFileName);
    end
    
end