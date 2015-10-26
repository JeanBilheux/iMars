function newImage = linear_interpolation_of_offset_chips(handles, ...
        image)
    
    [height, ~] = size(image);
    
    if height == 512
        region1 = handles.chips.low_offset.ip.region1;
        region2 = handles.chips.low_offset.ip.region2;
        region3 = handles.chips.low_offset.ip.region3;
        region4 = handles.chips.low_offset.ip.region4;
    else
        region1 = handles.chips.high_offset.ip.region1;
        region2 = handles.chips.high_offset.ip.region2;
        region3 = handles.chips.high_offset.ip.region3;
        region4 = handles.chips.high_offset.ip.region4;
    end

    global_region = {region1, region2, region3, region4};
    
    for r=1:4
        
       tmp_region = global_region{r};
       y0 = tmp_region{1}{1}(1);
       x0 = tmp_region{1}{1}(2);
       y1 = tmp_region{1}{2}(1);
       x1 = tmp_region{1}{2}(2);
       type = tmp_region{2};
        
       switch type
           case 'x' % region 3 and 4
               for y=y0:y1
                   counts_side0 = image(y,x0);
                   counts_side1 = image(y,x1);
                   [a,b] = calculate_equation(counts_side0, ...
                       counts_side1, ...
                       x0, ...
                       x1);
                   
                   for x=x0+1:x1-1
                      image(y,x) = x*a+b; 
                   end
                   
               end
           case 'y' % region 1 and 2
               for x=x0:x1
                   counts_side0 = image(y0,x);
                   counts_side1 = image(y1,x);
                   [a,b] = calculate_equation(counts_side0, ...
                       counts_side1, ...
                       y0, ...
                       y1);
                   
                   for y=y0+1:y1-1
                       image(y,x) = y*a+b;
                   end
                   
               end
       end
        
    end
    
    newImage = image;
    
end




function [a,b] = calculate_equation(y0,y1,x0,x1)
  % calculate equation of line going through A(x0,y0) and B(x1,y1)
  % using y=ax+b
  
  a = (y1-y0)/(x1-x0);
  b = y1 - a * x1;
    
end