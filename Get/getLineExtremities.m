function [xmin,ymin, xmax, ymax] = getLineExtremities(a,b,imageWidth)
    % This function will take the a and b coefficient which determine
    % the line, and will return the min and max, x and y
    
    xmin = 0;
    ymin = a*xmin + b;
    
    xmax = imageWidth;
    ymax = a*xmax + b;
    
end
