function refreshPreviewBasicAnalysisProfile(hObject)
    % This function displays the ROI in the bottom left axis (on top of
    % the preview image)
    
    handles = guidata(hObject);
        
    profileSelection = get(handles.listboxBAprofile,'string');
    formatedProfileSelection = {};
    if ~isempty(profileSelection)
        nbrProfile = size(profileSelection,1);
        expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
        for i=1:nbrProfile
            [result] = regexp(profileSelection{i},...
                expression,'tokens');
            formatedProfileSelection{i} = result{1}; %#ok<AGROW>
        end
    end
    
    sz = size(formatedProfileSelection,2);
    if sz > 0
        for i=1:sz
            
            tmpProfile = formatedProfileSelection{i};
            
            if strcmp(tmpProfile{1},'line') % line
                
                x1 = str2double(tmpProfile(2));
                y1 = str2double(tmpProfile(3));
                x2 = str2double(tmpProfile(4));
                y2 = str2double(tmpProfile(5));
                
                line([x1 x2],[y1 y2],'color','green');
                str = sprintf('#%d',i);
                
                %display label at the end of the profile line
                if x1 < x2
                    xPos = x2-85;
                    yPos = y2-40;
                else
                    xPos = x2+20;
                    yPos = y2-30;
                end
                text(xPos, yPos,str,'color','red');
                
            elseif strcmp(tmpProfile{1},'rect') % rectangle
                
                x1 = str2double(tmpProfile(2));
                y1 = str2double(tmpProfile(3));
                w = str2double(tmpProfile(4));
                h = str2double(tmpProfile(5));
                
                rectangle('position',[x1, y1, w, h], ...
                    'lineWidth',2, ...
                    'edgeColor','blue');
                str = sprintf('#%d',i);
                
                %display label at the last corner of the profile box
                xPos = x1+w-65;
                yPos = y1+h-40;
                text(xPos, yPos, str, 'color', 'red');
                
            else % ellipse
                                
                %isolate thickness of circle
                tmpPro = tmpProfile{1};
                ellipseThickness = str2double(tmpPro(7:end));
                precision = getEllipsePlotPrecision(ellipseThickness);
                
                x = str2double(tmpProfile(2));
                y = str2double(tmpProfile(3));
                w = str2double(tmpProfile(4));
                h = str2double(tmpProfile(5));
                
                % display center and ellipse borders
%                 x0 = x - ellipseThickness;
%                 x1 = x + ellipseThickness;
%                 y0 = y - ellipseThickness;
%                 y1 = y + ellipseThickness;
%                 width0 = w + 2* ellipseThickness;
%                 height0 = h + 2* ellipseThickness;
%                 width1 = w - 2*ellipseThickness;
%                 height1 = h - 2*ellipseThickness;
%                 
%                 tmpColor = [23/255,230/255,48/255];
%                 
%                 rectangle('position', [x0,y0,width0,height0], ...
%                     'lineWidth',2, ...
%                     'curvature',[1,1], ...
%                     'edgeColor',tmpColor);
%                 
%                 rectangle('position',[x1,y1,width1,height1],...
%                     'lineWidth',2, ...
%                     'curvature',[1,1], ...
%                     'edgeColor',tmpColor);
                
                % display label at the last corner of the profile box
                str = sprintf('#%d',i);
                xPos = x+w-65;
                yPos = y+h-40;
                text(xPos, yPos, str, 'color', 'red');
                
                % add the marker that show where the profile starts
                xArrow = x + w/2;
                yArrow = y;
                hold on;
                plot(xArrow,yArrow,'>','markersize',10,...
                    'markerfacecolor','r');
                
                % display real ellipse
                [x_ellipse, y_ellipse] = getEllipseContour(x, y, w, h, ...
                    precision);
                plot(x_ellipse, y_ellipse, 'bo');
                                
            end
            
        end
        
    end
    
end

