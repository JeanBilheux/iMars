function flag = m_OpenFile(hObject, sourceType)
    % reached by the open data, open beam and dark field
    % menu buttons
    % sourceType: ['data','openBeam','darkField']
    
    % recover handles
    handles = guidata(hObject);
    
    flag = false; % by default, nothing loaded
    
    if handles.path
        path = handles.path;
    else
        path = handles.defaultPath;
    end
    
    switch sourceType
        case 'data'
            getfileMessage = 'Select Data File(s)';
            nbrHandlesFiles = handles.files.nbr;
        case 'openBeam'
            getfileMessage = 'Select Open Beam File(s)';
            nbrHandlesFiles = handles.obfiles.nbr;
        case 'darkField'
            getfileMessage = 'Select Dark Field File(s)';
            nbrHandlesFiles = handles.dffiles.nbr;
    end
    
    [filenames, pathName, ~] = uigetfile({'*.tif;*.tiff', 'TIFF files (*.tif, *.tiff)'; ...
        '*.fits;*.fit', 'FITS file (*.fits, *.fit)'; ...
        '*', 'ASCII files'}, ...
        getfileMessage, ...
        'MultiSelect', 'on', ...
        path);
    
    %did we select only 1 file
    bSingleFile = isa(filenames,'char');
    
    if pathName %at least one file selected
        
        flag = openListOfFiles(hObject, filenames, pathName, ...
            nbrHandlesFiles, bSingleFile, sourceType);
        
    end
    
end

