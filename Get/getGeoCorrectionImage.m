function [finalImage, minIntensity, maxIntensity] = getGeoCorrectionImage(image, displayType)
    % determine the image to display in the geometry correction for
    % cylinders (BA)
    
    switch (displayType)
        case 'radiobuttonIntensityValue'
            minIntensity = 0;
            maxIntensity = max(max(image));
            finalImage = image;
        case 'radiobuttonTransmissionPercent'
            maxIntensity = max(max(image));
            finalImage = (image ./ maxIntensity) .* 100;
            maxIntensity = 100;
            minIntensity = 0;
        case 'radiobuttonAttenuation'
%             minIntensity = 0;
%             maxIntensity = max(max(image));
%             transmission = image ./ maxIntensity;
%             image = -log10(transmission);
%             maxIntensity = max(max(image));
%             finalImage = image ./ maxIntensity;
%             maxIntensity = max(max(finalImage));
               minIntensity = 0;
               maxIntensity = max(image(:));
               tmp_image_01 = image./maxIntensity;
               finalImage = 1-tmp_image_01;
               maxIntensity = 1;
        case 'radiobuttonTransmissionIntensity'
            minIntensity = 0;
            maxIntensity = max(max(image));
            finalImage = (image ./ maxIntensity);
            maxIntensity = 1;
        otherwise
    end
    
end