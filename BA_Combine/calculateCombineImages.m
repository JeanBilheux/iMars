function calculateCombineImages(hObject, type)
    % type is 'add' or 'median'
    
    handles = guidata(hObject);
    
    selection = get(handles.listboxDataFile,'value');
    
    images = handles.files.images;
    imagesSelected = images(selection);
    imagesSelected = goToTransmission(imagesSelected);
    
    signalSelection = handles.baCombineSignalSelection;
    backgroundSelection = handles.baCombineBackgroundSelection;
    
    finalImage = [];
    switch type
        case 'add'
            [finalImage, nbrImages] = addImages(imagesSelected);
            finalImage = finalImage/nbrImages;
        case 'median'
            finalImage = medianImages(imagesSelected, ...
                signalSelection, ...
                backgroundSelection);
        case 'sum'
            [finalImage, ~] = addImages(imagesSelected);
    end
    
    % calculate the signal background ratio
    signal = getSignal(finalImage, signalSelection);
    background = getSignal(finalImage, backgroundSelection);
    
    sbr = signal/background;
    sbr = sprintf('%.2f:1', sbr);
    switch type
        case 'add'
            set(handles.textBAaddSBRvalue, 'string', sbr);
        case 'median'
            set(handles.textBAmedianSBRvalue, 'string', sbr);
        case 'sum'
            set(handles.textBAsumSBRvalue, 'string', sbr);
    end
    
    % calculate the signal standard deviation
    [ssd, ~] = getStandardDeviation(finalImage, signalSelection);
    ssd = sprintf('%2.f', ssd);
    switch type
        case 'add'
            set(handles.textBAaddSSDvalue, 'string', ssd);
        case 'median'
            set(handles.textBAmedianSSDvalue, 'string', ssd);
        case 'sum'
            set(handles.textBAsumSSDvalue, 'string', ssd);
    end
    
    % calculate the signal noise ratio
    [bsd, backMean] = getStandardDeviation(finalImage, backgroundSelection);
    contrast = getContrast(finalImage, signalSelection, backMean);
    snr = (contrast/bsd)*10000;
    snr = sprintf('%.2f:1', snr);
    bsd = sprintf('%.2f', bsd);
    switch type
        case 'add'
            set(handles.textBAaddSNRvalue, 'string', snr);
            set(handles.textBAaddBSDvalue, 'string', bsd);
        case 'median'
            set(handles.textBAmedianSNRvalue, 'string', snr);
            set(handles.textBAmedianBSDvalue, 'string', bsd);
        case 'sum'
            set(handles.textBAsumSNRvalue, 'string', snr);
            set(handles.textBAsumBSDvalue, 'string', snr);
    end
    
end

function contrast = getContrast(finalImage, signalSelection, backMean)
    % will calculate the
    % contrast = mean(signal selected) / mean(background selected)
    
    sz = size(signalSelection);
    nbrSignalSelection = sz(2);
    
    % calculate the mean
    totalSum = 0;
    totalNbrPx = 0;
    for i=1:nbrSignalSelection
        
        tmpSignalSelection = num2cell(signalSelection{i});
        [tmpx,tmpy,tmpw,tmph] = tmpSignalSelection{:};
        x=fix(tmpx);
        y=fix(tmpy);
        w=fix(tmpw);
        h=fix(tmph);
        tmpRegion = finalImage(y:y+h,x:x+w);
        totalSum = totalSum + sum(tmpRegion(:));
        totalNbrPx = totalNbrPx + (w+1)*(h+1);
        
    end
    signalMean = totalSum / totalNbrPx;
    
    contrast = (backMean / signalMean);
    
end

function imagesSelected = goToTransmission(imagesSelected)
    % The images are currently in attenuation mode, to make sure
    % the algorithm work, we need to be in transmission
    sz = size(imagesSelected);
    nbrImages = sz(2);
    %     finalImage = zeros(size(imagesSelected{1}));
    for i=1:nbrImages
        tmpImage = imagesSelected{i};
        maxValue = max(tmpImage(:));
        newTmpImage = maxValue - tmpImage;
        imagesSelected{i} = newTmpImage;
    end
    
end

