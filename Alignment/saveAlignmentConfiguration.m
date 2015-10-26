function saveAlignmentConfiguration(hObject)
   
    handles = guidata(hObject);
    path = handles.path;
    
    % ask for location where to save config file
    default_file = [path, 'alignment.cfg'];
    [fileName, folderName, ~] = uiputfile(default_file, ...
        'Name and location of configuration file.');
    
    if isequal(fileName,0) || isequal(folderName,0)
        return;
    end
    
    fullFileName = [folderName, fileName];
    
    % get alignment status 
    bigTable = get(handles.uitableAlignment,'data');
    alignmentMarkers = handles.alignmentMarkers;
    
    alignment_handles.bigTable = bigTable;
    alignment_handles.alignmentMarkers = alignmentMarkers;
    
    save(fullFileName, '-struct', 'alignment_handles');
    
end