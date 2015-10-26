function updateBAgeoCorrection(hObject, forceRefresh)
    % this update may takes a while, so display PROCESSING MESSAGE
    
    if nargin<2
        forceRefresh = false;
    end
    
    handles = guidata(hObject);
    if forceRefresh
        update = true;
    else
        if get(handles.radiobuttonBAgeoCorrectionAutoRefresh,'value')
            update = true;
        else
            update = false;
        end
    end
    
    if update
        
        finalImage = getFinalImageGeoCorrection(hObject);
        
        handles = guidata(hObject);
        
        display_type = getDisplayType(handles);
        [finalImage, minIntensity, maxIntensity] = getGeoCorrectionImage(finalImage, display_type);
        
        if ~isempty(finalImage)
            colormap(handles.colormap);
            imagesc(finalImage,[minIntensity, maxIntensity]);
            colorbar;
        end
        
    end
end


