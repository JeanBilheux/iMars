function resetAlignment(hObject)
    % will reset all the parameters (x, y and r) of all the files
    
    handles = guidata(hObject);
    
    % get the current alignement parameters
    bigTable = get(handles.uitableAlignment,'data');
    sz = size(bigTable);
    nbrRow = sz(1);
    
    for i=1:nbrRow
        
        for j=2:4
            bigTable{i,j} = '0';
        end
    end
    
    % put new bigTable back in its place
    set(handles.uitableAlignment,'data',bigTable);
    
    % reset angle value
    set(handles.editAlignmentAngleValue,'string','0');
    
end