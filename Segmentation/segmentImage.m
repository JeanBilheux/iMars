function finalImage = segmentImage(finalImage, ...
        histoThresholdValues, ...
        histoThresholdTypes)
    
    nbrThreshold = numel(histoThresholdValues);
    rejectedValue = 65535;
    
    if nbrThreshold ~= 0
        
        %determine the various vertices and faces
        if nbrThreshold == 1
            
            type = histoThresholdTypes{1};
            switch type
                case 'left'
                    x = histoThresholdValues(1);
                    indexToRemove = finalImage <= x;
                    finalImage(indexToRemove) = rejectedValue;
                    
                case 'right'
                    x = histoThresholdValues(1);
                    indexToRemove = finalImage >= x;
                    finalImage(indexToRemove) = rejectedValue;
            end
            
        else %more than 1 threshold
            
            i=1;
            while (i<=nbrThreshold)
                
                val1 = histoThresholdValues(i);
                type1 = histoThresholdTypes{i};
                
                if i==1 && strcmp(type1,'left') %first threshold excludes the left
                    
                    x = val1;
                    indexToRemove = finalImage <= x;
                    finalImage(indexToRemove) = rejectedValue ;
                    
                else
                    
                    if (i+1) <= nbrThreshold
                        
                        x2 = histoThresholdValues(i+1); %can only be left
                        x1 = val1;
                        
                        indexToRemove = (finalImage >= x1) & (finalImage <= x2);
                        finalImage(indexToRemove) = rejectedValue;
                        
                        i = i + 1;
                        
                    else %we are working with the last one (right exclusion)
                        
                        x = val1;
                        indexToRemove = finalImage >= x;
                        finalImage(indexToRemove) = rejectedValue;
                        
                    end %if (i+1) <= nbrThreshold
                    
                end %if i==1 && strcmp(type1....)
                
                i=i+1;
                
            end %end of while loop
            
        end %end of if nbrThreshold ==1
        
    end %if nbrThreshold ~= 0
    
end