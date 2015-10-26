function result = nanmedian(array)
    % this routine will calculate the median of an array that has
    % NaN value in it
    
    % flatten the array
    flatArray = array(:);
    
    % remove NaN values
    nonNanArray = flatArray(find(~isnan(flatArray)));
    
    result = median(nonNanArray);
    
end