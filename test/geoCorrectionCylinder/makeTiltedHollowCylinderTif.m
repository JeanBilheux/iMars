% tmp script to create a 500 by 500 images with a perfect test case
% to test the geometry cylinder correction
% just like an real image, the thicker the object, the darker
% The outside edge will have a radius of 150 and the inside edge will have
% a radius of 100

outer_image = NaN(500,500);
inner_image = NaN(500,500);

cylinderCenter = 250;
center = cylinderCenter;
outer_radius = 150;

coeff_array = zeros(500 );
% outside cylinder
for x=cylinderCenter:-1:(cylinderCenter-outer_radius)
    a = cylinderCenter-x;
    coeff = (2*sqrt(outer_radius^2-a^2));
    if coeff > 0
        outer_image(:,x) = 1 / coeff;
        coeff_array(x) = coeff;
    end
end

for x=(cylinderCenter+1):(cylinderCenter+outer_radius)
    a = x-cylinderCenter;
    coeff = (2*sqrt(outer_radius^2-a^2));
    if coeff > 0
        outer_image(:,x) = 1 / coeff;
        coeff_array(x) = coeff;
    end
end

% preview
figure(1);
sub1=subplot(3,2,1);
imagesc(outer_image);
colorbar;
title(sub1,'With only outer cylinder','fontsize',14);

sub2=subplot(3,2,2);
plot(coeff_array);
title(sub2,'coeff plot','fontsize',14);

%% inside cylinder only
coeff_array_2 = zeros(500 );
inner_radius = 100;
for x=cylinderCenter:-1:(cylinderCenter-inner_radius)
    a = cylinderCenter-x;
    coeff = (2*sqrt(inner_radius^2-a^2));
    if coeff > 0
        inner_image(:,x) = 1 / coeff;
        coeff_array_2(x) = coeff;
    end
end

for x=(cylinderCenter+1):(cylinderCenter+inner_radius)
    a = x-cylinderCenter;
    coeff = (2*sqrt(inner_radius^2-a^2));
    if coeff > 0
        inner_image(:,x) = 1 / coeff;
        coeff_array_2(x) = coeff;
    end
end

sub3=subplot(3,2,3);
imagesc(inner_image);
colorbar;
title(sub3,'With only inner cylinder','fontsize',14);

sub4=subplot(3,2,4);
plot(coeff_array_2);
title(sub4,'Coeff plot','fontsize',14);


%% outer and inner
% inside cylinder
inner_radius = 100;
coeff_array_3 = coeff_array;
outer_inner_image = outer_image;
for x=cylinderCenter:-1:(cylinderCenter-inner_radius)
    a = cylinderCenter-x;
    coeff_inner = (2*sqrt(inner_radius^2-a^2));
    coeff_outer = (2*sqrt(outer_radius^2-a^2));
    coeff = (coeff_outer - coeff_inner);
    if coeff > 0
        outer_inner_image(:,x) = 1 / coeff;
        coeff_array_3(x) = coeff;
    end
    %     fprintf('x=%d\ta=%d\t coeff=%d\n',x,a,coeff);
end

for x=(cylinderCenter+1):(cylinderCenter+inner_radius)
    a = x-cylinderCenter;
    coeff_inner = (2*sqrt(inner_radius^2-a^2));
    coeff_outer = (2*sqrt(outer_radius^2-a^2));
    coeff = (coeff_outer - coeff_inner);
    if coeff > 0
        outer_inner_image(:,x) = 1 / coeff;
        coeff_array_3(x) = coeff;
    end
end

sub5=subplot(3,2,5);
image = outer_inner_image;
imagesc(image);
colorbar;
title(sub5,'Outer and Inner cylinders','fontsize',14);

sub6=subplot(3,2,6);
plot(coeff_array_3);
title(sub6,'coeff plot','fontsize',14);

%% create the tiff;
fitswrite(image,'verticalHollowCylinder.fits');
imageRaw = fitsread('verticalHollowCylinder.fits');

rotImageRaw = imrotate(imageRaw,15,'bilinear','crop');
figure(2);
subplot(1,3,1);
imagesc(imageRaw);
colorbar;
subplot(1,3,2);
imagesc(rotImageRaw);
colorbar;
fitswrite(rotImageRaw,'tiltedHollowCylinder.fits');

rotImageRaw = imrotate(imageRaw,-20,'bilinear','crop');
subplot(1,3,3);
imagesc(rotImageRaw);
colorbar;
fitswrite(rotImageRaw,'tilted2HollowCylinder.fits');
