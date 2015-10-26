function create2columnsCsv(outputFileName, comments, column1, column2)
   % will create a 2 columns CSV file
   % ex:
   %        column1(1), column2(1)
   %        column1(2), column2(2)
   %        column1(3), column2(3)
    
   fid = fopen(outputFileName, 'w');
   
   %write comments
   for i=1:numel(comments)
      fprintf(fid, '#%s\n', comments{i}); 
   end
   
   nbrRow = numel(column1);
   for i=1:nbrRow
      fprintf(fid, '%d , %d\n', column1(i), column2(i));
   end

   fclose(fid);
   
end

    
    