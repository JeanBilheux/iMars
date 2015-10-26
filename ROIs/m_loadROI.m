function m_loadROI(hObject, handles)
    %Load normalization tab ROI
    %reached by the LOAD... button
    
    defaultPath = handles.defaultRoiPath;
    
    [filename, pathName, ~] = uigetfile('*.txt', ...
        'Select ROI file', ...
        defaultPath);
    
    if pathName %1 file has been selected
        
        handles.defaultRoiPath = pathName; %record new default ROI path name
        
        fullFileName = [pathName, filename];
        try
            data = m_loadROIdata(fullFileName);
        catch errorMessage
            data = [];
            message = sprintf('Error loading:   %s - %s -> %s', ...
                filename, errorMessage.identifier, errorMessage.message);
            statusBarMessage(hObject, message, 5, true);
        end
        handles = guidata(hObject);
        
        if ~isempty(data) %we have something to load
            
            %check if there is already at least 1 ROI defined
            if isROIalreadyDefined(handles)
                button = questdlg('Do you want to  REPLACE  or  ADD  the new ROI?', ...
                    'What do you want to do?', ...
                    'Replace','Add','Replace');
                if strcmp(button,'Replace')
                    replaceData(handles, data);
                else
                    appendData(handles, data);
                end
            else
                replaceData(handles, data);
            end
            
            %we need to replot the ROI on the preview
            m_plotPreviewROIs(hObject, false);
            handles = guidata(hObject);
        end
        
        guidata(hObject, handles);
        
    end
    
end


function bValue = isROIalreadyDefined(handles)
    %check if at least one ROI has already been defined
    
    value = get(handles.listboxNormalizationRoi,'string');
    if isempty(value)
        bValue = false;
    else
        bValue = true;
    end
    
end


function replaceData(handles, data)
    %replace listbox contain by new data
    
    value = '';
    addDataToValue(handles, data, value);
    
end


function appendData(handles, data)
    %add data to previous ROI defined
    
    value = get(handles.listboxNormalizationRoi,'string');
    tmpArray = value(1,:);
    sz = size(value,1);
    for i=2:sz
        tmpArray = [tmpArray value(i,:)]; %#ok<AGROW>
    end
    addDataToValue(handles, data, tmpArray);
    
end


function addDataToValue(handles, data, value)
    %using the current value array, will add the new data to the value
    %and will replace the listbox contain with the new value array
    
    newData = [data{:}];
    sz = size(newData);
    
    localData = data{1};
    
    if ~isempty(value)
        for i=1:sz
            value = [value newData{i}]; %#ok<AGROW>
        end
    else
        value = localData;
    end
    set(handles.listboxNormalizationRoi,'string',value);
    
end


