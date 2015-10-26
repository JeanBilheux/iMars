function refreshAlignmentPreview(hObject)
    % This will recalculate the selected images to preview using the offset
    % and rotation defined
    
    imageToPreview = calculateAlignmentImagesToPreview(hObject);
    if isempty(imageToPreview)
        return;
    end
    
    handles = guidata(hObject);
    axes(handles.axesAlignment);
    colormap(handles.colormap);
    
    imagesc(imageToPreview);
    axis off;
    
    if isempty(handles.alignmentMarkers)
        % if no marker, display grid
        plotGrid(handles, imageToPreview);
    else
        % otherwise, display markers
        plotMarkers(handles, imageToPreview);
    end
    
end