function std = calculateStd(arrayOfImageRoisMean, globalMean)
    
    nbrPoint = numel(arrayOfImageRoisMean);
    tmpSum = 0;
    for i=1:nbrPoint
        tmpSum = tmpSum + (arrayOfImageRoisMean(i)-globalMean)^2;
    end
    
    std = sqrt(tmpSum / nbrPoint);
    
end
