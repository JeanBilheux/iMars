function loadAlignmentMarkers(hObject)
   
   handles = guidata(hObject);
   
   path = handles.path;
   defaultFilename = [path, 'markers.cfg'];
   
   [filename, foldername, ~] = uigetfile({'*.cfg'}, ...
       'Select Marker file', ...
       defaultFilename);
   
   if isequal(filename,0)
       return;
   end
   
   fullfilename = [foldername, filename];
   
   try
        marker_handles = load(fullfilename,'-mat');
       set(handles.uitableAlignmentMarkers,'data',marker_handles.markerTable);
   catch
       message = ['Failed loading Marker file: ', fullfilename];
       statusBarMessage(hObject, message, 10, true)
   end
    
end