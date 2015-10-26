function alignmentMove(hObject, type)
    % type is either 'left','right','up','down','rotate_left','rotate_right'
    
    handles = guidata(hObject);
    
    % get the selection
    selection = get(handles.listboxDataFile,'value');
    
    % get the current alignement parameters
    bigTable = get(handles.uitableAlignment,'data');
    
    % keep only selection
    rowSelected = bigTable(selection,:);
    sz = size(rowSelected);
    nbrRowSelected = sz(1);
    
    lowIncrement = 1;
    highIncrement = 5;
    
    for i=1:nbrRowSelected
        
        switch type
            case 'left'
                index = 2;
                incre = -lowIncrement;
            case 'leftleft'
                index = 2;
                incre = -highIncrement;
            case 'right'
                index = 2;
                incre = lowIncrement;
            case 'rightright'
                index = 2;
                incre = highIncrement;
            case 'up'
                index = 3;
                incre = lowIncrement;
            case 'upup'
                index = 3;
                incre = highIncrement;
            case 'down'
                index = 3;
                incre = -lowIncrement;
            case 'downdown'
                index = 3;
                incre = -highIncrement;
            case 'rotate_left'
                index = 4;
                incre = -1;
            case 'rotate_right'
                index = 4;
                incre = 1;
        end
        
        value = double(str2double(bigTable{selection(i),index}));
        newValue = value + incre;
        
        strValue = num2str(newValue);
        bigTable{selection(i),index} = strValue;
        
    end
    
    % put value of first file selected in angle edit field
    newAngle = bigTable{selection(1),4};
    set(handles.editAlignmentAngleValue,'string',num2str(newAngle));
    
    % put new bigTable back in its place
    set(handles.uitableAlignment,'data',bigTable);
    
    % refresh preview
    refreshAlignmentPreview(hObject);
    
end