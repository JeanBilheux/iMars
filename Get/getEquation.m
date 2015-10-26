%% getEquation
function [a,b] = getEquation(xy12)
    % This function will determine the equation of the line
    % going through (x1,y2) and (x2,y2) 
    
    tmp_xy12 = num2cell(xy12);
    [x1,y1,x2,y2] = tmp_xy12{:};
        
    a = (y1 - y2)/(x1-x2);
    b = y1 - x1 * a;
    
end
