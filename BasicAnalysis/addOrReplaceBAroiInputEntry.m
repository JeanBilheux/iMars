function addOrReplaceBAroiInputEntry(hObject, type)
    
    %this function will regroup the input informations and will replace them
    %with the current selected row in the roi list box
    
    handles = guidata(hObject);
    
    newEntry = getNewFormattedBAroiInputEntry(hObject);
    
    %get full list of profiles
    [listRoi] = get(handles.listboxBAroi,'string');
    
    if strcmp(type,'add')
        
        nbrRoi = numel(listRoi);
        listRoi{nbrRoi+1} = newEntry;
        
    else
        
        rowSelected = get(handles.listboxBAroi,'value');
        listRoi{rowSelected} = newEntry;
        
    end
    
    set(handles.listboxBAroi,'string',listRoi);
    
    refreshPreviewBasicAnalysisRoi(hObject);
    updateBAroi2D(hObject);
    m_refreshPreviewRoi(hObject, true);

end