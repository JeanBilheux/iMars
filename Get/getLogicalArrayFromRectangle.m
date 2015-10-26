function logicalArray = getLogicalArrayFromRectangle(roiLogicalArray, ...
        roiSelection)
    % return the logical array of all the pixels within the selection
    % Input
    %   roiLogicalArray : current master logical array of all the ROI
    %                     already processed
    %   roiSelection : { x, y, width, height }
    
    roiX = int16(roiSelection(1));
    roiY = int16(roiSelection(2));
    roiHeight = int16(roiSelection(4));
    roiWidth = int16(roiSelection(3));
    
    tmpTrue = true(roiHeight, roiWidth);
    roiLogicalArray(roiY:(roiY+roiHeight-1), roiX:(roiX+roiWidth-1)) = tmpTrue;
    
    logicalArray = roiLogicalArray;
    
end