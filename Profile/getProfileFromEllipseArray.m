function profileArray = getProfileFromEllipseArray(image, ellipseSettings)
% This function will determine the profile along the ellipse define in
% ellipseSettings [x,y,w,h]

x = ellipseSettings(1);
y = ellipseSettings(2);
w = ellipseSettings(3);
h = ellipseSettings(4);

% let's keep only the data that have their pixels on the ellipse contour
[imageH, imageW] = size(image);
roiLogicalArray = zeros(imageH, imageW);
logicalArray = getLogicalArrayOfEllipse(roiLogicalArray, [x,y,w,h]);

% we need to split the array in half
% ellipse left
xLeft = x;
yLeft = y;
wLeft = w/2;
hLeft = h;

% ellipse right
xRight = x+w/2;
yRight = y;
wRight = w/2;
hRight = h;

profileArray = [];

end


