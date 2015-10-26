function plotPorosityVsFiles(hObject, porosity)
    % will display the porosity vs files
   
    figure(1);

    nbrFiles = numel(porosity);
    
    fprintf('NbrFiles = %d\n', nbrFiles);
    
    plot(1:nbrFiles, porosity,'r*');
    xlabel('File #');
    ylabel('Porosity (%)');
    
    if nbrFiles > 1
        axis([1 nbrFiles 0 100]);
    end
    
end