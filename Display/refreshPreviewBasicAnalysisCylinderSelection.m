function refreshPreviewBasicAnalysisCylinderSelection(hObject)
    % refresh the preview of the cylinder selection when the Basic analysis
    % geo correction is selected
    
    handles = guidata(hObject);
    
    image = handles.currentImagePreviewed;
    [imageWidth, ~] = size(image);
    
    cylinderX1Y1X2Y2 = handles.cylinderX1Y1X2Y2;
    % no preview to display if there is no selection made
    if isempty(cylinderX1Y1X2Y2)
        set(handles.textBAgeoCorrectionRadius,'string','N/A');
        set(handles.textBAgeoCorrectionRadius2,'string','N/A');
        return;
    end
    
    radius = getCylinderRadius(cylinderX1Y1X2Y2);
    str = sprintf('%d',radius);
    set(handles.textBAgeoCorrectionRadius,'string',str);
    
    % activate axes
    axes(handles.axesPreview);
    
    cylinderXY = num2cell(cylinderX1Y1X2Y2);
    [x1,y1,x2,y2] = cylinderXY{:};
    
    line([x1,x2],[y1,y2],'color','red');
    
    [a1,b1] = getPerpendicularEquation([x1,y1,x2,y2],[x1,y1]);
    [a2,b2] = getPerpendicularEquation([x1,y1,x2,y2],[x2,y2]);
    
    if ~isinf(a1)
        
        [x1_per_1, y1_per_1, x2_per_1, y2_per_1] = getLineExtremities(a1,b1, imageWidth);
        [x1_per_2, y1_per_2, x2_per_2, y2_per_2] = getLineExtremities(a2,b2, imageWidth);
        
    else
        
        x1_per_1 = x1;
        x2_per_1 = x1;
        y1_per_1 = 0;
        y2_per_1 = 2500;
        
        x1_per_2 = x2;
        x2_per_2 = x2;
        y1_per_2 = 0;
        y2_per_2 = 2500;
        
    end
    
    line([x1_per_1 x2_per_1],[y1_per_1 y2_per_1], 'color','red');
    line([x1_per_2 x2_per_2],[y1_per_2 y2_per_2], 'color','red');
    
    secondCylinderX1Y1X2Y2 = handles.secondCylinderX1Y1X2Y2;
    if isempty(secondCylinderX1Y1X2Y2)
        set(handles.textBAgeoCorrectionRadius2,'string','N/A');
    else
        
        radius = getCylinderRadius(secondCylinderX1Y1X2Y2);
        str = sprintf('%d',radius);
        set(handles.textBAgeoCorrectionRadius2,'string',str);
        
        cylinderXY = num2cell(secondCylinderX1Y1X2Y2);
        [x1,y1,x2,y2] = cylinderXY{:};
        
        line([x1,x2],[y1,y2],'color','blue');
        
        [a1,b1] = getPerpendicularEquation([x1,y1,x2,y2],[x1,y1]);
        [a2,b2] = getPerpendicularEquation([x1,y1,x2,y2],[x2,y2]);
        
        if ~isinf(a1)
            
            [x1_per_1, y1_per_1, x2_per_1, y2_per_1] = getLineExtremities(a1,b1, imageWidth);
            [x1_per_2, y1_per_2, x2_per_2, y2_per_2] = getLineExtremities(a2,b2, imageWidth);
            
        else
            
            x1_per_1 = x1;
            x2_per_1 = x1;
            y1_per_1 = 0;
            y2_per_1 = 2500;
            
            x1_per_2 = x2;
            x2_per_2 = x2;
            y1_per_2 = 0;
            y2_per_2 = 2500;
            
        end
        
        line([x1_per_1 x2_per_1],[y1_per_1 y2_per_1], 'color','blue');
        line([x1_per_2 x2_per_2],[y1_per_2 y2_per_2], 'color','blue');
        
    end
    
    % display calculation region (if any)
    calculationRegion = handles.calculationRegion;
    if ~isempty(calculationRegion)
        
        tmpRegion = num2cell(calculationRegion);
        [x1,y1,x2,y2] = tmpRegion{:};
        
        w = abs(x1-x2);
        h = abs(y1-y2);
        
        if w > 0 && h > 0
            
            rectangle('position',[x1 y1 w h], ...
                'lineWidth', 1, ...
                'edgeColor', 'red', ...
                'lineStyle', ':');
            
        end
        
    end
    
end