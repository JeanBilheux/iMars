function saveSession(hObject)
    %This function will automatically save the entire session
    %to allow the user to restart the application in the same state
    %as he left it.
    
    handles = guidata(hObject);
    sessionFile = handles.sessionFile; 
    createConfigurationFile(hObject, sessionFile, false);
    
end
