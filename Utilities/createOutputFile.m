function createOutputFile(hObject, fullFileName, data, comments, nbrProfiles)
    %this will create a comma separated ascii file of the data
    %after the commented lines
    
    fid = fopen(fullFileName,'w');
    if fid == -1                
        message = sprintf('Error writing in this folder');
        statusBarMessage(hObject, message, 5, true);
        return
    end
    
    %write comments
    for i=1:numel(comments)
        fprintf(fid, '#%s\n' , comments{i});
    end
    
    fprintf(fid, '#\n');
    
    initStr = 'x,y,counts,error';
    if nbrProfiles > 1
        str = initStr;
        for j=2:nbrProfiles
            str = [str ',,' initStr ]; %#ok<AGROW>
        end
    else
        str = initStr;
    end
    fprintf(fid,'#%s\n', str);
    
    [row,~] = size(data);
    for k=1:row
        
        str = sprintf('%d,%d,%d,%d',data(k,1),data(k,2),data(k,3),data(k,4));
        if nbrProfiles > 1
            for j=2:nbrProfiles
                preStr = sprintf('%d,%d,%d,%d', ...
                    data(k,(j-1)*4), ...
                    data(k,(j-1)*4+1), ...
                    data(k,(j-1)*4+2), ...
                    data(k,(j-1)*4+3));
                str = [str ',,' preStr]; %#ok<AGROW>
            end
        end
        fprintf(fid, '%s\n', str);
        
    end
    
    fclose(fid);
    
end