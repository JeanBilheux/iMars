function [histoThresholdTypes, histoThresholdValues] = ...
        solvedThresholdConflicts(histoThresholdValues, ...
        histoThresholdTypes)
    %This function will solve the conflicts in the list, for example
    %when two left or right exclusions are one after the other.
    
    nbrThreshold = numel(histoThresholdValues);
    if nbrThreshold > 1
        
        foundDuplicate = true; %we suppose there is at leat one duplicate
        while (foundDuplicate)
            
            [foundDuplicate, where] = isDuplicateFound(histoThresholdTypes);
            if foundDuplicate
                    [histoThresholdTypes, histoThresholdValues] = ...
                    removeDuplicateValue(histoThresholdTypes, ...
                    histoThresholdValues, where);
            end
            
        end
     
    end
        
end


function [histoThresholdTypes, histoThresholdValues] = ...
        removeDuplicateValue(histoThresholdTypes, ...
        histoThresholdValues, where)
    % remove the duplicate value,
    % will remove the second duplicate if 'left',
    % and the first duplicate if 'right'
    
    typeToRemove = histoThresholdTypes{where};
    if strcmp(typeToRemove,'left')
        histoThresholdTypes(where-1) = [];
        histoThresholdValues(where-1) = [];
    else
        histoThresholdTypes(where) = [];
        histoThresholdValues(where) = [];
    end
end


function [result, where] = isDuplicateFound(histoThresholdTypes)
% check if two successives values have the same types. 
% if yes (result), where is where the duplicate value was found
% if no (result), where is -1
    
    nbr = numel(histoThresholdTypes);
    if nbr == 1
        result = false;
        where = -1;
        return
    end
    
    previousType = histoThresholdTypes{1};
    for j=2:nbr
        if strcmp(histoThresholdTypes{j},previousType)
            result = true;
            where = j;
            return
        end
        previousType = histoThresholdTypes{j};
    end
    
    result = false;
    where = -1;
    
end

