function [roiLogicalArray, isWithRoi] = getRoiLogicalArray(hObject)
    %This function will retrieve the ROI defined and will
    %translate those into a logical array of all the pixels
    %cover by the ROIs
    
    handles = guidata(hObject);
    
    roiRectangleSelection = handles.roiRectangleSelection;
    isRoiRectangleEllipse = handles.isRoiRectangleEllipse;
    
    nbrROIs = numel(roiRectangleSelection);
    
    %size of logical array
    imagesArray = handles.files.images;
    image1 = imagesArray{1};
    [height, width] = size(image1);
    
    if isempty(roiRectangleSelection)
        roiLogicalArray = [];
        isWithRoi = false;
        return
    end
    
    roiLogicalArray = false(height, width);
    for i=1:nbrROIs
        
        if isRoiRectangleEllipse{i}
            tmpLogicalArray = getLogicalArrayFromEllipse(roiLogicalArray, ...
                roiRectangleSelection{i});
        else
            tmpLogicalArray = getLogicalArrayFromRectangle(roiLogicalArray, ...
                roiRectangleSelection{i});
        end
        
        roiLogicalArray = tmpLogicalArray;
        
    end
    
    isWithRoi = true;
    
end
