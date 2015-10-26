function recordCylindricalPostion(hObject, cylinderX1Y1X2Y2, ...
        secondCylinderX1Y1X2Y2, ...
        calculationRegion)
    % will save the defined cylindrical shape position and will
    % display the radius information
    
    handles = guidata(hObject);
    handles.cylinderX1Y1X2Y2 = cylinderX1Y1X2Y2;
    handles.secondCylinderX1Y1X2Y2 = secondCylinderX1Y1X2Y2;
    handles.calculationRegion = calculationRegion;
    guidata(hObject, handles);
    
    % display radius of cylinder
    if ~isempty(cylinderX1Y1X2Y2)
        radius = getCylinderRadius(cylinderX1Y1X2Y2);
        str = sprintf('%d',radius);
    else
        str = 'N/A';
    end
    set(handles.textBAgeoCorrectionRadius,'string',str);
    
    if ~isempty(secondCylinderX1Y1X2Y2)
        radius = getCylinderRadius(secondCylinderX1Y1X2Y2);
        str = sprintf('%d',radius);
    else
        str = 'N/A';
    end
    set(handles.textBAgeoCorrectionRadius2,'string',str);
    
    % refresh the plot using the new cylinder defined    
    m_refreshPreviewImage(hObject);
    refreshPreviewBasicAnalysisCylinderSelection(hObject);
    
end