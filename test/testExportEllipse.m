% load('testExportEllipse.mat');
precision = 0.01;
[x_ellipse, y_ellipse] = getEllipseContour(48,164,164,164,precision);

sz = numel(x_ellipse);
profileArray = zeros(1,sz);
for k=1:sz
    tmp_x = x_ellipse(k);
    tmp_y = y_ellipse(k);
    profileArray(k) = data(tmp_y, tmp_x);
end

rebinCoefficient = 2;
[profileArray, x_ellipse_after, y_ellipse_after] = rebinArray(profileArray, ...
    x_ellipse, y_ellipse, ...
    rebinCoefficient);

% plot
figure(1);
sub1=subplot(1,2,1);
plot(x_ellipse, y_ellipse, 'LineStyle','none','marker','*');
title(sub1,'Before rebin');

sub2 = subplot(1,2,2);
plot(x_ellipse_after, y_ellipse_after, 'LineStyle','none','marker','+');
title(sub2, 'After rebin');

% figure(2);
% nbr = numel(x_ellipse);
% x1 = x_ellipse(1:fix(nbr/2));
% x2 = x_ellipse(fix(nbr/2):nbr);
% 
% y1 = y_ellipse(1:fix(nbr/2));
% y2 = y_ellipse(fix(nbr/2):nbr);
% 
% plot(x1,y1,'Linestyle','none','marker','+','color','red');
% hold on;
% plot(x2,y2,'Linestyle','none', 'marker','.','color','blue');