function imageDomainSelected = getImageDomainSelected(hObject)
    
    handles = guidata(hObject);
    
   if get(handles.radiobuttonIntensityValue,'value')
       imageDomainSelected = 'Intensity values';
       return
   end
   
   if get(handles.radiobuttonTransmissionPercent,'value')
       imageDomainSelected = 'Transmission %';
       return
   end
   
   if get(handles.radiobuttonAttenuation,'value')
       imageDomainSelected = 'Attenuation [0 1]';
       return
   end
   
   imageDomainSelected = 'Transmission [0 1]';
    
end