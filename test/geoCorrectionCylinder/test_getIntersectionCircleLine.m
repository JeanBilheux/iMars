% y = ax+b
% (x-xc)^2 + (y-yc)^2 = r^2

a= 0.75  ;
b= 1.25  ;
xc= 16 ;
yc= 13 ;
r= 8.7  ;

% B = 2*(a*b - a*yc - xc);
% A = a^2 + 1;
% C = yc^2 - r^2 + xc^2 - 2*b*yc + b^2;
% 
% x1 = (-B + sqrt(B^2 - 4*A*C)) / (2*A);
% x2 = (-B - sqrt(B^2 - 4*A*C)) / (2*A);
% 
% y1 = (a * (-B + sqrt(B^2 - 4*A*C)) / (2*A)) + b;
% y2 = (a * (-B - sqrt(B^2 - 4*A*C)) / (2*A)) + b;

getIntersectionCircleLine(xc,yc, r, [5,5,25,20])

