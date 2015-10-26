function loadThreshold(hObject)
    %this will load the threshold into the list box
    
    handles = guidata(hObject);
    handlesMainGui = handles.handlesMainGui;
    hObjectMainGui = handles.hObjectMainGui;
    
    defaultPath = handles.defaultRoiPath;
    
    [filename, pathName, ~] = uigetfile('*.txt', ...
        'Select Threshold file', ...
        defaultPath);
    
    if pathName
        
        handles.defaultRoiPath = pathName;
        
        fullFileName = [pathName, filename];
        data = loadThresholdData(fullFileName);
        
        replaceData(handles, data);
        
        data = data{1};
        [types,values] = createThresholdList(data);
        
        handlesMainGui.histoThresholdTypes = types;
        handlesMainGui.histoThresholdValues = values;
        guidata(hObjectMainGui, handlesMainGui);
        refreshSegmentation(hObjectMainGui, true);
        handles = refreshPlotSavedThreshold(handlesMainGui, values, types);
        
        guidata(hObject, handles);
        refreshSegmentationPreview(handlesMainGui);
        
    end
    
end


% function bValue = isThresholdAlreadyDefined(handles)
%     %check if at least one Threshold entry has already been defined
%     
%     value = get(handles.listboxThresholdValues,'string');
%     if isempty(value)
%         bValue = false;
%     else
%         bValue = true;
%     end
%     
% end


function data = loadThresholdData(fullFileName)
    %return just the contain of the ascii file without doing
    %anything with it
    
    fid = fopen(fullFileName);
    data = textscan(fid, '%s', ...
        'headerlines',1);
    fclose(fid);
    
end


function replaceData(handles, data)
    %replace listbox contain by new data
    
    value = '';
    addDataToValue(handles, data, value);
    
end


% function appendData(handles, data)
%     %add data to previous ROI defined
%     
%     value = get(handles.listboxThresholdValues,'string');
%     tmpArray = value(1,:);
%     sz = size(value,1);
%     for i=2:sz
%         tmpArray = [tmpArray value(i,:)]; %#ok<AGROW>
%     end
%     addDataToValue(handles, data, tmpArray);
%     
% end


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
    set(handles.listboxThresholdValues,'string',value);
    
end


