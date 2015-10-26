%% getPerpendicularEquation
function [a,b] = getPerpendicularEquation(xy12,xy)
    % This function will determine the equation of the line
    % going through (x1,y2) and (x2,y2) and will return the equation
    % of the perpendicular to this line at the point (x,y) defined
    
    tmp_xy12 = num2cell(xy12);
    [x1,y1,x2,y2] = tmp_xy12{:};
    
    tmp_xy = num2cell(xy);
    [x,y] = tmp_xy{:};
    
    a_normal = (y1 - y2)/(x1-x2);
    % b_normal = y1 - x1 * a_normal;
    
    % the reference slope of the perpdendicular is -1/a_normal
    a = - 1. / a_normal;
    b = y - a * x;
    
end
