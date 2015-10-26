function initializeAlignmentTable(handles)
    % populate table the first time
    
    % get list of data files
    fileNames = handles.files.fileNames;
    isNewAlignment = handles.isNewAlignment;
    
    % build big table
    if isempty(fileNames)
        bigTable = {'',''};
        handles.isRowAligned = {};
    else
        nbrFiles = numel(fileNames);
        if isNewAlignment
            for i=1:nbrFiles
                bigTable{i,1} = fileNames{i}; %#ok<AGROW>
                bigTable{i,2} = '0'; %#ok<AGROW>
                bigTable{i,3} = '0'; %#ok<AGROW>
                bigTable{i,4} = '0'; %#ok<AGROW>
            end
        end
    end
    % populate big table
    set(handles.uitableAlignment, 'data', bigTable)
    
end