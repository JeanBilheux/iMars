function new_image = applyAlignmentParameters(old_image, rowOfParameters)
    
        sz = size(old_image);
        height = sz(1);
        width = sz(2);
        
        new_image = zeros(height,width);
        current_image = old_image;
        
        % apply xoffset
        xoffset = fix(str2double(rowOfParameters{2}));
        if xoffset > 0
           new_image(:,xoffset+1:width) = current_image(:,1:width-xoffset);
        elseif xoffset < 0
           new_image(:,1:width-abs(xoffset)) = current_image(:,abs(xoffset)+1:width); 
        else
           new_image = current_image;
        end
        
        % apply yoffset
        yoffset = fix(str2double(rowOfParameters{3}));
        if yoffset > 0
            new_image(1:height-yoffset,:) = new_image(yoffset+1:height,:);
        elseif yoffset < 0
            new_image(abs(yoffset)+1:height,:) = new_image(1:height-abs(yoffset),:);
        end
        
        % apply rotation
        rotationAngle = fix(str2double(rowOfParameters{4}));
        new_image = imrotate(new_image,-rotationAngle, 'crop');

end