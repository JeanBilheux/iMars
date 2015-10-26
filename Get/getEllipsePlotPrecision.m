function precision = getEllipsePlotPrecision(ellipseThickness)
    % return the precision of pixel to take to consider them as
    % part of the ellipse or not
    
    switch ellipseThickness
        case 1
            precision=0.005;
        case 2
            precision=0.01;
        case 3
            precision=0.02;
        case 4
            precision=0.04;
        case 5
            precision=0.08;
        otherwise
            precision=0.16;
    end
    
end