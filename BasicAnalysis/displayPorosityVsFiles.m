function displayPorosityVsFiles(hObject)
    % This function will bring to life a figure to plot
    % the porosity vs files #
   
    porosity = calculatePorosityVsFiles(hObject);
    plotPorosityVsFiles(hObject, porosity);

end