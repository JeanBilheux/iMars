function initSegmentationGui(hObject)
    % Plot the buttons the first times the tab is reached
    
    handles = guidata(hObject);
    
    if isempty(get(handles.togglebuttonSegmentationExcludeLeft,'CData'))
        
        %load the images in buttons
        exLeftSegmentation_icon = ...
            imread('UtilityFiles/SegmentationLeftActive.jpg','jpg');
        exRightSegmentation_icon = ...
            imread('UtilityFiles/SegmentationRightInactive.jpg','jpg');
        
        set(handles.togglebuttonSegmentationExcludeLeft,'CData', ...
            exLeftSegmentation_icon);
        set(handles.togglebuttonSegmentationExcludeRight,'CData', ...
            exRightSegmentation_icon);
        
    end
    
end