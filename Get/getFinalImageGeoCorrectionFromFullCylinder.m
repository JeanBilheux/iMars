function finalImage = getFinalImageGeoCorrectionFromFullCylinder(hObject, ...
        finalImage)
    % Apply geometry correcton to a full cylinder
    
    handles = guidata(hObject);
    
    axes(handles.axesBAgeoCorrectionPreview);
    
    cylinderX1Y1X2Y2 = handles.cylinderX1Y1X2Y2;
    tmpCylinderCord = num2cell(cylinderX1Y1X2Y2);
    [x1,y1,x2,y2] = tmpCylinderCord{:};
    
    % get the equation of the two edges (perpendicular to this line at
    % the two points defined)
    [a1,b1] = getPerpendicularEquation(cylinderX1Y1X2Y2,[x1,y1]);
    [a2,b2] = getPerpendicularEquation(cylinderX1Y1X2Y2,[x2,y2]);
    
    % we gonna loop inside the region selected (if any), otherwise
    % we will have through the entire image
    calculationRegion = handles.calculationRegion;
    if isempty(calculationRegion)
        [height, width] = size(finalImage);
        xmin = 1;
        xmax = width;
        ymin = 1;
        ymax = height;
    else
        tmpCalculation = num2cell(calculationRegion);
        [xc1,yc1,xc2,yc2] = tmpCalculation{:};
        xmin = fix(min([xc1,xc2]));
        xmax = fix(max([xc1,xc2]));
        ymin = fix(min([yc1,yc2]));
        ymax = fix(max([yc1,yc2]));
        
    end
    
    if isinf(a1) % selection is perfectly vertical
        
        xmin = fix(min([x1,x2]));
        xmax = fix(max([x1,x2]));
        
        r = (xmax-xmin)/2.;
        center = (xmax+xmin)/2.;
        index = 1;
        %             coeffValue = zeros(2,xmax-xmin);
        
        if isempty(calculationRegion)
            
            for x=xmin:xmax
                a = center - x;
                coeff = real(2.*sqrt(r^2-a^2));
                %                 coeffValue(1,index) = coeff;
                %                 coeffValue(2,index) = finalImage(1300,x);
                index=index+1;
                if coeff > 0.
                    finalImage(:,x) = finalImage(:,x) * coeff;
                end
            end
            
        else
            
            for x=xmin:xmax
                for y=ymin:ymax
                    a = center - x;
                    coeff = real(2.*sqrt(r^2-a^2));
                    %                 coeffValue(1,index) = coeff;
                    %                 coeffValue(2,index) = finalImage(1300,x);
                    index=index+1;
                    if coeff > 0.
                        finalImage(y,x) = finalImage(y,x) * coeff;
                    end
                end
            end
            
        end
        
    else % cylinder selected is not perfectly vertical
        
        lastString = get(handles.saveSessionMessageTag,'String');
        set(handles.saveSessionMessageTag,'String',{'PROCESSING CALCULATION ...','','Please Be Patient!'});
        set(handles.saveSessionMessageTag,'visible','on');
        drawnow update;
        
        fct1 = @(x) a1*x+b1;
        fct2 = @(x) a2*x+b2;
        
        for x=xmin:xmax
            for y=ymin:ymax
                if a1 < 0
                    if (y >= fct1(x)) && (y<= fct2(x)) % this point is inside
                        
                        % calculate the distance of point to the center of the
                        % cylinder
                        [a,r] = getDistancePointToRadius(a1,b1,a2,b2,x,y);
                        coeff = real(2.*sqrt(abs(r^2-a^2)));
                        if coeff > 0
                            finalImage(y,x) = finalImage(y,x) * coeff;
                        end
                    end
                else % a1>0
                    if (y <= fct1(x)) && (y>= fct2(x)) % this point is inside
                        
                        % calculate the distance of point to the center of the
                        % cylinder
                        [a,r] = getDistancePointToRadius(a1,b1,a2,b2,x,y);
                        coeff = real(2.*sqrt(abs(r^2-a^2)));
                        if coeff > 0
                            finalImage(y,x) = finalImage(y,x) * coeff;
                        end
                    end
                end
            end
        end
        
        set(handles.saveSessionMessageTag,'visible','off');
        set(handles.saveSessionMessageTag,'String',lastString);
        drawnow update;
        
    end
end

