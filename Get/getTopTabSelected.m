function topTabSelected = getTopTabSelected(hObject)
    % will return the top tab selected
    % return
    %     'Normalization', 'Analysis', 'Segmentation' or 'Alignment'
    
    handles = guidata(hObject);
    
    listButton = [handles.toggleNormalization, ...
        handles.toggleBasicAnalysis, ...
        handles.toggleSegmentation, ...
        handles.toggleAlignment];
    
    numButton = numel(listButton);
    
    for i=1:numButton
        
        if get(listButton(i),'value') == 1
            topTabSelected = get(listButton(i),'String');
            return
        end
        
    end
    
end