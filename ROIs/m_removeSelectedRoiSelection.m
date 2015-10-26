function  m_removeSelectedRoiSelection(hObject)
    %this function will remove the selected ROI
    
    handles = guidata(hObject);
    
    [preLoadedRoi] = get(handles.listboxNormalizationRoi,'string');
    rowIndex = get(handles.listboxNormalizationRoi,'value');
    
    %in case we removed the last entry
    if rowIndex == length(preLoadedRoi)
        if rowIndex ~= 1
            rowIndex = rowIndex-1;
            set(handles.listboxNormalizationRoi,'value',rowIndex);
            preLoadedRoi(rowIndex+1) = [];
        else
            set(handles.listboxNormalizationRoi,'value',rowIndex);
            preLoadedRoi(rowIndex) = [];
            %            rowIndex = rowIndex-1;
        end
    end
    
    %put it back
    set(handles.listboxNormalizationRoi, 'string', preLoadedRoi);
    
end