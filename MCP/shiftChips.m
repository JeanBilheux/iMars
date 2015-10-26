function tmpImage = shiftChips(hObject, image)
    % This will apply the shift of the chips
    
    %     figure(1);
    %     subplot(1,2,1);
    %     imshow(image,[]);
    
    handles = guidata(hObject);
    [height, width] = size(image);
    
    % fix dead pixels
    if height == 512
        deadPixels = handles.chips.low_offset.deadPixels;
    else
        deadPixels = handles.chips.high_offset.deadPixels;
    end
    
    nbr_deadPixels = size(deadPixels,2);
    
    for px=1:nbr_deadPixels
        
        tmpPixel = deadPixels{px}{1};
        
        firstCorner = tmpPixel(1,:);
        secondCorner = tmpPixel(2,:);
        
        x0 = firstCorner(1);
        y0 = firstCorner(2);
        x1 = secondCorner(1);
        y1 = secondCorner(2);
        
        % get mean value of outside border of dead pixels region
        average = calculate_outside_average(image,y0,y1,x0,x1);
        image(y0:y1,x0:x1) = average;
        
    end
    
    if height == 512
        chip1_offset = handles.chips.low_offset.chip1;
        chip2_offset = handles.chips.low_offset.chip2;
        chip3_offset = handles.chips.low_offset.chip3;
        chip4_offset = handles.chips.low_offset.chip4;
    else
        chip1_offset = handles.chips.high_offset.chip1;
        chip2_offset = handles.chips.high_offset.chip2;
        chip3_offset = handles.chips.high_offset.chip3;
        chip4_offset = handles.chips.high_offset.chip4;
    end
    
    w_chips = fix(width/2);
    h_chips = fix(height/2);
    
    x_margin = 30;
    y_margin = 30;
    newImage = zeros(height + 2*y_margin, width + 2*x_margin);
    
    % bottom left chips is fixed
    bl_xoffset = chip3_offset(1);
    bl_yoffset = chip3_offset(2);
    
    newData_h1 = h_chips + y_margin + 1 + bl_yoffset;
    newData_h2 = 2 * h_chips + y_margin + bl_yoffset;
    newData_w1 = x_margin + 1 + bl_xoffset;
    newData_w2 = x_margin + w_chips + bl_xoffset;
    
    data_h1 = h_chips + 1;
    data_h2 = height;
    data_w1 = 1;
    data_w2 = w_chips;
    
    newImage(newData_h1:newData_h2, newData_w1:newData_w2) = ...
        image(data_h1:data_h2, data_w1:data_w2);
    
    % bottom right chip
    br_xoffset = chip4_offset(1);
    br_yoffset = chip4_offset(2);
    
    newData_h1 = h_chips + y_margin + 1 + br_yoffset;
    newData_h2 = 2 * h_chips + y_margin + br_yoffset;
    newData_w1 = x_margin + w_chips + 1 + br_xoffset;
    newData_w2 = x_margin + w_chips + w_chips + br_xoffset;
    
    data_h1 = h_chips + 1;
    data_h2 = height;
    data_w1 = w_chips + 1;
    data_w2 = 2*w_chips;
    
    newImage(newData_h1:newData_h2, newData_w1:newData_w2) = ...
        image(data_h1:data_h2, data_w1:data_w2);
    
    % top right chip
    tr_xoffset = chip2_offset(1);
    tr_yoffset = chip2_offset(2);
    
    newData_h1 = y_margin + 1+ tr_yoffset;
    newData_h2 = y_margin + h_chips + tr_yoffset;
    newData_w1 = x_margin + w_chips + 1 + tr_xoffset;
    newData_w2 = x_margin + w_chips + w_chips + tr_xoffset;
    
    data_h1 = 1;
    data_h2 = h_chips;
    data_w1 = w_chips + 1;
    data_w2 = 2*w_chips;
    
    newImage(newData_h1:newData_h2, newData_w1:newData_w2) = ...
        image(data_h1:data_h2, data_w1:data_w2);
    
    % top left chip
    tl_xoffset = chip1_offset(1);
    tl_yoffset = chip1_offset(2);
    
    newData_h1 = y_margin + 1 + tl_yoffset;
    newData_h2 = y_margin + h_chips + tl_yoffset;
    newData_w1 = x_margin + 1 + tl_xoffset;
    newData_w2 = x_margin + w_chips + tl_xoffset;
    
    data_h1 = 1;
    data_h2 = h_chips;
    data_w1 = 1;
    data_w2 = w_chips;
    
    newImage(newData_h1:newData_h2, newData_w1:newData_w2) = ...
        image(data_h1:data_h2, data_w1:data_w2);
    
    % keep only the same frame of the image
    tmpImage = newImage(y_margin + 1 : height + y_margin, ...
        x_margin + 1: width + x_margin);
    
    % provide linear interpolation of the missing pixels for low resolution
    % MCP only
    if height == 512
        tmpImage = linear_interpolation_of_offset_chips(handles, ...
            tmpImage);
    end

    %     subplot(1,2,2);
    %     imshow(tmpImage,[]);
    
end

function average = calculate_outside_average(image,y0,y1,x0,x1)
    
    top_region = mean(image(y0-1,x0-1:x1+1));
    left_region = mean(image(y0:y1, x0-1));
    right_region = mean(image(y0:y1, x1+1));
    bottom_region = mean(image(y1+1, x0-1:x1+1));
    
    average = mean([top_region, left_region, right_region, bottom_region]);
    
end



