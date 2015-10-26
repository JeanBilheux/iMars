function radius = getCylinderRadius(cylinderX1Y1X2Y2)
    % returns the radius of a cylinder that the two point (x1,y1) and
    % (x2,y2) define its diameter
    
    tmpFormat = num2cell(cylinderX1Y1X2Y2);
    [x1,y1,x2,y2] = tmpFormat{:};
    
    radius = fix((sqrt((x2-x1)^2 + (y2-y1)^2))/2);
    
end
