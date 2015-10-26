function populateManualAlignmentMarkers(hObject)
   
    handles = guidata(hObject);
    
    formatedSelection = handles.alignmentMarkers;
    
    if isempty(formatedSelection)
        return
    end
    
    nbrSelection = size(formatedSelection,2);
    expression = '(\w+):(\d+),(\d+),(\d+),(\d+)';
    
    formatedAlignmentSelection = {};
    for i=1:nbrSelection
       
        tmpSelection = formatedSelection(i);
        [result] = regexp(tmpSelection, expression, 'tokens');
        
        tmpLine = result{1};
        type = '';
        switch tmpLine{1}{1}
            case 'line'
                type = 'l';
            case 'rect'
                type = 'r';
            case 'circle1'
                type = 'c';
            otherwise
        end
                
        formatedAlignmentSelection(i,:) = {type, ...
            tmpLine{1}{2}, ...
            tmpLine{1}{3}, ...
            tmpLine{1}{4}, ...
            tmpLine{1}{5}};
        
    end
    
    set(handles.uitableAlignmentMarkers,'Data',formatedAlignmentSelection);
    
end