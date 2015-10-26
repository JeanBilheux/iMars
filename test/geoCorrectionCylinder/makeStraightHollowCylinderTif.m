% tmp script to create a 500 by 500 images with a perfect test case
% to test the geometry cylinder correction
% just like an real image, the thicker the object, the darker
% The outside edge will have a radius of 150 and the inside edge will have
% a radius of 100

outer_image = NaN(1,500);
inner_image = NaN(1,500);

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


%% the rest of the script here is to test if the file created is right
% now we gonna correct for the cylinder shape effect

% reading the tiff
imageRaw = fitsread('verticalHollowCylinder.fits');
correctedImageRaw = NaN(size(imageRaw));

plotNbrRow = 2;
plotNbrCol = 5;

% display image read
figure(2);
sub1=subplot(plotNbrRow,plotNbrCol,1);
imagesc(imageRaw);
colorbar;
title(sub1,'after read raw fits file','fontsize',14);

sub2=subplot(plotNbrRow,plotNbrCol,6);
plot(imageRaw);

% apply geometry correction

% start with part bewtween outer_radius -> inner_radius (left part)
for x=(center-outer_radius):(center-inner_radius-1)
    a=center-x;
    coeff = 2.* sqrt(outer_radius^2 - a^2);
    imageRaw(:,x) = imageRaw(:,x) * coeff;
end

sub3=subplot(plotNbrRow,plotNbrCol,2);
imagesc(log(imageRaw));
colorbar;
title(sub3,'First correction applied','fontsize',14);
sub4=subplot(plotNbrRow,plotNbrCol,7);
semilogy(imageRaw);

% working on the right side now inner_radius -> outer_radius (right part)
for x=(center+inner_radius+1):(center+outer_radius)
    a=x-center;
    coeff = 2.*sqrt(outer_radius^2 - a^2);
    imageRaw(:,x) = imageRaw(:,x) * coeff;
end

sub5=subplot(plotNbrRow,plotNbrCol,3);
imagesc(log(imageRaw));
colorbar;
title(sub3,'Last correction applied','fontsize',14);
sub6=subplot(plotNbrRow,plotNbrCol,8);
semilogy(imageRaw);

% working on the inside left side (inner_radius -> center)
for x=(center-inner_radius):center
    a=center-x;
    coeff_inner = 2.*sqrt(inner_radius^2 - a^2);
    coeff_outer = 2.*sqrt(outer_radius^2 - a^2);
    coeff = coeff_outer - coeff_inner;
    imageRaw(:,x) = imageRaw(:,x) * coeff;
end

sub5=subplot(plotNbrRow,plotNbrCol,4);
imagesc(log(imageRaw));
colorbar;
title(sub3,'2nd left correction applied','fontsize',14);
sub6=subplot(plotNbrRow,plotNbrCol,9);
semilogy(imageRaw);

% working on the inside right part (center -> inner_radius)
for x=center+1:center+inner_radius
    a=x-center;
    coeff_inner = 2.*sqrt(inner_radius^2 - a^2);
    coeff_outer = 2.*sqrt(outer_radius^2 - a^2);
    coeff = coeff_outer - coeff_inner;
    imageRaw(:,x) = imageRaw(:,x) * coeff;
end

sub5=subplot(plotNbrRow,plotNbrCol,5);
imagesc(log(imageRaw));
colorbar;
title(sub3,'3rd right correction applied','fontsize',14);
sub6=subplot(plotNbrRow,plotNbrCol,10);
semilogy(imageRaw);



















