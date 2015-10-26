function loadBAcombineBatchFiles(hObject)
    % will ask the user to select the files to load
    
    handles = guidata(hObject);
    
    path = handles.path;
    
    [filenames, pathname, ~] = uigetfile({'*.fits','FITS file (*.fits)'; ...
        '*.tif;*.tiff', 'TIFF files (*.tif, *.tiff)'}, ...
        'Select Data Files to Combine', ...
        'Multiselect', 'on', ...
        path);
    
    if pathname % at least one file selected
       
        % replace current list with new list
        set(handles.listboxBAcombineBatchListFiles,'string', filenames);
        set(handles.listboxBAcombineBatchListFiles,'visible','on');
        handles.inputPathnameOfBAcombine = pathname;
        guidata(hObject, handles);
        
    end

end