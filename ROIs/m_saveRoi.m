function m_saveRoi(hObject)
    %This will save the ROI
    
    handles = guidata(hObject);
    
    defaultPath = handles.defaultRoiPath;
    
    [filename, pathName, ~] = uiputfile('*.txt', ...
        'Save ROI file', ...
        defaultPath);
    
    if pathName %1 file has been selected
        
        handles.defaultRoiPath = pathName; %record new default ROI path name
        
        fullFileName = [pathName, filename];
        try
            saveROIdata(handles, fullFileName);
        catch errorMessage
            message = sprintf('Error saving:   %s - %s -> %s', ...
                filename, errorMessage.identifier, errorMessage.message);
            statusBarMessage(hObject, message, 5, true);
        end
        
    end
    
end


function saveROIdata(handles, fullFileName)
    %heart of the program that create the ROI file
    
    data = get(handles.listboxNormalizationRoi,'string');
    
    fileID = fopen(fullFileName,'w');
    fprintf(fileID,'#[r/c]:x1,y1,width,height\n');
    fprintf(fileID,'%s\n',data{:});
    fclose(fileID);
    
end




