function m_displayImage(hObject, sourceType)
    % Display the image that is currently selected in the list
    % sourceType: ['data','openBeam','darkField']

    m_recalculateImageToDisplay(hObject, sourceType);
    m_refreshPreviewRoi(hObject);
    
end


