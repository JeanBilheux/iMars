function averageRoiArray = getAverageOfRoi(averageTotalArray, roiLogicalArray)
    %this function will calculate the mean value of the ROI region of
    %input array
    
    RoiDataArray = averageTotalArray(roiLogicalArray);
    averageRoiArray = mean(RoiDataArray);
    
end

