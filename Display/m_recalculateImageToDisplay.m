function m_recalculateImageToDisplay(hObject, sourceType)
    
    handles = guidata(hObject);
    colormap(handles.colormap);
    
    %get the file(s) currently selected
    switch sourceType
        case 'data'
            activeListBox = handles.listboxDataFile;
            fileHandles = handles.files;
        case 'openBeam'
            activeListBox = handles.listboxOpenBeam;
            fileHandles = handles.obfiles;
        case 'darkField'
            activeListBox = handles.listboxDarkField;
            fileHandles = handles.dffiles;
    end
    selection = get(activeListBox,'value');
    sz_selection = (size(selection));
    nbr_selection = sz_selection(2);
    
    dim1 = size(fileHandles.images,1);
    if dim1 == 0
        return
    end
    
    try
        tmp_image = fileHandles.images{selection(1)};
        %         fprintf('-> max(tmp_image)=%d\n', max(tmp_image(:)));
        if nbr_selection > 1
            for i=2:nbr_selection
                tmp_image = tmp_image + fileHandles.images{selection(i)};
            end
            tmp_image = tmp_image / nbr_selection;
        end
    catch err
        str = sprintf('Message: %50s', err.identifier);
        errordlg(str, 'Size of images do not match !');
        set(gcf,'pointer','arrow');
        return
    end
    
    % get type of display requested
    guidata(hObject,handles);
    finalImage = getImageForPreview(hObject, tmp_image, sourceType);
    handles = guidata(hObject);
    
    axes(handles.axesPreview);
    
    switch sourceType
        case 'data'
            minIntensity = handles.files.minIntensity;
            maxIntensity = handles.files.maxIntensity;
        case 'openBeam'
            minIntensity = handles.obfiles.minIntensity;
            maxIntensity = handles.obfiles.maxIntensity;
        case 'darkField'
            minIntensity = handles.dffiles.minIntensity;
            maxIntensity = handles.dffiles.maxIntensity;
    end
    
    try
        colormap(handles.colormap);
        handles.preview.imshow = imagesc(finalImage, [minIntensity, ...
            maxIntensity]);
        
        axis on;
        handles.preview.xlabel = xlabel('Pixels');
        set(handles.axesPreview,'XAxisLocation','top');
        handles.preview.ylabel = ylabel('Pixels');
        handles.preview.colorbar = colorbar;
        
        handles.activeListbox = sourceType;
        handles.currentImagePreviewed = finalImage;
        handles.files.minIntensity = minIntensity;
        handles.files.maxIntensity = maxIntensity;
        guidata(hObject, handles);
    catch err
        str = sprintf('Message: %50s',err.identifier);
        errordlg(str, 'Unable to display the data!');
        set(gcf,'pointer','arrow');
    end
    
end