function [sd, meanValue] = getStandardDeviation(finalImage, selection)
    % Will calculate the standard deviation of all the pixels selected
    % in the background
    
    sz = size(selection);
    nbrSelection = sz(2);
    
    % calculate the mean
    totalSum = 0;
    totalNbrPx = 0;
    for i=1:nbrSelection
        
        tmpSelection = num2cell(selection{i});
        [tmpx,tmpy,tmpw,tmph] = tmpSelection{:};
        x=fix(tmpx);
        y=fix(tmpy);
        w=fix(tmpw);
        h=fix(tmph);
        tmpRegion = finalImage(y:y+h,x:x+w);
        totalSum = totalSum + sum(tmpRegion(:));
        totalNbrPx = totalNbrPx + (w+1)*(h+1);
        
    end
    meanValue = totalSum / totalNbrPx;
    
    % let's calculate the variance
    numVariance = 0;
    for i=1:nbrSelection
        
        tmpSelection = num2cell(selection{i});
        [tmpx,tmpy,tmpw,tmph] = tmpSelection{:};
        x=fix(tmpx);
        y=fix(tmpy);
        w=fix(tmpw);
        h=fix(tmph);
        tmpRegion = finalImage(y:y+h,x:x+w);
        ValueMinusMean = power((tmpRegion - meanValue),2);
        numVariance = numVariance + sum(ValueMinusMean(:));
        
    end
    sd = sqrt(numVariance / totalNbrPx);
    
end

function signal = getSignal(finalImage, signalSelection)
    % signal = total counts of all regions
    
    sz = size(signalSelection);
    nbrSignalSelection = sz(2);
    
    totalSum = 0;
    totalNbrPx = 0;
    for i=1:nbrSignalSelection
        
        tmpSignalSelection = num2cell(signalSelection{i});
        [tmpx,tmpy,tmpw,tmph] = tmpSignalSelection{:};
        x=fix(tmpx);
        y=fix(tmpy);
        w=fix(tmpw);
        h=fix(tmph);
        tmpRegion = finalImage(y:y+h,x:x+w);
        totalSum = totalSum + sum(tmpRegion(:));
        totalNbrPx = totalNbrPx + (w+1)*(h+1);
        
    end
    
    %     signal = totalSum / sqrt(totalNbrPx);
    signal = totalSum / (totalNbrPx);
    
end

function [finalImage, nbrImages] = addImages(imagesSelected)
    % add the images
    
    sz = size(imagesSelected);
    nbrImages = sz(2);
    finalImage = zeros(size(imagesSelected{1}));
    for i=1:nbrImages
        finalImage = finalImage + imagesSelected{i};
    end
    %finalImage = finalImage / nbrImages;
    
end

function finalImage = medianImages(imagesSelected, ...
        signalSelection, ...
        backgroundSelection)
    % will calculate the median image of only the signal and background
    % regions
    
    %     finalImage = zeros(size(imagesSelected{1}));
    nbrImagesTmp = size(imagesSelected);
    nbrImages = nbrImagesTmp(2);
    [hh,ww] = size(imagesSelected{1});
    bigArray = zeros(nbrImages, hh, ww);
    
    sz = size(signalSelection);
    nbrSignalSelection = sz(2);
    for i=1:nbrSignalSelection
        
        tmpSignalSelection = num2cell(signalSelection{i});
        [tmpx,tmpy,tmpw,tmph] = tmpSignalSelection{:};
        x=fix(tmpx);
        y=fix(tmpy);
        w=fix(tmpw);
        h=fix(tmph);
        
        for j=1:nbrImages
            tmpImageSelected = imagesSelected{j};
            bigArray(j,y:y+h,x:x+w) = tmpImageSelected(y:y+h,x:x+w);
        end
        
    end
    
    sz = size(backgroundSelection);
    nbrBackgroundSelection = sz(2);
    for i=1:nbrBackgroundSelection
        
        tmpBackgroundSelection = num2cell(backgroundSelection{i});
        [tmpx,tmpy,tmpw,tmph] = tmpBackgroundSelection{:};
        x=fix(tmpx);
        y=fix(tmpy);
        w=fix(tmpw);
        h=fix(tmph);
        
        for j=1:nbrImages
            tmpImageSelected = imagesSelected{j};
            bigArray(j,y:y+h,x:x+w) = tmpImageSelected(y:y+h,x:x+w);
        end
        
    end
    
    sortedBigArray = sort(bigArray,1);
    medianIndex = fix(nbrImages/2);
    finalImage = squeeze(sortedBigArray(medianIndex,:,:));
    
end

