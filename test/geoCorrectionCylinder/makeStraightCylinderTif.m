% tmp script to create a 500 by 500 images with a perfect test case 
% to test the geometry cylinder correction
% just like an real image, the thicker the object, the darker

image = zeros(10,500);

cylinderCenter = 250;
radius = 100;

for x=cylinderCenter:-1:(cylinderCenter-radius)
    a = cylinderCenter-x;
    image(:,x) = 2*sqrt(radius^2-a^2);
end

for x=cylinderCenter:(cylinderCenter+radius)
    a = x-cylinderCenter;
    image(:,x) = 2*sqrt(radius^2-a^2);
end

%% 
figure(1);
imagesc(image);
colorbar;

% create the tiff;
fitswrite(image,'verticalCylinder.fits'); 

%% now we gonna correct for the cylinder shape effect

%% reading the tiff
imageRaw = fitsread('verticalCylinder.fits');

figure(2);
imagesc(imageRaw);
colorbar;
title('after read raw fits file');

radius = 100;
center = 250;

for x=(center-radius):(center+radius)
    
    a = center - x;
    coeff = 2.*sqrt(radius^2-a^2);
    imageRaw(:,x) = imageRaw(:,x) / coeff;
    
end

figure(3);
imagesc(imageRaw);
colorbar;
title('after geometry correction');

%% =========
% now if we create directly an attenuated image

image = zeros(10,500) + 1. ;

cylinderCenter = 250;
radius = 100;

for x=cylinderCenter:-1:(cylinderCenter-radius)
    a = cylinderCenter-x;
    coeff = 2*sqrt(radius^2-a^2);
    if coeff > 0
    image(:,x) = image(:,x) / coeff;
    end
end

for x=cylinderCenter:(cylinderCenter+radius)
    a = x-cylinderCenter;
    coeff = 2*sqrt(radius^2-a^2);
    if coeff >0
    image(:,x) = image(:,x) / coeff;
    end
    end

figure(4);
imagesc(image);
colorbar;
