function result = getIntersectionCircleLine(xc, yc, radius, xy12)
    
    % circle radius
    r = radius;
    
    % point that define the line
    [a,b] = getEquation(xy12);
    
    % temporary coefficient
    B = 2*(a*b - a*yc - xc);
    A = a^2 + 1;
    C = yc^2 - r^2 + xc^2 - 2*b*yc + b^2;
    
    x1 = (-B + sqrt(B^2 - 4*A*C)) / (2*A);
    x2 = (-B - sqrt(B^2 - 4*A*C)) / (2*A);
    
    y1 = (a * (-B + sqrt(B^2 - 4*A*C)) / (2*A)) + b;
    y2 = (a * (-B - sqrt(B^2 - 4*A*C)) / (2*A)) + b;
    
    result = [x1,y1,x2,y2];
    
end
    
    