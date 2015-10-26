function validateManualAlignmentEntries(hObject)
    % will validate the new entries in the Manual markers table
    % and will save them in the alignmentMarkers
    
    handles = guidata(hObject);
    
    markerTable = get(handles.uitableAlignmentMarkers,'Data');
    alignmentMarkers = {};
    
    nbr_row = size(markerTable,1);
    index = 1;
    for i=1:nbr_row
        
        tmpType = markerTable{i,1};
        
        newType = '';
        switch (tmpType)
            case 'l'
                newType = 'line';
            case 'r'
                newType = 'rect';
            case 'c'
                newType = 'circle1';
            otherwise
        end
        
        if strcmp(newType,'')
            continue
        end
       
        newx = markerTable{i,2};
        newy = markerTable{i,3};
        newwidth = markerTable{i,4};
        newheight = markerTable{i,5};
        
        try 
            x = fix(newx);
            y= fix(newy);
            width = fix(newwidth);
            height = fix(newheight);
        catch 
           continue 
        end
        
        str = sprintf('%s:%s,%s,%s,%s', newType, ...
            x, y, width, height);
        
        alignmentMarkers{index} = str; %#ok<AGROW>
        index = index + 1;
        
    end

    handles.alignmentMarkers = alignmentMarkers;
    guidata(hObject, handles);
    handles.alignmentMarkers;
    
end