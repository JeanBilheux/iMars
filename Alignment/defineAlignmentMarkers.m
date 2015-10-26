function defineAlignmentMarkers(hObject)
    % This function will allow user to define various markers such as lines,
    % rectangle and circle
    
    handles = guidata(hObject);
    alignmentMarkers = handles.alignmentMarkers;
    
    % launch the Figure that will allow the selection of markers
    selectAlignmentMarkersTool(hObject, alignmentMarkers);
    
end