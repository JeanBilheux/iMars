function exportPorosityVsFiles(hObject)
    % This function will bring to life a figure to plot
    % the porosity vs files #
   
    porosity = calculatePorosityVsFiles(hObject);
    createFilePorosityVsFiles(hObject, porosity);

end

function createFilePorosityVsFiles(hObject, porosity)
   
    [filename, pathname, ~] = uiputfile('*.txt', ...
        'Porosity File Name');
    
    if filename == 0
        return
    end
    
    fullFileName = [pathname filename];
    
    handles = guidata(hObject);
    
    % retrieve the list of files selected
    selection = get(handles.listboxDataFile,'value');
    listFiles = get(handles.listboxDataFile,'string');
    listFilesSelected = listFiles(selection);
    
    nbrData = numel(porosity);
    
    fid = fopen(fullFileName,'w');
    
    if ispc
        cr = '\r';
    else
        cr = '\n';
    end
    
    % add label
    fprintf(fid,['File name, Percentage of porosity ( over number of pixel in Mask)' cr]);
    
    for i=1:nbrData
        if ispc
            fprintf(fid, '%s,%d\r', listFilesSelected{i}, porosity(i));
        else
             fprintf(fid, '%s,%d\n', listFilesSelected{i}, porosity(i));
        end
    end

    fclose(fid);
    
end