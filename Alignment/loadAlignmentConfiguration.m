function loadAlignmentConfiguration(hObject)
    
    handles = guidata(hObject);
    
    path = handles.path;
    defaultFilename = [path, 'alignment.cfg'];
    [filename, pathname, ~] = uigetfile({'*.cfg'}, ...
        'Select config file', ...
        defaultFilename);
    
    if isequal(filename,0)
        return;
    end
    
    fullFilename = [pathname, filename];
    
    alignmentHandles = load(fullFilename,'-mat');
    
    currentBigTable = get(handles.uitableAlignment,'data');
    szBigTable = size(currentBigTable);
    nbrRow = szBigTable(1);
    
    loadedBigTable = alignmentHandles.bigTable;
    szLoadedBigTable = size(loadedBigTable);
    nbrRowLoaded = szLoadedBigTable(1);
    
    if nbrRow ~= nbrRowLoaded
        message = 'Size of config loaded and current table do not match!';
        statusBarMessage(hObject, message, 5, true);
    else
        
        for i=1:nbrRow
            currentBigTable(i,2:4) = loadedBigTable(i,2:4);
        end
        
        set(handles.uitableAlignment,'data',currentBigTable);
        
    end
    
    % display markers defined
    alignmentMarkers = alignmentHandles.alignmentMarkers;
    handles.alignmentMarkers = alignmentMarkers;
    guidata(hObject, handles);
    refreshAlignmentPreview(hObject)
    
end

