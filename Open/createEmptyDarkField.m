function createEmptyDarkField(hObject)
    
    handles = guidata(hObject);
    
    images = handles.files.images;
    first_image = images{1};
    
    sz = size(first_image);
    
    width = sz(1);
    height = sz(2);
    
    blank_dark_field = zeros(width, height);
    blank_dark_field(1,1) = 1;
    
    output_file_name = 'blank_dark_field';
    
    nbrHandlesFiles = handles.dffiles.nbr;
    nbrHandlesFiles = nbrHandlesFiles + 1;
    
    handles.dffiles.fileNames{nbrHandlesFiles} = output_file_name;
    handles.dffiles.paths{nbrHandlesFiles} = '';
    if isempty(get(handles.listboxDarkField,'string'))
        set(handles.listboxDarkField,'value',1)
    end
    set(handles.listboxDarkField, 'string', handles.dffiles.fileNames);
    
    handles.dffiles.globalMaxIntensity = 0;
    handles.dffiles.images{nbrHandlesFiles} = double(blank_dark_field);
    handles.dffiles.nbr = nbrHandlesFiles;
   
    guidata(hObject, handles);
    
end