function finalImage = getFinalImageGeoCorrectionFromHollowCylinder(hObject, ...
        finalImage)
    % Apply geometry correcton to a full cylinder
    
    try
        
        handles = guidata(hObject);
        
        axes(handles.axesBAgeoCorrectionPreview);
        
        cylinderX1Y1X2Y2 = handles.cylinderX1Y1X2Y2;
        tmpCylinderCord = num2cell(cylinderX1Y1X2Y2);
        [x1,y1,x2,y2] = tmpCylinderCord{:};
        
        secondCylinderX1Y1X2Y2 = handles.secondCylinderX1Y1X2Y2;
        tmpSecondCylinder = num2cell(secondCylinderX1Y1X2Y2);
        [x1s,y1s,x2s,y2s] = tmpSecondCylinder{:};
        
        % determine which cylinder is inside
        xmin = min([x1,x2]);
        xmins = min([x1s,x2s]);
        
        % make sure that cylinderX1Y1X2Y2 refers to the outside cylinder
        % and the secondCylinderX1Y1X2Y2 refers to the inside cylinder
        if xmin > xmins
            
            tmpCylinderX1Y1X2Y2 = cylinderX1Y1X2Y2;
            cylinderX1Y1X2Y2 = secondCylinderX1Y1X2Y2;
            secondCylinderX1Y1X2Y2 = tmpCylinderX1Y1X2Y2;
            
            % inverse x,y ... of cylinders
            tmpCylinderCord = num2cell(cylinderX1Y1X2Y2);
            [x1,y1,x2,y2] = tmpCylinderCord{:};

            tmpSecondCylinder = num2cell(secondCylinderX1Y1X2Y2);
            [x1s,y1s,x2s,y2s] = tmpSecondCylinder{:};

        end
                
        % get the equation of the two edges (perpendicular to this line at
        % the two points defined)
        [a1,b1] = getPerpendicularEquation(cylinderX1Y1X2Y2,[x1,y1]);
        [a2,b2] = getPerpendicularEquation(cylinderX1Y1X2Y2,[x2,y2]);
%         [a1s,b1s] = getPerpendicularEquation(secondCylinderX1Y1X2Y2,[x1s,y1s]);
%         [a2s,b2s] = getPerpendicularEquation(secondCylinderX1Y1X2Y2,[x2s,y2s]);
        
        % we gonna loop inside the region selected (if any), otherwise
        % we will have to go through the entire image
        calculationRegion = handles.calculationRegion;
        if isempty(calculationRegion)
            [height, width] = size(finalImage);
            xminc = 1;
            xmaxc = width;
            yminc = 1;
            ymaxc = height;
        else
            tmpCalculation = num2cell(calculationRegion);
            [xc1,yc1,xc2,yc2] = tmpCalculation{:};
            xminc = fix(min([xc1,xc2]));
            xmaxc = fix(max([xc1,xc2]));
            yminc = fix(min([yc1,yc2]));
            ymaxc = fix(max([yc1,yc2]));
            if yminc < 1
                yminc = 1;
            end
        end
        
        if isinf(a1) % selection is perfectly vertical
            
            xmin = fix(min([x1,x2]));
            xmax = fix(max([x1,x2]));
            r = (xmax-xmin)/2.;
            center = fix((xmax+xmin)/2.);
            
            xmins = fix(min([x1s,x2s]));
            xmaxs = fix(max([x1s,x2s]));
            rs = (xmaxs-xmins)/2.;
            
            % start with part between outer_radius -> inner_radius (left
            % part)
            for x=xmin:(xmins-1)
                a = center - x;
                coeff = 2. * sqrt(r^2-a^2);
                finalImage(yminc:ymaxc,x) = finalImage(yminc:ymaxc,x) * coeff;
            end
            
            % right part (outer_radius -> inner_radius)
            for x=xmaxs+1:xmax
                a = x-center;
                coeff = 2. * sqrt(r^2-a^2);
                finalImage(yminc:ymaxc,x) = finalImage(yminc:ymaxc,x) * coeff;
            end
            
            % central left part (both cylinders affect the result)
            for x=xmins:center
                a = center - x;
                coeff_outer = 2. * sqrt(r^2-a^2);
                coeff_inner = 2. * sqrt(rs^2-a^2);
                coeff = coeff_outer - coeff_inner;
                finalImage(yminc:ymaxc,x) = finalImage(yminc:ymaxc,x) * coeff;
            end
            
            % central right part (both cylinders affect the result)
            for x=center+1:xmaxs
                a = x-center;
                coeff_outer = 2. * sqrt(r^2-a^2);
                coeff_inner = 2. * sqrt(rs^2-a^2);
                coeff = coeff_outer - coeff_inner;
                finalImage(yminc:ymaxc,x) = finalImage(yminc:ymaxc,x) * coeff;
            end
            
        else % cylinder selected is not perfectly vertical
            
            lastString = get(handles.saveSessionMessageTag,'String');
            set(handles.saveSessionMessageTag,'String',{'PROCESSING CALCULATION ...','','Please Be Patient!'});
            set(handles.saveSessionMessageTag,'visible','on');
            drawnow update;
            
            fct1 = @(x) a1*x+b1;
            fct2 = @(x) a2*x+b2;
            
            r = getDistancePointToPoint(x1,y1,x2,y2)/2.;
            rs = getDistancePointToPoint(x1s,y1s,x2s,y2s)/2.;
            
            %         fct1s = @(x) a1s*x+b1s;
            %         fct2s = @(x) a2s*x+b2s;
            
            for x=xminc:xmaxc
                for y=yminc:ymaxc
                    if a1 < 0
                        if (y >= fct1(x)) && (y<= fct2(x)) % this point is inside
                            
                            % calculate the distance of point to the center of the
                            % cylinder
                            [a,~] = getDistancePointToRadius(a1,b1,a2,b2,x,y);
                            coeff = real(2.*sqrt(abs(r^2-a^2)));
                            %                         [~,] = getDistancePointToRadius(a1s,b1s,a2s,b2s,x,y);
                            if a>rs
                                finalCoeff = coeff;
                            else
                                coeffs = real(2.*sqrt(abs(rs^2-a^2)));
                                finalCoeff = coeff - coeffs;
                            end
                            if finalCoeff > 0
                                finalImage(y,x) = finalImage(y,x) * finalCoeff;
                            end
                        end
                        
                    else % a1 > 0
                        
                        if (y <= fct1(x)) && (y>= fct2(x)) % this point is inside
                            
                            % calculate the distance of point to the center of the
                            % cylinder
                            [a,~] = getDistancePointToRadius(a1,b1,a2,b2,x,y);
                            coeff = real(2.*sqrt(abs(r^2-a^2)));
                            %                         [as,rs] = getDistancePointToRadius(a1s,b1s,a2s,b2s,x,y);
                            if (a>rs)
                                finalCoeff = coeff;
                            else
                                coeffs = real(2.*sqrt(abs(rs^2-a^2)));
                                finalCoeff = coeff - coeffs;
                            end
                            if finalCoeff > 0
                                finalImage(y,x) = finalImage(y,x) * finalCoeff;
                            end
                        end
                    end
                end
            end
            
            set(handles.saveSessionMessageTag,'visible','off');
            set(handles.saveSessionMessageTag,'String',lastString);
            drawnow update;
            
        end
        
    catch exc %#ok<NASGU>
        
        set(handles.saveSessionMessageTag,'visible','off');
        set(handles.saveSessionMessageTag,'String',lastString);
        drawnow update;
        
        finalImage = [];
        set(gcf,'pointer','arrow');
        errordlg('Selection size do not match image format');
        
    end
    
end

