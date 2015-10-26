function updateBAvoidsMaskHistogram(hObject)
    % this will refresh the part two of the voids tab
    % and will refresh the histogram of the mask region selected
    
    handles = guidata(hObject);
    
    image = handles.BAvoidsWorkingImage;

    maskMinValue = str2double(get(handles.editMaskMinValue,'string'));
    maskMaxValue = str2double(get(handles.editMaskMaxValue,'string'));
    
    if ~isnumeric(maskMinValue)
        maskMinValue = 0;
    else
        maskMinValue = double(maskMinValue);
    end
    
    if ~isnumeric(maskMaxValue)
        maskMaxValue = 1;
    else
        maskMaxValue = double(maskMaxValue);
    end
    
    % make sure the range is right
    if maskMinValue < 0
        maskMinValue = 0;
    end
    
    if maskMaxValue > 1
        maskMaxValue = 1;
    end
    
    if maskMinValue > maskMaxValue
        tmp = maskMaxValue;
        maskMaxValue = maskMinValue;
        maskMinValue = tmp;
    end
    
    set(handles.editMaskMinValue,'string',num2str(maskMinValue));
    set(handles.editMaskMaxValue,'string',num2str(maskMaxValue));
    
    % also make sure that the Voids threshold value is >= mask min value
    voidsValue = str2double(get(handles.editBAvoidsValue,'string'));
    if ~isnumeric(voidsValue)
        voidsValue = maskMinValue;
    elseif voidsValue < maskMinValue
        voidsValue = maskMinValue;
    end
    set(handles.editBAvoidsValue,'string',num2str(voidsValue));
       
    % reject data outside the range specified
    newDataRangeToReject = (image < maskMinValue) | (image > maskMaxValue);
    newImage = image;
    newImage(newDataRangeToReject) = 0;
    
    [counts, x] = imhist(newImage);
    axes(handles.axesBAvoidsHistoMask);
    plot(x,counts);

    % reject the bin=0 to calculate the max value and fix y-axis scale
    maxValue = max(counts(2:end));
    axis([0,1,0,maxValue]);

    % display stem line that show where the voids will start
    hold on;
    hStemLines = stem(voidsValue, maxValue,'r');
    children = get(hStemLines,'children');
    set(children(2),'visible','off');
    hold off;
    
    % get index of non voids region
    indexNotVoids = newImage < voidsValue;
    
    % set pixel not in voids to 0
    newImage(indexNotVoids) = 0;
    
    axes(handles.axesBAvoidsPreview);
    imagesc(newImage);
    axis equal;
    axis off;
      
end