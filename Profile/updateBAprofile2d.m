function updateBAprofile2d(hObject)
    % Display the 2D profile
    
    updateBAprofileInputPanel(hObject)
    
    handles = guidata(hObject);
    axes(handles.axesBAprofile);
    
    %get full list of profiles
    [listProfile] = get(handles.listboxBAprofile,'string');
    if isempty(listProfile)
        cla reset
        return
    end
    
    %get list of profiles selected
    listProfileRowSelected = get(handles.listboxBAprofile,'value');
    if listProfileRowSelected == 0
        return
    end
    listProfileSelected = listProfile(listProfileRowSelected);
    nbrProfiles = numel(listProfileSelected);
    
    %get list of data image selected
    listDataRowSelected = get(handles.listboxDataFile,'value');
    dataFilesImages = handles.files.images;
    dataFilesImagesSelected = dataFilesImages(listDataRowSelected);
    nbrFiles = numel(dataFilesImagesSelected);
    
    %figure out the Image Domain we requested
    yaxisLabel = getImageDomainSelected(hObject);
    
    BlueIndex = (1:nbrProfiles)/nbrProfiles;
    
    firstPlot = true;
    
    expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
    for j=1:nbrProfiles
        for i=1:nbrFiles
            tmpProfile = listProfileSelected{j};
            [result] = regexp(tmpProfile, expression,'tokens');
            tmpFormatedProfile = result{1};
            
            bSaveNewMax = false;
            image = getImageForPreview(hObject, ...
                dataFilesImagesSelected{i}, 'data', bSaveNewMax);
            
            if strcmp(tmpFormatedProfile(1),'line')
                
                x1 = str2double(tmpFormatedProfile(2));
                y1 = str2double(tmpFormatedProfile(3));
                x2 = str2double(tmpFormatedProfile(4));
                y2 = str2double(tmpFormatedProfile(5));
                
                [cx,~,c] = improfile(image,[x1 x2],[y1 y2]);
                
                axis(handles.axesBAprofile);
                
                xaxis = 1:numel(cx);
                plot(xaxis, c,'color',[0 0 BlueIndex(j)]);
                
                str = sprintf('#%d',listProfileRowSelected(j));
                text(xaxis(end),c(end),str,...'color','black',...
                    'backgroundcolor',[.7 .9 .7], ...
                    'fontWeight','bold');
                
            elseif strcmp(tmpFormatedProfile(1),'rect') %rectangle
                
                x1 = str2double(tmpFormatedProfile(2));
                y1 = str2double(tmpFormatedProfile(3));
                w = str2double(tmpFormatedProfile(4));
                h = str2double(tmpFormatedProfile(5));
                
                imageCropped = image(y1:y1+h,x1:x1+w);
                if h>=w %we will sum over the width
                    factorDiv = size(imageCropped,2);
                    dimensionToSum = 2;
                else
                    factorDiv = size(imageCropped,1);
                    dimensionToSum = 1;
                end
                total = sum(imageCropped,dimensionToSum);
                total = total/(factorDiv-1);
                
                axis(handles.axesBAprofile);
                
                xaxis = 1:numel(total);
                plot(xaxis, total, 'color', [1 0 1]);
                
                str = sprintf('#%d',listProfileRowSelected(j));
                text(xaxis(end),total(end),str,...'color','black',...
                    'backgroundcolor',[.7 .9 .7], ...
                    'fontWeight','bold');
                
            else % circle/ellipse
                
                set(gcf,'pointer','watch');
                
                x = str2double(tmpFormatedProfile(2));
                y = str2double(tmpFormatedProfile(3));
                w = str2double(tmpFormatedProfile(4));
                h = str2double(tmpFormatedProfile(5));
                
                tmpPro = tmpFormatedProfile{1};
                ellipseThicknessRadius = str2double(tmpPro(7:end));
                % if thickness radius is 1, will get the profile using only 1
                % eclipse
                % if thickness radius is 2, will use 3 ellipses
                % if thickness radius is 3, will use 5 ellipses
                precision = getEllipsePlotPrecision(ellipseThicknessRadius);
                
                offset = -ellipseThicknessRadius;
                
                % id of the figure for the detail plot of the selection
                ellipsePreciseSelectionId = handles.ellipsePreciseSelectionId;
                
                figure(handles.iMarsGUI);
                axis(handles.axesBAprofile);
                
                tmp_x = x+offset;
                tmp_y = y+offset;
                tmp_w = w + 2*offset;
                tmp_h = h + 2*offset;
                
                % get profile of the central ellipse
                [profileArray, ~, ~] = getEllipseProfile(image,...
                    tmp_x, ...
                    tmp_y, ...
                    tmp_w, ...
                    tmp_h, ...
                    precision);
                
                xaxis = 1:numel(profileArray);
                plot(xaxis, profileArray,'color',[1,0,1]);
                
                handles.ellipsePreciseSelectionId = ellipsePreciseSelectionId;
                guidata(hObject, handles);
                
                set(gcf,'pointer','arrow');
                
            end
            
            if firstPlot
                xlabel('Pixels');
                ylabel(yaxisLabel);
                firstPlot = false;
            end
            
            hold  on
            
        end
    end
    
    hold off
    
end