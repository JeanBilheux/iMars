function enableSegmentationExcludeButton(hObject, button)
    %button is either 'left' or 'right'
    %This function will activate the button selected and disable the
    %other button
    
    handles = guidata(hObject);
    
    handles.isExcludedLeftButtonSelected = ...
        get(handles.togglebuttonSegmentationExcludeLeft,'value');
    
    switch button
        case 'left'
            leftButtonFile = 'UtilityFiles/SegmentationLeftActive.jpg';
            rightButtonFile = 'UtilityFiles/SegmentationRightInactive.jpg';
        case 'right'
            leftButtonFile = 'UtilityFiles/SegmentationLeftInactive.jpg';
            rightButtonFile = 'UtilityFiles/SegmentationRightActive.jpg';
    end
    
    leftIcon = imread(leftButtonFile,'jpg');
    rightIcon = imread(rightButtonFile,'jpg');
    
    set(handles.togglebuttonSegmentationExcludeLeft,'CData', ...
        leftIcon);
    set(handles.togglebuttonSegmentationExcludeRight,'CData', ...
        rightIcon);

    handles.liveThresholdType = button;

    guidata(hObject, handles);
    
end
