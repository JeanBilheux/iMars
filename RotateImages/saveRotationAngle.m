function saveRotationAngle(hObject)
    % save angle of rotation
    
    handles = guidata(hObject);
    mainhObject = handles.mainhObject;
    
    mainHandles = guidata(mainhObject);
    
    angleBefore = get(handles.editAngleToRotate,'string');
    angleBefore = str2double(angleBefore);
    mainHandles.rotationAngle = angleBefore;
    guidata(mainhObject, mainHandles);
    
end