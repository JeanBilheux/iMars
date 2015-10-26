function porosity = calculatePorosityVsFiles(hObject)
    % calculate the porosity for each of the files selected
        
    handles = guidata(hObject);
    
    maskMinValue = str2double(get(handles.editMaskMinValue,'string'));
    maskMaxValue = str2double(get(handles.editMaskMaxValue,'string'));
    voidsValue = str2double(get(handles.editBAvoidsValue,'string'));
    
    % Display the percentage of voids vs files seleted
    selection = get(handles.listboxDataFile,'value');
    nbrFilesSelected = numel(selection);
    images = handles.files.images;
    
    porosity = zeros(1,nbrFilesSelected);
    
    imagesSelected = images(selection);
    for i=1:nbrFilesSelected
        
        tmpImage = mat2gray(imagesSelected{i});
        
        %nbr pixel in mask
        indexMax = (tmpImage > maskMinValue) & (tmpImage < maskMaxValue);
        nbrPixelMask = nnz(indexMax);
        
        %nbr pixe in void
        indexVoid = (tmpImage > voidsValue) & (tmpImage < maskMaxValue);
        nbrPixelVoid = nnz(indexVoid);
        
        porosity(i) = 1 - nbrPixelVoid / nbrPixelMask;
        
    end
    
    % go to %
    porosity = porosity * 100;

end