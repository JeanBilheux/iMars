function enableSegmentationEditThresholdButton(hObject, button)
    %button is either 'left' or 'right'
    %This function will activate the button selected and disable the
    %other button
    
    handles = guidata(hObject);
    
    switch button
        case 'left'
            enableHandle = handles.togglebuttonSegmentationEditLeftThreshold;
        case 'right'
            enableHandle = handles.togglebuttonSegmentationEditRightThreshold;
    end
    
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
    
    set(handles.togglebuttonSegmentationEditLeftThreshold,'CData', ...
        leftIcon);
    set(handles.togglebuttonSegmentationEditRightThreshold,'CData', ...
        rightIcon);
    
end
