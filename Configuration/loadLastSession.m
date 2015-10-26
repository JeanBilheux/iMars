function loadLastSession(hObject)
    
    handles = guidata(hObject);
    button = questdlg('Do you want to restart previous session?', ...
        'Restore previous Session?', ...
        'Yes','No','Yes');
    
    switch button
        case 'Yes'
            sessionFile = handles.sessionFile;
            %try
                loadHandles(hObject, sessionFile);
            %catch errorMessage
            %    message = sprintf('Error loading configuration : %s -> %s', ...
             %       errorMessage.identifier, errorMessage.message);
             %   statusBarMessage(hObject, message, 5, true);
             %   set(handles.loadSessionMessageTag,'visible','off');
             %   drawnow
            %end
        case 'No'
            return
    end
    
end