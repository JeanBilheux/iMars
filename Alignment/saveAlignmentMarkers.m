function saveAlignmentMarkers(hObject)
   
    handles = guidata(hObject);
    path = handles.path;
    
    % ask for location where to save markers file
    default_file = [path,'markers.cfg'];
    [filename, foldername, ~] = uiputfile(default_file, ...
        'Name and location of markers file.');
    
    if isequal(filename, 0) || isequal(foldername, 0)
        return;
    end
    
    fullfilename = [foldername, filename];
    
    % get markers
    markerTable = get(handles.uitableAlignmentMarkers,'data');
    marker_handles.markerTable = markerTable;
    
    save(fullfilename, '-struct', 'marker_handles');
    
end