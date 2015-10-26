function updateSegmentationGui(hObject)
    %will check if the widget can be displayed
    
    handles = guidata(hObject);
    
    %if at least 1 data file and selected, enabled widgets
    nbrDataFiles = handles.files.nbr;
    
    if nbrDataFiles > 0
        enableStatus = 'on';
    else
        enableStatus = 'off';
    end
    
    listSegmHandles = [handles.togglebuttonSegmentationExcludeLeft, ...
        handles.togglebuttonSegmentationExcludeRight, ...
        handles.pushbuttonSegmentationExportHistogram, ...
        handles.pushbuttonSegmentationEditThreshold, ...
        handles.pushbuttonSegmentationRun];

    nbrHandles = numel(listSegmHandles);
    for i=1:nbrHandles
        set(listSegmHandles(i),'enable',enableStatus);
    end
    
    liveValue = handles.liveThresholdValue;
    if isempty(liveValue)
        activateStatus = 'off';
    else
        activateStatus = 'on';
    end
    set(handles.pushbuttonAddLiveThreshold,'enable',activateStatus);
    set(handles.pushbuttonCancelLiveThreshold,'enable',activateStatus);
    
end