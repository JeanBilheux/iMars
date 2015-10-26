function rotateData(hObject, type)
    % will allow user to select a rotating angle of the data
    % angle and will rotate either all the files selected or 
    % all the images
    
    handles = guidata(hObject);
    
    % select either all data or selected data images for display only
    images = handles.files.images;
    switch type
        case 'allImages'
            allImages = images{1};
            nbrImages = numel(images);
            if nbrImages > 1
                for i=2:nbrImages
                    allImages = allImages + images{i};
                end
            end
        case 'selectedImages'
            selection = get(handles.listboxDataFile,'value');
            nbrImages = numel(selection);
            allImages = images{selection(1)};
            if nbrImages > 1
                for i=2:nbrImages
                   allImages = allImages + images{selection(i)}; 
                end
            end            
        otherwise
    end
        
    angle = handles.rotationAngle;
    rotateImage(allImages, angle, hObject);
    
end