function roiLogicalArray = getBAroiLogicalArray(listRoi, arrayWidth, arrayHeight)
    % will return the logical arrays of all the regions selected
    
    nbrRois = numel(listRoi);
    roiLogicalArray = false(arrayHeight, arrayWidth);
    for i=1:nbrRois
        roiLogicalArray = getLogicalArrayFromRectangle(roiLogicalArray, listRoi{i});
    end
    
end

function roiLogicalArray = getLogicalArrayFromRectangle(roiLogicalArray, roi)
    
    expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
    [result] = regexp(roi, expression,'tokens');
    tmpFormatedRoi = result{1};
    
    roiLeft = str2double(tmpFormatedRoi(2));
    roiTop = str2double(tmpFormatedRoi(3));
    roiWidth = str2double(tmpFormatedRoi(4));
    roiHeight = str2double(tmpFormatedRoi(5));
    
    tmpTrue = true(roiHeight, roiWidth);
    roiLogicalArray(roiTop:(roiTop+roiHeight-1), roiLeft:(roiLeft+roiWidth-1)) = tmpTrue;
    
end