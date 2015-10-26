function handles = addLiveSegmentationThreshold(handles, isTemporaryAdded)
    % Will add the new live value to the already saved list of
    % thresholds
    % isTemporaryAdded is true, will save the new new arrays at the
    % end
    
    if nargin < 2
        isTemporaryAdded = false;
    end
    
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
    
    refreshPlotSavedThreshold(handles, ...
        histoThresholdValues, ...
        histoThresholdTypes);
    
    if ~isTemporaryAdded
        
        handles.histoThresholdValues = histoThresholdValues;
        handles.histoThresholdTypes = histoThresholdTypes;
        
    end
    
end


