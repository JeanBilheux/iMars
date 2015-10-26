function removeSelectedThreshold(hObject)
    %will remove the selected threshold and will reorganize the left ones
    
    handles = guidata(hObject);
    handlesMainGui = handles.handlesMainGui;
    hObjectMainGui = handles.hObjectMainGui;
    
    %get list of threshold
    listThreshold = get(handles.listboxThresholdValues,'string');
    if (isempty(listThreshold))
        return
    end
    
    selectedThreshold = get(handles.listboxThresholdValues,'value');
    listThreshold(selectedThreshold) = [];
    
    [types, values] = createThresholdList(listThreshold);
    [types, values] = solvedThresholdConflicts(values, types);
    
    handlesMainGui.histoThresholdTypes = types;
    handlesMainGui.histoThresholdValues = values;
    guidata(hObjectMainGui, handlesMainGui);
    
    handlesMainGui = guidata(hObjectMainGui);
    refreshSegmentation(hObjectMainGui, false)
    
    axes(handlesMainGui.axesSegmentationThresholds);
    handlesMainGui = refreshPlotSavedThreshold(handlesMainGui);
    
    %repopulate the list with new working list
    formattedList = formatThresholdList(values, types);
    set(handles.listboxThresholdValues,'string', formattedList);
    set(handles.listboxThresholdValues,'value',1);
    
    refreshSegmentationPreview(handlesMainGui, false);
    
end


function formattedList = formatThresholdList(values, types)
    %will format the types and values list to populate the list box
    
    nbr = numel(types);
    formattedList = {};
    for i=1:nbr
        tmp = sprintf('%s:%d',types{i},values(i));
        formattedList{i} = tmp; %#ok<AGROW>
    end
    
end