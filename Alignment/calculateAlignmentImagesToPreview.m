function imageToPreview = calculateAlignmentImagesToPreview(hObject)
    
    handles = guidata(hObject);
    
    % get the selection
    selection = get(handles.listboxDataFile,'value');
    nbrSelection = numel(selection);
    
    % get the current alignment parameters
    bigTable = get(handles.uitableAlignment,'data');
    
    % keep only images of selection
    images = handles.files.images;
    nbrImages = numel(images);
    if nbrImages < selection
        return
    end
    if selection < 1
        return
    end
    imagesSelected = images(selection);
    
    sz = size(images{1});
    height = sz(1);
    width = sz(2);
    
    for i=1:nbrSelection
        
        new_image = zeros(height,width);
        current_image = imagesSelected{i};
        
        % apply xoffset
        xoffset = fix(str2double(bigTable{selection(i),2}));
        if xoffset > 0
            new_image(:,xoffset+1:width) = current_image(:,1:width-xoffset);
        elseif xoffset < 0
            new_image(:,1:width-abs(xoffset)) = current_image(:,abs(xoffset)+1:width);
        else
            new_image = current_image;
        end
        
        % apply yoffset
        yoffset = fix(str2double(bigTable{selection(i),3}));
        if yoffset > 0
            new_image(1:height-yoffset,:) = new_image(yoffset+1:height,:);
        elseif yoffset < 0
            new_image(abs(yoffset)+1:height,:) = new_image(1:height-abs(yoffset),:);
        end
        
        % apply rotation
        rotationAngle = double(str2double(bigTable{selection(i),4}));
        new_image = imrotate(new_image,-rotationAngle, 'crop');
        
        imageSelected{i} = new_image;
        
    end
    
    % add images
    tmp_image = imageSelected{1};
    if nbrSelection > 1
        for i=2:nbrSelection
            tmp_image = tmp_image + imageSelected{i};
        end
        tmp_image = tmp_image / nbrSelection;
    end
    
    imageToPreview = getImageForPreview(hObject, tmp_image, 'data', false);
    
end