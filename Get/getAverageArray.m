function averageGammaFilteredArray = getAverageArray(hObject, sourceType)
    %this function will return an array of the average open beam or
    %dark field accordint to the srouceType passed as argument
    %'DF' or 'OB'
    
    handles = guidata(hObject);
    
    switch sourceType
        case 'OB'
            imagesArray = handles.obfiles.images;
        case 'DF'
            imagesArray = handles.dffiles.images;
    end
    nbrImages = numel(imagesArray);
    
    averageArray = imagesArray{1};
    if nbrImages > 1
        for i=2:nbrImages
            averageArray = averageArray + imagesArray{i};
        end
        averageArray = averageArray/nbrImages;
    end
    
    averageGammaFilteredArray = applyGammaFiltering(hObject, averageArray);
    
end