function closingSessionMessage(hObject)
    
    handles = guidata(hObject);
    button = questdlg('Do you want to save your session?', ...
        'Save Session?', ...
        'Yes','No','Yes');
    
    switch button
        case 'Yes'
            sessionFile = handles.sessionFile;
            try
                set(handles.saveSessionMessageTag,'visible','on');
                drawnow
                createConfigurationFile(hObject, sessionFile, false);
            catch errorMessage
                message = sprintf('Error saving configuration : %s -> %s', ...
                    errorMessage.identifier, errorMessage.message);
                statusBarMessage(hObject, message, 0, true);
            end
        case 'No'
            return
    end
    
end