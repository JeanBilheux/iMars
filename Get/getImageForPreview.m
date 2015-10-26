function image = getImageForPreview(hObject, tmp_image, sourceType, bSaveMax)
    %Determine the final image according to the selection made in the
    %Image Type Domain
    %sourceType: ['data','openBeam','darkField']
    
    if nargin < 4
        bSaveMax = true;
    end
    
    handles = guidata(hObject);
    
    display_type = getDisplayType(handles);
    
    %globalMaxIntensity = handles.files.globalMaxIntensity;
    
    switch (display_type)
        case 'radiobuttonIntensityValue'
            image = tmp_image;
            minIntensity = 0;
            %        maxIntensity = globalMaxIntensity;
            maxIntensity = max(max(image));
        case 'radiobuttonTransmissionPercent'
            minIntensity = 0;
            %        maxIntensity = globalMaxIntensity;
            maxIntensity = max(max(tmp_image));
            image = (tmp_image ./ maxIntensity) .* 100;
            maxIntensity = 100;
        case 'radiobuttonAttenuation'
%             minIntensity = 0;
%             %         maxIntensity = handles.files.globalMaxIntensity;
%             maxIntensity = max(max(tmp_image));
%             transmission = (tmp_image ./ maxIntensity);
%             image = -log10(transmission);
%             maxIntensity = max(max(image));
%             image = image ./ maxIntensity;
%             maxIntensity = max(max(image));
              maxIntensity = max(tmp_image(:));
              tmp_image_01 = tmp_image ./ maxIntensity;
              image = 1-tmp_image_01;
              minIntensity = 0;
              maxIntensity = 1;
        case 'radiobuttonTransmissionIntensity'
            minIntensity = 0;
            %        maxIntensity = handles.files.globalMaxIntensity;
            maxIntensity = max(max(tmp_image));
            image = (tmp_image ./ maxIntensity);
            maxIntensity = 1;
    end
    
    if bSaveMax
        
        switch sourceType
            case 'data'
                handles.files.minIntensity = minIntensity;
                handles.files.maxIntensity = maxIntensity;
            case 'openBeam'
                handles.obfiles.minIntensity = minIntensity;
                handles.obfiles.maxIntensity = maxIntensity;
            case 'darkField'
                handles.dffiles.minIntensity = minIntensity;
                handles.dffiles.maxIntensity = maxIntensity;
        end
        
    end
        
    guidata(hObject, handles);
    
    % check if we want linear or log plot
    if ~isScaleLinear(handles)
        image = -log(image);
    end
    
end