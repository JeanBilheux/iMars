function logicalArray = getLogicalArrayOfEllipse(roiLogicalArray, ...
        roiSelection)
    % return the logical array of all the pixels on the selection
    % Input
    %   roiLogicalArray : current master logical array of all the ROI
    %                     already processed
    %   roiSelection : { x, y, width, height }
    
    roiX = roiSelection(1);
    roiY = roiSelection(2);
    roiWidth = roiSelection(3);
    roiHeight = roiSelection(4);
    
    x0 = roiWidth/2;
    y0 = roiHeight/2;
    
    equationEllipse = @(x,y) ((x-x0)/(roiWidth/2))^2 + ((y-y0)/(roiHeight/2))^2;
    
    tmpTrue = false(roiHeight, roiWidth);
    
    for x=1:roiWidth
        for y=1:roiHeight
            value = equationEllipse(int16(x),int16(y));
            if value == 1
                tmpTrue(y,x) = 1;
            end
        end
    end
    
    roiLogicalArray(roiY:(roiY+roiHeight-1), roiX:(roiX+roiWidth-1)) = tmpTrue;
    logicalArray = roiLogicalArray;
    
end