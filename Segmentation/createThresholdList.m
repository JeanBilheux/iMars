function [types,value] = createThresholdList(data)
   %will create the types and data list of threshold and will
   %return 2 table of cells
    
   types = {};
   value = [];
   
   nbrLines = numel(data);
   if nbrLines >= 1
       
       expression='(\w+):(.*)';
       for i=1:nbrLines
           
          currentLine = data{i};
          [solution] = regexp(currentLine, expression, 'tokens');
          types(i) = solution{1}(1); %#ok<AGROW>
          tmpValue = solution{1}{2};
          value(i) = str2double(tmpValue);   %#ok<AGROW>
           
       end
   
   end
   
end