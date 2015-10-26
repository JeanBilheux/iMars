function [profileArray, x_ellipse, y_ellipse] = getEllipseProfile(image, x0, y0, width, height, precision)
    % this function will calculate the profile along the ellipse
    % of the given image
  
    [x_ellipse, y_ellipse] = getEllipseContour(x0, y0, ...
        width, height, ...
        precision);
  
    % create [number_point, 2] y,x array
    sz = numel(x_ellipse);
    profileArray = zeros(1,sz);
    for k=1:sz
        tmp_x = x_ellipse(k);
        tmp_y = y_ellipse(k);
        profileArray(k) = image(tmp_y, tmp_x);
    end
    
%     % rebin the array and return results
%     rebinCoefficient = 2; %group 2 by 2 the data
%     [profileArray, x_ellipse, y_ellipse] = rebinArray(profileArray, ...
%         x_ellipse, y_ellipse, ...
%         rebinCoefficient);

end