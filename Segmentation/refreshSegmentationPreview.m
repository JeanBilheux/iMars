function refreshSegmentationPreview(handles, isFromLive)
    %will refresh the bottom plot of the segmentation tab according
    %to the data selected and the threshold defined
    %
    % isFromLive: is true if this function is reached from a live click
    % of a threshold
    
    if nargin < 2
        isFromLive = false;
    end
    
    if isFromLive
        
        liveThresholdValue = handles.liveThresholdValue;
        if numel(liveThresholdValue) == 0
            return
        end
        liveThresholdType = handles.liveThresholdType;
        
        histoThresholdValues = handles.histoThresholdValues;
        histoThresholdTypes = handles.histoThresholdTypes;
        
        histoThresholdValues(end+1) = liveThresholdValue(1);
        histoThresholdTypes{end+1} = liveThresholdType;
        
        [histoThresholdValues,ix] = sort(histoThresholdValues);
        histoThresholdTypes = histoThresholdTypes(ix);
        
        [histoThresholdTypes, histoThresholdValues] = ...
            solvedThresholdConflicts(histoThresholdValues, ...
            histoThresholdTypes);
        
    else
        
        histoThresholdValues = handles.histoThresholdValues;
        histoThresholdTypes = handles.histoThresholdTypes;
        
    end
    
%     display_type = getDisplayType(handles);
%     switch (display_type)
%         case 'radiobuttonIntensityValue'
%         case 'radiobuttonTransmissionPercent'
%             rejectedValue = 100;
%         case 'radiobuttonAttenuation'
%             rejectedValue = 65535;
%         case 'radiobuttonTransmissionIntensity'
%             rejectedValue = 1;
%     end
    
    finalImage = handles.currentImagePreviewed;
    
    finalImage = segmentImage(finalImage, ...
        histoThresholdValues, ...
        histoThresholdTypes);
    
    minIntensity = handles.files.minIntensity;
    maxIntensity = handles.files.maxIntensity;
    
      axes(handles.axesSegmentationPreview);
     %     imshow(finalImage, [minIntensity, maxIntensity]);
    colormap(handles.axesSegmentationPreview, handles.colormap);
    imagesc(finalImage, [minIntensity, maxIntensity]);
    
    axis on;
    xlabel(handles.axesSegmentationPreview, 'Pixels');
    set(handles.axesSegmentationPreview, 'XAxisLocation','top');
    ylabel(handles.axesSegmentationPreview, 'Pixels');
    colorbar;
    
    drawnow;
    
end