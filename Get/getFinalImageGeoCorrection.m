function finalImage = getFinalImageGeoCorrection(hObject, finalImage)
    
    % get the current image (or set of images)
    if nargin < 2
        finalImage = getCurrentRawImagesSelected(hObject);
    end
    
    handles = guidata(hObject);
    
    % get the value of the selection (points that defined the diameter)
    cylinderX1Y1X2Y2 = handles.cylinderX1Y1X2Y2;
    if ~isempty(cylinderX1Y1X2Y2)
        
        secondCylinderX1Y1X2Y2 = handles.secondCylinderX1Y1X2Y2;
        if isempty(secondCylinderX1Y1X2Y2)
            finalImage = getFinalImageGeoCorrectionFromFullCylinder(hObject, finalImage);
        else
            finalImage = getFinalImageGeoCorrectionFromHollowCylinder(hObject, finalImage);
        end
            
    end
    
end
     
