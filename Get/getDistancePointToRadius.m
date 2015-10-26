function [a,r] = getDistancePointToRadius(a1,b1,a2,b2,x,y)
    % this function will determine the shorter distance between (x,y) and
    % the two line y=a1x+b1 and y=a2+b2 and will determine the distance of
    % that point to the mid-distance of the two lines
   
    % distance between a line y=ax+b and (x1,y1) is given by
    % d = abs(ax1-y1+b) / sqrt(a^2+1)
    
    dist_xy_line = @(a,b,x,y) abs(a*x-y+b)/sqrt(a^2+1);
    
    dist_xy_line1 = dist_xy_line(a1,b1,x,y);
    dist_xy_line2 = dist_xy_line(a2,b2,x,y);
    
    if (dist_xy_line1 <= dist_xy_line2)
        dist_xy_shorter = dist_xy_line1;
    else
        dist_xy_shorter = dist_xy_line2;
    end

    r = (dist_xy_line1+dist_xy_line2)/2.;
    a = r - dist_xy_shorter;
    
end
                    