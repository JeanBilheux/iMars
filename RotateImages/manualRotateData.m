function manualRotateData(hObject, angle)
   
    handles = guidata(hObject);
   
    data = handles.rawdata;
    
    axes(handles.axesRotateImage);
    
    dataRotated = imrotate(data, angle);
    
    imagesc(dataRotated);
    
    plotGrid(hObject);
    
end