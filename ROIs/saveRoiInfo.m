function saveRoiInfo(hObject)
    % Will ask the user for a file name and will output the
    % table data into that file as a csv file
    
    handles = guidata(hObject);
    
    tableData = get(handles.uitableRoiInfo,'data');
    columnName = get(handles.uitableRoiInfo,'columnName');
    path = handles.path;
    
    FilterSpec = {'*.txt'};
    DialogTitle = 'Enter a file name';
    
    [FileName,PathName,~] = uiputfile(FilterSpec,DialogTitle, path);
    
    fullFileName = [PathName FileName];
    
    if ~isempty(FileName)
        
        fid = fopen(fullFileName,'w');
        
        nbrColumn = size(columnName,1);
        colStr = '';
        for i=1:nbrColumn
            if i==1
                pre = '';
            else
                pre = ',';
            end
            colStr = [colStr pre columnName{i}]; %#ok<AGROW>
        end
        
        fprintf(fid, '#%s\n', colStr);
        
        nbrRowTable = size(tableData,1);
        
        for j=1:nbrRowTable
            tmpLine =  '';
            for k=1:nbrColumn
                if k==1
                    pre = '';
                else
                    pre = ',';
                end
                str = sprintf('%d', tableData{j,k});
                tmpLine = [tmpLine pre str]; %#ok<AGROW>
            end
            fprintf(fid,'%s\n', tmpLine);
        end
        
        fclose(fid);
        
    end
    
end