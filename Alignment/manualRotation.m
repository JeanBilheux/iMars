function manualRotation(hObject)
    
    handles = guidata(hObject);
    
    % get the selection
    selection = get(handles.listboxDataFile,'value');
    
    % get the current alignement parameters
    bigTable = get(handles.uitableAlignment,'data');
    
    % keep only selection
    rowSelected = bigTable(selection,:);
    sz = size(rowSelected);
    nbrRowSelected = sz(1);
    
    strValue = get(handles.editAlignmentAngleValue,'string');
    bigTable{selection(1:nbrRowSelected),4} = strValue;
        
    % put new bigTable back in its place
    set(handles.uitableAlignment,'data',bigTable);
    
    % refresh preview
    refreshAlignmentPreview(hObject);
    
end