function autoRotateData(hObject, deltaAngle)
   %will add this value to the rotation angle
   
   handles = guidata(hObject);
   data = handles.rawdata;
   
   axes(handles.axesRotateImage);
   
   angleBefore = get(handles.editAngleToRotate,'string');
   angleBefore = str2num(angleBefore);
   
   angleAfter = angleBefore + str2num(deltaAngle);
   dataRotated = imrotate(data, angleAfter);
   
   imagesc(dataRotated);
   plotGrid(hObject);
    
   str = sprintf('%0.2f',angleAfter);
   set(handles.editAngleToRotate,'string', str);
   
end
