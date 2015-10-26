function iMars_mouseAction(hObject,mouseAction)
    % Reaches when mouse moves over main figure
    % mouseAction is either 'mouseMove','mouseUp','mouseDown'
    topTabSelected = getTopTabSelected(hObject);
    
    %we are only interested by the mouse down action for now
    if ~strcmp(mouseAction,'mouseDown')
        return
    end
    
    switch topTabSelected
        case 'Segmentation'
            segmentationTab_mouseAction(hObject, mouseAction);

        otherwise
    end
    
end