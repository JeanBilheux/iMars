function m_saveConfiguration(hObject)
    %Save the configuration
    
    handles = guidata(hObject);
    
    cfgPath = handles.path;
    
    [filename, pathName, ~] = uiputfile('*.cfg', ...
        'Select Configuration File', ...
        cfgPath);
    
    if pathName %1 file has been selected
        
        fullFileName = [pathName filename];
        createConfigurationFile(hObject, fullFileName, true);
        
    end
    
end
