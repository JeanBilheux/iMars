function m_refreshPreviewImage(hObject)
    %just refresh the Preview Image
    
    handles = guidata(hObject);
    
    finalImage = handles.currentImagePreviewed;
    axes(handles.axesPreview);
    
    minIntensity = handles.files.minIntensity;
    maxIntensity = handles.files.maxIntensity;
    
    colormap(handles.colormap);
    handles.preview.imshow = imagesc(finalImage, [minIntensity, ...
        maxIntensity]);
    
    axis on;
    handles.preview.xlabel = xlabel('Pixels');
    set(handles.axesPreview,'XAxisLocation','top');
    handles.preview.colorbar = colorbar;
    guidata(hObject, handles);
    
end