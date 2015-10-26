function saveThreshold(hObject)
    %will save the list of threshold into an ascii file
    
    handles = guidata(hObject);
    handlesMainGui = handles.handlesMainGui;
    
    defaultPath = handlesMainGui.defaultRoiPath;
    
    [filename, pathName, ~] = uiputfile('*.txt', ...
        'Save list of Thresholds ', ...
        defaultPath);
    
    if pathName %1 file has been selected
        
        handlesMainGui.defaultRoiPath = defaultPath;
        
        fullFileName = [pathName, filename];
        try
            saveROIdata(handles, fullFileName);
        catch errorMessage
            %             message = sprintf('Error saving:   %s - %s -> %s', ...
            %                 filename, errorMessage.identifier, errorMessage.message);
            %             statusBarMessage(hObject, message, 5, true);
        end
        
    end
    
end


function saveROIdata(handles, fullFileName)
    %heart of the program that create the ROI file
    
    data = get(handles.listboxThresholdValues,'string');
    
    fileID = fopen(fullFileName,'w');
    fprintf(fileID,'#Exclusion_type[left/right]: threshold_value\n');
    fprintf(fileID,'%s\n',data{:});
    fclose(fileID);
    
end

