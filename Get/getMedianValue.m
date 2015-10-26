function medianValue = getMedianValue(listCounts)
    % this will return the median of a list
    % ex:  [1,10,14,15,20] -> 14
    % ex:  [1,10,14,15,20,22] -> 14.5  (take average of medians values)
    
    % sort the list first
    listSorted = sort(listCounts);
    nbr = numel(listSorted);
    if (mod(nbr,2)==0) % even number
        medianValue = mean([listSorted(floor(nbr/2)), listSorted(floor(nbr/2)+1)]);
    else % odd number
        medianValue = listSorted(floor(nbr/2)+1);
    end
    
end