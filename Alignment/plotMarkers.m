function plotMarkers(handles, ~)
    
    markers = handles.alignmentMarkers;
    
    formatedProfileSelection = {};
    if ~isempty(markers)
        nbrProfile = size(markers,2);
        expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
        index = 1;
        for i=1:nbrProfile
            [result] = regexp(markers{i},...
                expression,'tokens');
            try
                formatedProfileSelection{index} = result{1}; %#ok<AGROW>
                index = index+1;
            catch
                continue
            end
        end
    end
    
    sz = size(formatedProfileSelection,2);
    if sz > 0
        for i=1:sz
            
            try
                tmpProfile = formatedProfileSelection{i};
                
                if strcmp(tmpProfile{1},'line') % line
                    
                    x1 = str2double(tmpProfile(2));
                    y1 = str2double(tmpProfile(3));
                    x2 = str2double(tmpProfile(4));
                    y2 = str2double(tmpProfile(5));
                    
                    line([x1 x2],[y1 y2],'color','green');
                    
                elseif strcmp(tmpProfile{1},'rect') % rectangle
                    
                    x1 = str2double(tmpProfile(2));
                    y1 = str2double(tmpProfile(3));
                    w = str2double(tmpProfile(4));
                    h = str2double(tmpProfile(5));
                    
                    rectangle('position',[x1, y1, w, h], ...
                        'lineWidth',2, ...
                        'edgeColor','blue');
                    
                else % ellipse
                    
                    %isolate thickness of circle
                    tmpPro = tmpProfile{1};
                    ellipseThickness = str2double(tmpPro(7:end));
                    precision = getEllipsePlotPrecision(ellipseThickness);
                    
                    x = str2double(tmpProfile(2));
                    y = str2double(tmpProfile(3));
                    w = str2double(tmpProfile(4));
                    h = str2double(tmpProfile(5));
                    
                    rectangle('position',[x y w h], ...
                        'linestyle','--', ...
                        'linewidth',1, ...
                        'curvature',[1,1], ...
                        'edgecolor','red');
                    
                end
                
            catch
                continue
            end
            
        end
        
    end
end
