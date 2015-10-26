function m_addReplaceRoiFieldWithManualEntry(hObject, isReplace)
    %this function add or replace an entry from the ROI manual entry
    %fields
    
    try
        
        handles = guidata(hObject);
        
        [preLoadedRoi] = get(handles.listboxNormalizationRoi,'string');
        
        %collect the manual entries
        if get(handles.checkboxRoiRectangle,'value')
            shape = 'r';
        else
            shape = 'c';
        end
        
        x0 = get(handles.editRoiX0,'string');
        y0 = get(handles.editRoiY0,'string');
        width = get(handles.editRoiWidth,'string');
        height = get(handles.editRoiHeight,'string');
        
        newRow = sprintf('%s:%s,%s,%s,%s',shape,x0{1},y0{1},...
            width{1},height{1});
        
        if isReplace
            rowIndex = get(handles.listboxNormalizationRoi,'value');
        else
            rowIndex = length(preLoadedRoi)+1;
        end
        
        preLoadedRoi{rowIndex} = newRow;
        
        %put it back
        set(handles.listboxNormalizationRoi,'string',preLoadedRoi);
        
    catch errorMessage
        
        message = sprintf('Error Adding New ROI - %s -> %s', ...
            errorMessage.identifier, errorMessage.message);
        
        statusBarMessage(hObject, message, 5, true);

    end
    
end
