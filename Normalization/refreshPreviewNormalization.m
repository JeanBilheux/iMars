function refreshPreviewNormalization(hObject)
    %refresh the preview with ROI selected in the normalization tab
    
    handles = guidata(hObject);
    
    roiRectangleSelection = handles.roiRectangleSelection;
    isRoiRectangleEllipse = handles.isRoiRectangleEllipse;
    
    nbrRois = size(roiRectangleSelection,2);
    if nbrRois > 0
        for i=1:nbrRois
            if isRoiRectangleEllipse{i}
                rectangle('position',roiRectangleSelection{i}, ...
                    'lineWidth',1, ...
                    'curvature',[1,1],...
                    'edgeColor','red');
            else
                rectangle('position',roiRectangleSelection{i}, ...
                    'lineWidth',1, ...
                    'edgeColor','blue');
            end
        end
    end
end
