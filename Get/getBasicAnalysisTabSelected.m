function baTabSelected = getBasicAnalysisTabSelected(hObject)
    % will return the Basic Analysis tab selected
    % return
    %       'Geo. Correction', 'Profile', 'ROI' or 'Voids'
    
    handles = guidata(hObject);
    
    try
        
        listButton = [handles.togglebuttonBACombine, ...
            handles.togglebuttonBAgeoCorrection', ...
            handles.togglebuttonBAProfile, ...
            handles.togglebuttonBARoi, ...
            handles.togglebuttonBAvoids];
        
        numButton = numel(listButton);
        
        for i=1:numButton
            
            if get(listButton(i),'Value') == 1
                baTabSelected = get(listButton(i),'String');
                return
            end
        end
        
        baTabSelected = get(listButton(1),'String');
        
    catch error %#ok<NASGU>
        
        baTabSelected = get(handles.togglebuttonBAProfile,'String');
        
    end
    
end