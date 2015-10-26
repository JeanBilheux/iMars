function switchImageDomainToIntensityMode(hObject)
    
    %switch Image Domain to Intensity values
    setImageDomain(hObject, 'off');
    
    handles = guidata(hObject);
    display_type = getDisplayType(handles);
    if strcmp(display_type,'radiobuttonIntensityValue')
        handles.previousImageDomain = '';
    else
        handles.previousImageDomain = display_type;
        guidata(hObject, handles);
        switchImageDomain(hObject, ...
            'radiobuttonIntensityValue');
        m_recalculateImageToDisplay(hObject, 'data');
    end
    
end