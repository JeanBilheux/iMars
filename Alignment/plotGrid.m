function plotGrid(handles, image)
    
    [szY, szX] = size(image);
    
    nbrLines = 10;
    
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
    
    axes(handles.axesAlignment);
    
    xmin = 0;
    ymin = 0;
    xmax = szX;
    ymax = szY;
    
    colorArray = {'red','white','yellow','blue','green'};
    indexColor = 1;
    
    %vertical lines
    for j=1:numel(xTicks)
        
        x1 = xTicks(j);
        x2 = xTicks(j);
        
        y1 = ymin;
        y2 = ymax;
        
        tmpColor = colorArray{indexColor};
        indexColor = indexColor+1;
        if indexColor > numel(colorArray)
            indexColor = 1;
        end
        
        line([x1 x2], [y1 y2], 'color', tmpColor, 'lineStyle', ':');
        
    end
    
    %horizontal lines
    for k=1:numel(yTicks)
        
        x1 = xmin;
        x2 = xmax;
        
        y1 = yTicks(k);
        y2 = yTicks(k);
        
        tmpColor = colorArray{indexColor};
        indexColor = indexColor+1;
        if indexColor > numel(colorArray)
            indexColor = 1;
        end
        line([x1 x2], [y1 y2], 'color', tmpColor, 'linestyle', ':');
    end
    
end