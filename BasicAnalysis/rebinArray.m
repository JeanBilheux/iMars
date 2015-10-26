function [rebinProfileArray, rebin_x_ellipse, rebin_y_ellipse] = rebinArray(profileArray, ...
        x_ellipse, y_ellipse, binSize)
    % this function will rebin the array (linear rebin) using
    % the binSize
    
    sz = numel(profileArray);
    rebinProfileArray = zeros(1,floor(sz/binSize));
    rebin_x_ellipse = zeros(1,floor(sz/binSize));
    rebin_y_ellipse = zeros(1,floor(sz/binSize));
    index = 1;
    for k1=1:binSize:(sz-binSize)
        tmp_array = profileArray(k1:k1+binSize);
        rebinProfileArray(index) = mean(tmp_array);
        
        tmp_x = x_ellipse(k1:k1+binSize);
        rebin_x_ellipse(index) = mean(tmp_x);
        
        tmp_y = y_ellipse(k1:k1+binSize);
        rebin_y_ellipse(index) = mean(tmp_y);
        
        index = index+1;
    end
    
end