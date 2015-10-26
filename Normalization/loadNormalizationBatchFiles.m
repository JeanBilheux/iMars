function loadNormalizationBatchFiles(hObject)
    % will ask the user to select the files to load
    
    handles = guidata(hObject);
    
    path = handles.path;
    
    [filenames, pathname, ~] = uigetfile({'*.fits','FITS file (*.fits)'; ...
        '*.tif;*.tiff', 'TIFF files (*.tif, *.tiff)'}, ...
        'Select Data Files to Normalize', ...
        'Multiselect', 'on', ...
        path);
    
    if pathname % at least one file selected
        
        % replace current list with new list
        set(handles.listboxNormalizationBatchListOfFiles,'string', filenames);
        set(handles.listboxNormalizationBatchListOfFiles,'visible','on');
        handles.inputPathnameOfBatchNormalization = pathname;
        guidata(hObject, handles);
        
    end
    
end