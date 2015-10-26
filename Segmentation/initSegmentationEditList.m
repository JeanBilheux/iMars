function initSegmentationEditList(hObject)
    % This will initiate the list box
    
    handles = guidata(hObject);
    
    handlesMainGui = handles.handlesMainGui;
    
    histoThresholdValues = handlesMainGui.histoThresholdValues;
    histoThresholdTypes = handlesMainGui.histoThresholdTypes;
    
    if isempty(histoThresholdValues)
        return
    end
    
    nbrThreshold = numel(histoThresholdValues);
    list = {};
    for i=1:nbrThreshold
        tmp = sprintf('%s:%d',histoThresholdTypes{i},...
            uint32(histoThresholdValues(i)));
        list{i} = tmp; %#ok<AGROW>
    end
    
    set(handles.listboxThresholdValues,'string',list);
    
end