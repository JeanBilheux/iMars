function data = m_loadROIdata(fullFileName)
    %retrieve the data from a ROI file name
    
    fid = fopen(fullFileName);
    data = textscan(fid, '%s', ...
        'headerlines',1);
    fclose(fid);
    
    %get nbrLines
    nbrLines = size(data{1},1);
    if nbrLines > 0
        
        expression='([rc]):(\d+)[, ](\d+)[, ](\d+)[, ](\d+)';
        for i=1:nbrLines
            
            currentLine = data{1}(i);
            [solution] = regexp(currentLine,expression,'tokens');
            
            %            if (length(solution{1}) == 0) || (length(solution{1}{1}) < 5)
            if isempty(solution{1}) || (length(solution{1}{1}) < 5)
                error('LoadROIdata:MissingData','Incompatible format');
            end
            
        end
        
    end
    
end