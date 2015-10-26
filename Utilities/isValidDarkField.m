function validDarkField = isValidDarkField(handles, tmpImage)
   % will check if the dark field loaded is really a dark field
   % Criteria is that the average counts (total counts / number of pixels)
   % is below handles.dffiles.maxCounts = 920
    
   validDarkField = true;
   
   [szY,szX] = size(tmpImage);
   totalCounts = sum(tmpImage(:));
   
   averageCounts = totalCounts / (szY*szX);
   
   if averageCounts < handles.dffiles.maxCounts
       return
   end

   validDarkField = false;
   
end