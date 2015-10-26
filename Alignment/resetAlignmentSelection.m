function resetAlignmentSelection(hObject)
    % will reset the x, y and r values of the selection
    
    handles = guidata(hObject);
    
    % get the selection
    selection = get(handles.listboxDataFile,'value');
    
    % get the current alignment parameters
    bigTable = get(handles.uitableAlignment,'data');
    
    % keep only selection
    rowSelected = bigTable(selection,:);
    sz = size(rowSelected);
    nbrRowSelected = sz(1);
    
    for i=1:nbrRowSelected
        
        for j=2:4
            bigTable{selection(i),j} = '0';
        end
        
    end
    
    % put new bigTable back in its place
    set(handles.uitableAlignment,'data',bigTable);
    
    % reset angle value field
    set(handles.editAlignmentAngleValue,'string','0');
    
end