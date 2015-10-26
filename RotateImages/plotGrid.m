function plotGrid(hObject)
   %will display a grid to help in the visual orientation of the data
    
    handles = guidata(hObject);
    
    data = handles.rawdata;
    [szY, szX] = size(data);

    nbrLines = 20;
    
    deltaX = szX/(nbrLines+1);
    deltaY = szY/(nbrLines+1);
    
    xTicks = zeros(1,nbrLines);
    yTicks = zeros(1,nbrLines);
    
    offsetX = 0;
    offsetY = 0;
    
    for i=1:(nbrLines)
       xTicks(i) = offsetX + deltaX;
       yTicks(i) = offsetY + deltaY;
       
       offsetX = offsetX + deltaX;
       offsetY = offsetY + deltaY;
    end
    
    axes(handles.axesRotateImage);
    
    xmin = 0;
    ymin = 0;
    xmax = szX;
    ymax = szY;
    
    %vertical lines
    for j=1:numel(xTicks)

        x1 = xTicks(j);
        x2 = xTicks(j);
         
        y1 = ymin;
        y2 = ymax;
        
        line([x1 x2],[y1 y2],'color','red');

    end

    %horizontal lines
    for k=1:numel(yTicks)
        
        x1 = xmin;
        x2 = xmax;
        
        y1 = yTicks(k);
        y2 = yTicks(k);
        
        line([x1 x2],[y1 y2],'color','red');
    end
    
end