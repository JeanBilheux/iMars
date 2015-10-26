function [x_ellipse, y_ellipse] = getEllipseContour(x0, y0, ...
        width, height, ...
        precision)
    
    % convert data into ellipse coordinates (center of ellipse)
    ell_x0 = x0 + floor(width/2);
    ell_y0 = y0 + floor(height/2);
    ell_a = floor(width/2);
    ell_b = floor(height/2);
    
    % equation of the ellipse
    ellipse = @(x,y) ((x - ell_x0)/ell_a)^2 + ((y - ell_y0)/ell_b)^2;
    
    % will store the position of all the points that are within an
    % acceptable distance from the ellipse
    x_ellipse = [];
    y_ellipse = [];
    
    index=1;
    
    % offset in x and y direction to make sure we pick all the pixels
    % from the ellipse and don't have any frame effect
    offset = 50;
    
    % first quarter (top-right quarter)
    from_x = x0+floor(width/2)-offset;
    to_x = x0+width+offset;
    incr_x = 1;
    
    from_y = y0-offset;
    to_y = floor(height/2) + y0+offset;
    incr_y = 1;
    
    getPointOnEllipse();
    
    % second quarter (bottom-right quarter)
    from_x = x0+width+offset;
    to_x = x0+floor(width/2)-offset;
    incr_x = -1;
    
    from_y = y0+floor(height/2)-offset;
    to_y = y0+height+offset;
    incr_y = 1;
    
    getPointOnEllipse();
    
    % third quarter (bottom-left quarter)
    from_x = x0+floor(width/2)+offset;
    to_x = x0-offset;
    incr_x = -1;
    
    from_y = y0+height+offset;
    to_y = y0+floor(height/2)-offset;
    incr_y = -1;
    
    getPointOnEllipse();
    
    % fourth quarter (top-left quarter)
    from_x = x0-offset;
    to_x = x0+floor(width/2)+offset;
    incr_x = 1;
    
    from_y = y0+floor(height/2)+offset;
    to_y = y0-offset;
    incr_y = -1;
    
    getPointOnEllipse();
    
    function getPointOnEllipse()
        % this will calculate the x and y point that are on the ellipse
        % or within a precision value of it
        
        for  i=from_x:incr_x:to_x
            for j=from_y:incr_y:to_y
                value = ellipse(i,j);
                if (value >= (1-precision)) && (value <= (1+precision))
                    x_ellipse(index) = i;
                    y_ellipse(index) = j;
                    index=index+1;
                end
            end
        end
        
    end
    
end