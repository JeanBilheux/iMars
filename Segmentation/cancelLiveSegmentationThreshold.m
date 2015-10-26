function cancelLiveSegmentationThreshold(hObject)
    % we just want to refresh the plot without adding the current
    % live threshold
    
    handles = guidata(hObject);
    
    handles.liveThresholdType = 'left';
    handles.liveThresholdValue = [];
    
    guidata(hObject, handles);
    
    % refresh histogram
    refreshSegmentation(hObject, false);
    
    histoThresholdValues = handles.histoThresholdValues;
    histoThresholdTypes = handles.histoThresholdTypes;
    
    % refresh already saved thresholds
    handles = refreshPlotSavedThreshold(handles, ...
        histoThresholdValues, ...
        histoThresholdTypes);
    
    set(handles.pushbuttonAddLiveThreshold,'enable','off');
    set(handles.pushbuttonCancelLiveThreshold,'enable','off');
    
    refreshSegmentationPreview(handles, false)
    
end