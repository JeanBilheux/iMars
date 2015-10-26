function selectAlignmentMarkersTool(hObject, profileSelection)
    % Will allow user to select a line, rectangle or ellipse
    % markers
    % and provide the possibility to move, resize and delete any
    % of those markers
    % Input
    %    hObject
    %    profileSelection: {'circle4:81,52,226,225'}
    
    handles = guidata(hObject);
        
    %-- variable that will be used in the selection tool only
    leftClick = false; %status of the left click
    motionClickWithLeftClick = false;
    point1 = [-1 -1];
    point2 = [-1 -1];
    movingPoint1 = [-1 -1];
    movingPoint2 = [-1 -1];
    selectedColormap = handles.colormap;
    
    pointRef = [-1 -1]; %position to refer to in order to move rectangle
    
    image = calculateAlignmentImagesToPreview(hObject);
    
    pointer = 'crosshair'; %cursor shape
    
    currentProfileList = {};
    previousActiveProfileIndex = -1;
    activeProfileIndex = -1;
    
    roiRectangle = {};
    roiEllipse = {};
    
    activeRectangleIndex = -1;
    activeEllipseIndex = -1;
    
    previousActiveRectangleIndex = -1;
    previousActiveEllipseIndex = -1;
    
    rectangleInitialPosition  = [-1 -1 -1 -1]; %rectangle to move
    ellipseInitialPosition = [-1 -1 -1 -1];
    
    ellipseThickness = 1;
    lineThickness = 2;
    
    lastRectangle = [-1 -1 -1 -1];
    lastEllipse = [-1 -1 -1 -1];
    
    %isWorkingStateLine = true;
    workingProfile = 'line';
    
    %-----------------------------------------------------
    
    formatSelection(profileSelection); %list of profile

    ScreenSize = get(0,'ScreenSize');
    figWidth = 800;
    figHeight = 800;
    figX = (ScreenSize(3)-figWidth)/2;
    figY = (ScreenSize(4)-figHeight)/2;
    
    figroi = figure('menubar','none',...
        'position',[figX, figY, figWidth, figHeight]);
    ht=uitoolbar(figroi);
    handles.figprofile = figroi;
    guidata(hObject, handles);
    
    line_icon = imread('UtilityFiles/line_profile.jpg','jpg');
    rectangle_icon = imread('UtilityFiles/rectangle_ROI.jpg','jpg');
    ellipse_icon = imread('UtilityFiles/ellipse_profile.jpg','jpg');
    lineTool = uitoggletool(ht, 'CData', line_icon, ...
        'TooltipString', 'Select a Line Marker', ...
        'State','on', ...
        'tag','line_profile');
    rectangleTool = uitoggletool(ht, 'CData', rectangle_icon, ...
        'TooltipString', 'Select a Rectangle Marker', ...
        'tag','rectangle_profile');
    ellipseTool = uitoggletool(ht, 'CData', ellipse_icon, ...
        'TooltipString','Select a Ellipse Marker', ...
        'tag','ellipse_profile');

    drawnow
    
    %define the callback functions of the toolbar
    set(lineTool, ...
        'clickedCallback', {@clickedLineTool});
    set(rectangleTool, ...
        'clickedCallback', {@clickedRectangleTool});
    set(ellipseTool, ...
        'clickedCallback', {@clickedEllipseTool});
    
    %create an axes object
    roiAxes = axes();
    set(roiAxes, ...
        'tickdir','out', ...
        'position',[0 0 1 1]);
    
    %set figure properties
    set(figroi, 'numbertitle','off',...
        'name','Marker Definition Tool', ...
        'units','normalized', ...
        'pointer','crosshair', ...
        'WindowButtonMotionFcn',{@hFigure_MotionFcn, hObject}, ...
        'WindowKeyPressFcn',{@hFigure_KeyPressFcn, hObject}, ...
        'WindowButtonDownFcn', {@hFigure_DownFcn, hObject}, ...
        'WindowButtonUpFcn', {@hFigure_UpFcn, hObject}, ...
        'CloseRequestFcn', {@hFigure_closeRequestFcn, hObject});
    
    RoiRefreshImage (hObject); %plot the image
    colormap(selectedColormap);
    

    function formatSelection(profileSelection)
        %format the selection coming from the main gui
        
        if isempty(profileSelection)
            return
        end
        
        roiRectangle = {};
        nbrRectangle = 1;
        nbrEllipse = 1;
        currentProfileList = {};
        nbrProfile = 1;
        
        szProfile = size(profileSelection,2);
        expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
        for i=1:szProfile
            result = regexp(profileSelection{i},...
                expression,'tokens');
            tmpSelection = result{1};
            
            x1 = str2double(tmpSelection(2));
            y1 = str2double(tmpSelection(3));
            x2 = str2double(tmpSelection(4));
            y2 = str2double(tmpSelection(5));
            
            if strcmp(tmpSelection(1),'line') %line
                
                currentProfileList{nbrProfile} = [x1, y1, x2, y2];
                nbrProfile = nbrProfile + 1;
                
            elseif strcmp(tmpSelection(1),'rect') %rectangle
                
                roiRectangle{nbrRectangle} = [x1, y1, x2, y2];
                nbrRectangle = nbrRectangle + 1;
            
            else %elipse
                
                roiEllipse{nbrEllipse} = [x1,y1,x2,y2];
                nbrEllipse = nbrEllipse + 1;
                
            end
            
        end
        
    end
    
    
    %% DownFcn
    function hFigure_DownFcn(~, ~, ~)
        %user click mouse (left or right)
        leftClick = true;
        
        switch workingProfile
            
            case 'line'
                
                livePoint = get(roiAxes,'CurrentPoint');
                point1 = [livePoint(1,1) livePoint(1,2)];
                
                %we need to keep record of the exact position of active profile
                if ~strcmp(pointer,'crosshair')
                    
                    %we are about to work with the following profile
                    profileInitialPosition = currentProfileList{activeProfileIndex};
                    tmp_workingProfile = profileInitialPosition;
                    
                    point1 = [tmp_workingProfile(1) tmp_workingProfile(2)];
                    point2 = [tmp_workingProfile(3) tmp_workingProfile(4)];
                    
                    %get reference position
                    tmpPointRef = get(roiAxes,'CurrentPoint');
                    pointRef = [tmpPointRef(1,1) tmpPointRef(1,2)];
                    removeProfileToList(activeProfileIndex);
                    
                    activeProfileIndex = -1;
                    
                end
                
            case 'rectangle'
                
                point1 = get(roiAxes,'CurrentPoint');
                
                %we need to keep record of the exact position of active rectangle
                if ~strcmp(pointer,'crosshair')
                    rectangleInitialPosition = roiRectangle{activeRectangleIndex};
                    lastRectangle = rectangleInitialPosition;
                    %get reference position
                    pointRef = get(roiAxes,'CurrentPoint');
                    removeRectangleToList(activeRectangleIndex);
                    activeRectangleIndex = -1;
                    moveLiveRectangle(hObject);
                end
                
            case 'ellipse'
                
                point1 = get(roiAxes, 'CurrentPoint');
                
                %we need to keep record of the exact position of active
                %ellipse
                if ~strcmp(pointer,'crosshair')
                    ellipseInitialPosition = roiEllipse{activeEllipseIndex};
                    lastEllipse = ellipseInitialPosition;
                    %get reference position
                    pointRef = get(roiAxes,'CurrentPoint');
                    removeEllipseToList(activeEllipseIndex);
                    activeEllipseIndex = -1;
                    moveLiveEllipse(hObject);
                end
            otherwise
                
        end
        
    end
    
    %% UpFcn
    function hFigure_UpFcn(~, ~, hObject)
        leftClick = false;
        
        switch workingProfile
            
            case 'line'
                
                if motionClickWithLeftClick
                    %add last profile to list of profiles
                    switch pointer
                        case 'hand'
                            point1 = movingPoint1;
                            point2 = movingPoint2;
                        otherwise
                    end
                    previousActiveProfileIndex = -1;
                    addLastProfileToListProfile();
                    RoiRefreshImage(hObject);
                end
                
            case 'rectangle'
                
                if motionClickWithLeftClick
                    %add last rectangle to list of rectangle ROIs
                    addLastRectangleToListRectangle();
                    RoiRefreshImage(hObject);
                end
                
            case 'ellipse'
                
                if motionClickWithLeftClick
                    %add last ellipse to list of ellipse ROIs
                    addLastEllipseToListEllipse();
                    RoiRefreshImage(hObject);
                    
                end
                
            otherwise
                
        end
        
        motionClickWithLeftClick = false;
        
    end
    
    
    %% MotionFcn
    function hFigure_MotionFcn(~, ~, hObject)
        %This function is reached any time the mouse is moving over the figure

        switch workingProfile
            
            case 'line'
                
                if leftClick %we need to draw something
                    
                    RoiRefreshImage (hObject); %plot the image
                    switch pointer
                        case 'crosshair' %draw profiles
                            drawLiveProfile();
                            
                        case 'hand' %move selected profile here
                            moveLiveProfile();
                            
                        case 'top'
                            moveEdgeProfile('point1');
                            
                        case 'bottom'
                            moveEdgeProfile('point2');
                        otherwise
                    end
                    
                else %we need to check if we need to move or change size of something
                    
                    [yesItIs, index, isEdge, whichEdge_12] = isMouseOverProfile();
                    if yesItIs %change color of this profile
                        activeProfileIndex = index;
                        pointer = 'hand';
                        if isEdge
                            if isequal(whichEdge_12,'1')
                                pointer = 'top';
                            end
                            if isequal(whichEdge_12,'2')
                                pointer = 'bottom';
                            end
                        end
                    else
                        activeProfileIndex = -1;
                        pointer = 'crosshair';
                    end
                    set(figroi, 'pointer',pointer);
                    %refresh plot only if something changed
                    if previousActiveProfileIndex ~= activeProfileIndex
                        RoiRefreshImage(hObject);
                        previousActiveProfileIndex = activeProfileIndex;
                    end
                    
                end
                
            case 'rectangle'
                
                if leftClick %we need to draw something
                    
                    switch pointer
                        case 'crosshair' %draw rectangle
                            drawLiveRectangle(hObject);
                            
                        case 'hand' %move selected rectangle here
                            moveLiveRectangle(hObject);
                            
                        case 'left'
                            moveEdgeRectangle(hObject,'left');
                            
                        case 'right'
                            moveEdgeRectangle(hObject,'right');
                            
                        case 'top'
                            moveEdgeRectangle(hObject,'top');
                            
                        case 'bottom'
                            moveEdgeRectangle(hObject,'bottom');
                            
                        case 'topl'
                            moveEdgeRectangle(hObject,'topl');
                            
                        case 'topr'
                            moveEdgeRectangle(hObject,'topr');
                            
                        case 'botl'
                            moveEdgeRectangle(hObject,'botl');
                            
                        case 'botr'
                            moveEdgeRectangle(hObject,'botr');
                            
                        otherwise
                    end
                    
                else %we need to check if we need to move or change size of something
                    
                    [yesItIs, index, isEdge, whichEdge_trbl] = isMouseOverRectangle();
                    if yesItIs %change color of this rectangle
                        activeRectangleIndex = index;
                        
                        pointer = 'hand';
                        if isEdge
                            
                            if isequal(whichEdge_trbl,[true false false false])
                                pointer = 'top';
                            end
                            if isequal(whichEdge_trbl,[false true false false])
                                pointer = 'right';
                            end
                            if isequal(whichEdge_trbl,[false false true false])
                                pointer = 'bottom';
                            end
                            if isequal(whichEdge_trbl,[false false false true])
                                pointer = 'left';
                            end
                            if isequal(whichEdge_trbl,[true true false false])
                                pointer = 'topr';
                            end
                            if isequal(whichEdge_trbl,[true false false true])
                                pointer = 'topl';
                            end
                            if isequal(whichEdge_trbl,[false true true false])
                                pointer = 'botr';
                            end
                            if isequal(whichEdge_trbl,[false false true true])
                                pointer = 'botl';
                            end
                        end
                    else
                        activeRectangleIndex = -1;
                        pointer = 'crosshair';
                    end
                    set(figroi,'pointer',pointer);
                    
                    %refresh plot only if something changed
                    if previousActiveRectangleIndex ~= activeRectangleIndex
                        RoiRefreshImage(hObject);
                        previousActiveRectangleIndex = activeRectangleIndex;
                        
                    end
                    
                end
                
            case 'ellipse'
                
                if leftClick %we need to draw something
                    
                    switch pointer
                        case 'crosshair' %draw ellipse
                            drawLiveEllipse(hObject);
                            
                        case 'hand' %move selected rectangle here
                            moveLiveEllipse(hObject);
                            
                        case 'left'
                            moveEdgeEllipse(hObject,'left');
                            
                        case 'right'
                            moveEdgeEllipse(hObject,'right');
                            
                        case 'top'
                            moveEdgeEllipse(hObject,'top');
                            
                        case 'bottom'
                            moveEdgeEllipse(hObject,'bottom');
                            
                        case 'topl'
                            moveEdgeEllipse(hObject,'topl');
                            
                        case 'topr'
                            moveEdgeEllipse(hObject,'topr');
                            
                        case 'botl'
                            moveEdgeEllipse(hObject,'botl');
                            
                        case 'botr'
                            moveEdgeEllipse(hObject,'botr');
                            
                        otherwise
                    end
                    
                else %end of if leftclick
                    
                    [yesItIs, index, isEdge, whichEdge_trbl] = isMouseOverEllipse();
                    if yesItIs %change color of this rectangle
                        activeEllipseIndex = index;
                        
                        pointer = 'hand';
                        if isEdge
                            
                            if isequal(whichEdge_trbl,[true false false false])
                                pointer = 'top';
                            end
                            if isequal(whichEdge_trbl,[false true false false])
                                pointer = 'right';
                            end
                            if isequal(whichEdge_trbl,[false false true false])
                                pointer = 'bottom';
                            end
                            if isequal(whichEdge_trbl,[false false false true])
                                pointer = 'left';
                            end
                            if isequal(whichEdge_trbl,[true true false false])
                                pointer = 'topr';
                            end
                            if isequal(whichEdge_trbl,[true false false true])
                                pointer = 'topl';
                            end
                            if isequal(whichEdge_trbl,[false true true false])
                                pointer = 'botr';
                            end
                            if isequal(whichEdge_trbl,[false false true true])
                                pointer = 'botl';
                            end
                        end
                    else
                        activeEllipseIndex = -1;
                        pointer = 'crosshair';
                    end
                    set(figroi,'pointer',pointer);
                    
                    %refresh plot only if something changed
                    if previousActiveEllipseIndex ~= activeEllipseIndex
                        RoiRefreshImage(hObject);
                        previousActiveEllipseIndex = activeEllipseIndex;
                        
                    end
                    
                    
                end
            otherwise
                
        end
        
    end
    %% KeyPressFcn
    function hFigure_KeyPressFcn(hObject, eventdata, ~)
        
        switch workingProfile
            
            case 'line'
                
                switch eventdata.Key
                    case 'delete'
                        removeProfileToList(activeProfileIndex);
                        RoiRefreshImage (hObject);
                    case 'backspace'
                        removeProfileToList(activeProfileIndex);
                        RoiRefreshImage (hObject);
                    otherwise
                end
                
            case 'rectangle'
                
                switch eventdata.Key
                    case 'delete'
                        removeRectangleToList(activeRectangleIndex);
                        RoiRefreshImage (hObject);
                    case 'backspace'
                        removeRectangleToList(activeRectangleIndex);
                        RoiRefreshImage (hObject);
                    otherwise
                end
                
            case 'ellipse'
                
                switch eventdata.Key
                    case 'delete'
                        removeEllipseToList(activeEllipseIndex);
                        RoiRefreshImage (hObject);
                    case 'backspace'
                        removeEllipseToList(activeEllipseIndex);
                        RoiRefreshImage (hObject);
                    otherwise
                end
                
            otherwise
                
        end
        
    end
    

    %% RoiRefreshImage
    function RoiRefreshImage (~)
        %Refresh the image plot and the profile plot
        
        %get current saved image to preview
        axes(roiAxes);
        img = image;
        imagesc(img);
        
        sz = size(currentProfileList,2);
        if sz > 0
            for i=1:sz
                if i==activeProfileIndex
                    color = 'red';
                else
                    color = 'white';
                end
                
                tmpProfile = currentProfileList{i};
                %                 x1 = str2double(tmpProfile(1));
                %                 y1 = str2double(tmpProfile(2));
                %                 x2 = str2double(tmpProfile(3));
                %                 y2 = str2double(tmpProfile(4));
                
                x1 = tmpProfile(1);
                y1 = tmpProfile(2);
                x2 = tmpProfile(3);
                y2 = tmpProfile(4);
                
                line([x1 x2],[y1 y2],'color',color);
                
                if strcmp(color,'red')
                    %draw small squares in top and bottom edge of profile
                    %to show that we can resize them
                    cornerRectangles = getProfileCornerRectangles(x1,y1,x2,y2);
                    for j=1:2
                        rectangle('position',cornerRectangles{j},...
                            'lineWidth',1, ...
                            'edgeColor',color);
                    end
                end
                
            end
        end
        
        sz = size(roiRectangle,2);
        if sz > 0
            for i=1:sz
                if i==activeRectangleIndex
                    color = 'red';
                else
                    color = 'white';
                end
                
                rectangle('position',roiRectangle{i},...
                    'lineWidth',1, ...
                    'edgeColor',color);
                
                if strcmp(color,'red')
                    %draw small squares in the corner and middle of length
                    %to show that we can resize them
                    cornerRectangles = getRectangleCornerRectangles(roiRectangle{i});
                    for j=1:8
                        rectangle('position',cornerRectangles{j},...
                            'lineWidth',1, ...
                            'edgeColor',color);
                    end
                end
                
            end
        end
        
        sz = size(roiEllipse,2);
        if sz > 0
            for i=1:sz
                if i==activeEllipseIndex
                    color = 'red';
                else
                    color = 'white';
                end
                
                rectangle('position',roiEllipse{i},...
                    'lineWidth',1, ...
                    'curvature',[1,1], ...
                    'edgeColor',color);
                
                tmpRoiEllipse = roiEllipse{i};

                if ellipseThickness > 1
                    
                    x = tmpRoiEllipse(1);
                    y = tmpRoiEllipse(2);
                    width = tmpRoiEllipse(3);
                    height = tmpRoiEllipse(4);
                    
                    x0 = x - ellipseThickness;
                    x1 = x + ellipseThickness;
                    y0 = y - ellipseThickness;
                    y1 = y + ellipseThickness;
                    width0 = width + 2* ellipseThickness;
                    height0 = height + 2* ellipseThickness;
                    width1 = width - 2*ellipseThickness;
                    height1 = height - 2*ellipseThickness;
                    
                    tmpColor = [23/255,230/255,48/255];
                    
                    rectangle('position', [x0,y0,width0,height0], ...
                        'lineWidth',lineThickness, ...
                        'curvature',[1,1], ...
                        'edgeColor',tmpColor);
                    
                    rectangle('position',[x1,y1,width1,height1],...
                        'lineWidth',lineThickness, ...
                        'curvature',[1,1], ...
                        'edgeColor',tmpColor);
                    
                end
                
                if strcmp(color,'red')
                    %draw small squares in the corner and middle of length
                    %to show that we can resize them
                    cornerRectangles = getRectangleCornerRectangles(roiEllipse{i});
                    for j=1:8
                        rectangle('position',cornerRectangles{j},...
                            'lineWidth',1, ...
                            'edgeColor',color);
                    end
                end
                
            end
        end
        
        
    end
    
    %% CloseRequestFcn
    function hFigure_closeRequestFcn(hFigure, ~, hObject)
        %this function will record all the profiles and
        % rectangles and will transform
        %into a cell array for the main gui
        
        formatedSelection = formatProfileList();

        handles.alignmentMarkers = formatedSelection;
        guidata(hObject, handles);
        
        populateManualAlignmentMarkers(hObject);
        refreshAlignmentPreview(hObject);
        
        delete(hFigure);
        
    end
    
    function clickedLineTool(~,~)
        set(lineTool,'State','on');
        set(rectangleTool,'State','off');
        set(ellipseTool','State','off');
        %         isWorkingStateLine = 'line';
        workingProfile = 'line';
    end
    
    function clickedRectangleTool(~,~)
        set(lineTool,'State','off');
        set(rectangleTool,'State','on');
        set(ellipseTool','State','off');
        %         isWorkingStateLine = 'rectangle';
        workingProfile = 'rectangle';
    end
    
    function clickedEllipseTool(~,~)
        set(lineTool,'State','off');
        set(rectangleTool,'State','off');
        set(ellipseTool','State','on');
        workingProfile = 'ellipse';
    end
    
  
    
    function moveEdgeRectangle(hObject, side)
        %will resize the rectangle by moving the left, right, top
        %or bottom edge
        
        motionClickWithLeftClick = true;
        
        %current mouse position
        curMousePosition = get(roiAxes,'CurrentPoint');
        
        minWH = 1;  %rectangle is at least minWH pixels width and height
        
        switch side
            case 'left'
                
                %offset to apply
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(1) = rectangleInitialPosition(1) + deltaX;
                lastRectangle(3) = rectangleInitialPosition(3) - deltaX;
                if lastRectangle(3) <= minWH
                    lastRectangle(3) = minWH;
                end
                
            case 'right'
                
                %offset to apply
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(3) = rectangleInitialPosition(3) + deltaX;
                
            case 'top'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                
                lastRectangle(2) = rectangleInitialPosition(2) + deltaY;
                lastRectangle(4) = rectangleInitialPosition(4) - deltaY;
                
            case 'bottom'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                
                lastRectangle(4) = rectangleInitialPosition(4) + deltaY;
                
            case 'topl'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(1) = rectangleInitialPosition(1) + deltaX;
                lastRectangle(3) = rectangleInitialPosition(3) - deltaX;
                lastRectangle(2) = rectangleInitialPosition(2) + deltaY;
                lastRectangle(4) = rectangleInitialPosition(4) - deltaY;
                
            case 'topr'
                
                %offset to apply
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                
                lastRectangle(3) = rectangleInitialPosition(3) + deltaX;
                lastRectangle(2) = rectangleInitialPosition(2) + deltaY;
                lastRectangle(4) = rectangleInitialPosition(4) - deltaY;
                
            case 'botl'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(1) = rectangleInitialPosition(1) + deltaX;
                lastRectangle(3) = rectangleInitialPosition(3) - deltaX;
                lastRectangle(4) = rectangleInitialPosition(4) + deltaY;
                
            case 'botr'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(3) = rectangleInitialPosition(3) + deltaX;
                lastRectangle(4) = rectangleInitialPosition(4) + deltaY;
                
        end
        
        %make sure we have the minimum width and height requirements
        if lastRectangle(3) <= minWH
            lastRectangle(3) = minWH;
        end
        if lastRectangle(4) <= minWH
            lastRectangle(4) = minWH;
        end
        
        RoiRefreshImage(hObject);
        
        rectangle('position',lastRectangle,...
            'lineStyle','--',...
            'lineWidth',1, ...
            'edgeColor','red');
    end
    
    
    function moveEdgeEllipse(hObject, side)
        %will resize the ellipse by moving the left, right, top
        %or bottom edge
        
        motionClickWithLeftClick = true;
        
        %current mouse position
        curMousePosition = get(roiAxes,'CurrentPoint');
        
        minWH = 1;  %rectangle is at least minWH pixels width and height
        
        switch side
            case 'left'
                
                %offset to apply
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastEllipse(1) = ellipseInitialPosition(1) + deltaX;
                lastEllipse(3) = ellipseInitialPosition(3) - deltaX;
                if lastEllipse(3) <= minWH
                    lastEllipse(3) = minWH;
                end
                
            case 'right'
                
                %offset to apply
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastEllipse(3) = ellipseInitialPosition(3) + deltaX;
                
            case 'top'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                
                lastEllipse(2) = ellipseInitialPosition(2) + deltaY;
                lastEllipse(4) = ellipseInitialPosition(4) - deltaY;
                
            case 'bottom'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                
                lastEllipse(4) = ellipseInitialPosition(4) + deltaY;
                
            case 'topl'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastEllipse(1) = ellipseInitialPosition(1) + deltaX;
                lastEllipse(3) = ellipseInitialPosition(3) - deltaX;
                lastEllipse(2) = ellipseInitialPosition(2) + deltaY;
                lastEllipse(4) = ellipseInitialPosition(4) - deltaY;
                
            case 'topr'
                
                %offset to apply
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                
                lastEllipse(3) = ellipseInitialPosition(3) + deltaX;
                lastEllipse(2) = ellipseInitialPosition(2) + deltaY;
                lastEllipse(4) = ellipseInitialPosition(4) - deltaY;
                
            case 'botl'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastEllipse(1) = ellipseInitialPosition(1) + deltaX;
                lastEllipse(3) = ellipseInitialPosition(3) - deltaX;
                lastEllipse(4) = ellipseInitialPosition(4) + deltaY;
                
            case 'botr'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastEllipse(3) = ellipseInitialPosition(3) + deltaX;
                lastEllipse(4) = ellipseInitialPosition(4) + deltaY;
                
        end
        
        %make sure we have the minimum width and height requirements
        if lastEllipse(3) <= minWH
            lastEllipse(3) = minWH;
        end
        if lastEllipse(4) <= minWH
            lastEllipse(4) = minWH;
        end
        
        RoiRefreshImage(hObject);
        
        rectangle('position',lastEllipse,...
            'lineStyle','--',...
            'lineWidth',1, ...
            'curvature',[1 1], ...
            'edgeColor','red');
    end
    
    function moveLiveRectangle(hObject)
        %will move the rectangle selection
        
        motionClickWithLeftClick = true;
        
        %current mouse position
        curMousePosition = get(roiAxes,'CurrentPoint');
        
        %offset to apply
        deltaX = curMousePosition(1,1) - pointRef(1,1);
        deltaY = curMousePosition(1,2) - pointRef(1,2);
        
        lastRectangle(1) = rectangleInitialPosition(1) + deltaX;
        lastRectangle(2) = rectangleInitialPosition(2) + deltaY;
        
        RoiRefreshImage(hObject);
        
        rectangle('position',lastRectangle,...
            'lineStyle','--',...
            'lineWidth',1, ...
            'edgeColor','red');
        
    end
    
    function moveLiveEllipse(hObject)
        %will move the rectangle selection
        
        motionClickWithLeftClick = true;
        
        %current mouse position
        curMousePosition = get(roiAxes,'CurrentPoint');
        
        %offset to apply
        deltaX = curMousePosition(1,1) - pointRef(1,1);
        deltaY = curMousePosition(1,2) - pointRef(1,2);
        
        lastEllipse(1) = ellipseInitialPosition(1) + deltaX;
        lastEllipse(2) = ellipseInitialPosition(2) + deltaY;
        
        RoiRefreshImage(hObject);
        
        rectangle('position',lastEllipse,...
            'lineStyle','--',...
            'lineWidth',1, ...
            'curvature',[1 1], ...
            'edgeColor','red');
        
    end
    
    function removeRectangleToList(index)
        %remove the rectangle at the index given
        roiRectangle(index) = [];
    end
    
    function removeEllipseToList(index)
        %remove the ellipse at the index given
        roiEllipse(index) = [];
    end
    
    function cornerRectangles = getRectangleCornerRectangles(currentRectangle)
        %this function will create a [8x4] array of the corner
        %rectangles used to show the user that it can resize the ROI
        
        cornerRectangles = {};
        
        x = currentRectangle(1);
        y = currentRectangle(2);
        w = currentRectangle(3);
        h = currentRectangle(4);
        
        wBox = 30; %pixels
        hBox = 30; %pixels
        
        %tl corner
        x1 = x - wBox/2;
        y1 = y - hBox/2;
        cornerRectangles{1} = [x1,y1,wBox,hBox];
        
        %t (middle of top edge) corner
        x2 = x + w/2 - wBox/2;
        y2 = y - wBox/2;
        cornerRectangles{2} = [x2,y2,wBox,hBox];
        
        %tr corner
        x3 = x + w - wBox/2;
        y3 = y - hBox/2;
        cornerRectangles{3} = [x3,y3,wBox,hBox];
        
        %r (middle of right edge) corner
        x4 = x + w - wBox/2;
        y4 = y + h/2 - hBox/2;
        cornerRectangles{4} = [x4,y4,wBox,hBox];
        
        %br corner
        x5 = x + w - wBox/2;
        y5 = y + h - hBox/2;
        cornerRectangles{5} = [x5,y5,wBox,hBox];
        
        %b (middle of bottom edge) corner
        x6 = x + w/2 - wBox/2;
        y6 = y + h - hBox/2;
        cornerRectangles{6} = [x6,y6,wBox,hBox];
        
        %bl corner
        x7 = x - wBox/2;
        y7 = y + h - hBox/2;
        cornerRectangles{7} = [x7,y7,wBox,hBox];
        
        %l (middle of left edge) corner
        x8 = x - wBox/2;
        y8 = y + h/2 - hBox/2;
        cornerRectangles{8} = [x8,y8,wBox,hBox];
        
    end
    
    function addLastRectangleToListRectangle
        %add the last rectangle profile to the list of Rectangle profiles
        
        sz = size(roiRectangle,2);
        roiRectangle{sz+1} = lastRectangle;
        activeRectangleIndex = sz+1;
        
    end
    
    function addLastEllipseToListEllipse
        %add the last ellipse profie to the list of Ellipse profiles
        
        sz = size(roiEllipse,2);
        roiEllipse{sz+1} = lastEllipse;
        activeEllipseIndex = sz+1;
        
    end
    
    function drawLiveRectangle(hObject)
        %draw a rectangle live with mouse moving
        
        motionClickWithLeftClick = true;
        units = get(roiAxes,'units');
        set(roiAxes,'units','normalized');
        point2 = get(roiAxes, 'CurrentPoint');
        x = min(point1(1,1),point2(1,1));
        y = min(point1(1,2),point2(1,2));
        w = abs(point1(1,1)-point2(1,1));
        h = abs(point1(1,2)-point2(1,2));
        if w == 0
            w=1;
        end
        if h == 0
            h=1;
        end
        
        %save rectangle
        lastRectangle = [x y w h];
        RoiRefreshImage (hObject); %plot the image
        
        rectangle('position',[x,y,w,h],...
            'lineStyle','--',...
            'lineWidth',1, ...
            'edgeColor','blue');
        
        set(roiAxes,'units',units);
        
    end
    
    function drawLiveEllipse(hObject)
        
        %draw a rectangle live with mouse moving
        
        motionClickWithLeftClick = true;
        units = get(roiAxes,'units');
        set(roiAxes,'units','normalized');
        point2 = get(roiAxes, 'CurrentPoint');
        x = min(point1(1,1),point2(1,1));
        y = min(point1(1,2),point2(1,2));
        w = abs(point1(1,1)-point2(1,1));
        h = abs(point1(1,2)-point2(1,2));
        if w == 0
            w=1;
        end
        if h == 0
            h=1;
        end
        
        %save ellipse
        lastEllipse = [x y w h];
        RoiRefreshImage (hObject); %plot the image
        
        rectangle('position',[x,y,w,h],...
            'lineStyle','--',...
            'lineWidth',lineThickness, ...
            'curvature',[1,1], ...
            'edgeColor','blue');
        
        set(roiAxes,'units',units);
        
    end
    
    function [yesItIs, index, isEdge, whichEdge_trbl] = isMouseOverRectangle()
        %this function will determine if the mouse is
        %currently over a previously selected Rectangle
        %
        %yesItIs: true or false
        %index; if yesItIs, returns the index of the rectangle selected
        %isEdge: true or false (are we over the rectangle, or just the
        % edge). Just the edge means that the rectangle will be resized
        % when over the center will mean replace it !
        %whichEdge: 'top', 'left', 'bottom' or 'right' or combination of
        % 'top-left'...etc
        
        yesItIs = false;
        index = -1;
        isEdge = false;
        whichEdge_trbl = [false false false false];
        
        point = get(roiAxes, 'CurrentPoint');
        
        sz = size(roiRectangle,2);
        if sz > 0
            for i=1:sz
                [isOverRectangle, isEdge, whichEdge_trbl] = isMouseOverRectangleEdge(point, roiRectangle{i});
                if isOverRectangle
                    yesItIs = true;
                    index = i;
                    return
                end
            end
        end
        
    end
    
    function [yesItIs, index, isEdge, whichEdge_trbl] = isMouseOverEllipse()
        %this function will determine if the mouse is
        %currently over a previously selected Ellipse
        %
        %yesItIs: true or false
        %index; if yesItIs, returns the index of the rectangle selected
        %isEdge: true or false (are we over the rectangle, or just the
        % edge). Just the edge means that the rectangle will be resized
        % when over the center will mean replace it !
        %whichEdge: 'top', 'left', 'bottom' or 'right' or combination of
        % 'top-left'...etc
        
        yesItIs = false;
        index = -1;
        isEdge = false;
        whichEdge_trbl = [false false false false];
        
        point = get(roiAxes, 'CurrentPoint');
        
        sz = size(roiEllipse,2);
        if sz > 0
            for i=1:sz
                [isOverRectangle, isEdge, whichEdge_trbl] = isMouseOverRectangleEdge(point, roiEllipse{i});
                if isOverRectangle
                    yesItIs = true;
                    index = i;
                    return
                end
            end
        end
        
    end
    
    function [result, isEdge, whichEdge_trbl] = isMouseOverRectangleEdge(point, rectangle)
        %check if the point(x,y) is over the edge of the
        %rectangle(x,y,w,h)
        guidata(hObject, handles);
        
        szEdge = 10; %pixels units
        
        result = false;
        isEdge = false;
        whichEdge_trbl = [false false false false]; %top right bottom left
        
        xMouse = point(1,1);
        yMouse = point(1,2);
        
        xminRect = rectangle(1);
        yminRect = rectangle(2);
        xmaxRect = rectangle(3)+xminRect;
        ymaxRect = rectangle(4)+yminRect;
        
        %is inside rectangle
        if (yMouse > yminRect-szEdge && ...
                yMouse < ymaxRect+szEdge && ...
                xMouse > xminRect-szEdge && ...
                xMouse < xmaxRect+szEdge)
            
            %is over left edge
            if (yMouse > yminRect-szEdge && ...
                    yMouse < ymaxRect+szEdge && ...
                    xMouse > xminRect-szEdge && ...
                    xMouse < xminRect+szEdge)
                
                isEdge = true;
                whichEdge_trbl(4) = true;
            end
            
            %is over bottom edge
            if (xMouse > xminRect-szEdge && ...
                    xMouse < xmaxRect+szEdge && ...
                    yMouse > ymaxRect-szEdge && ...
                    yMouse < ymaxRect+szEdge)
                
                isEdge = true;
                whichEdge_trbl(3) = true;
            end
            
            %is over right edge
            if (yMouse > yminRect-szEdge && ...
                    yMouse < ymaxRect+szEdge && ...
                    xMouse > xmaxRect-szEdge && ...
                    xMouse < xmaxRect+szEdge)
                
                isEdge = true;
                whichEdge_trbl(2) = true;
            end
            
            %is over top edge
            if (xMouse > xminRect-szEdge && ...
                    xMouse < xmaxRect+szEdge && ...
                    yMouse > yminRect-szEdge && ...
                    yMouse < yminRect+szEdge)
                
                isEdge = true;
                whichEdge_trbl(1) = true;
            end
            
            result = true;
            
        end
        
    end
    
    function cornerRectangles = getProfileCornerRectangles(x1,y1,x2,y2)
        %this function will create a [2x4] array of the corner
        %rectangles used to show the user that it can resize the profile
        %lines
        
        cornerRectangles = {};
        
        wBox = 30; %pixels
        hBox = 30; %pixels
        
        %x1,y1 corner
        x1 = x1 - wBox/2;
        y1 = y1 - hBox/2;
        cornerRectangles{1} = [x1,y1,wBox,hBox];
        
        %x2,y2 corner
        x2 = x2 - wBox/2;
        y2 = y2 - hBox/2;
        cornerRectangles{2} = [x2,y2,wBox,hBox];
        
    end
    
    
    
    function removeProfileToList(index)
        if index == -1
            return;
        end
        %remove the profile at the index given
        currentProfileList(index) = [];
    end
    
    
    
    function addLastProfileToListProfile()
        %add the last profile
        sz = size(currentProfileList,2);
        currentProfile = [point1(1,1), ...
            point1(1,2), ...
            point2(1,1), ...
            point2(1,2)];
        currentProfileList{sz+1} = currentProfile;
        %         activeProfileIndex = sz+1;
        
        %         isRoiRectangleEllipse(sz+1) = isLastRectangleEllipse;
        %         activeRectangleIndex = sz+1;
        %
    end
    
    
    
    function [yesItIs, index, isEdge, whichEdge_12] = isMouseOverProfile()
        %this function will determine if the mouse is
        %currently over a previously selected Profile
        %
        %yesItIs: true or false
        %index; if yesItIs, returns the index of the profile selected
        %isEdge: true or false (are we over one of the center of the profile ,
        %   or just the one of the two extremity
        %   Just the edge means that the profile line will be resized
        %   when over the center will mean replace it !
        %whichEdge_12: '1' or '2'
        
        yesItIs = false;
        index = -1;
        isEdge = false;
        whichEdge_12 = '-1';
        
        point = get(roiAxes, 'CurrentPoint');
        
        sz = size(currentProfileList,2);
        if sz > 0
            for i=1:sz
                [isOverProfile, isEdge, whichEdge_12] = isMouseOverEdge(point, currentProfileList{i});
                if isOverProfile
                    yesItIs = true;
                    index = i;
                    return
                end
            end
        end
        
    end
    
    function [result, isEdge, whichEdge_12] = isMouseOverEdge(point, profile)
        %check if the point(x,y) is over the edge of the
        %profile(x0,y0,x1,y1)
        guidata(hObject, handles);
        
        szEdge = 50; %pixels units - tollerance of click within profile
        
        result = false;
        whichEdge_12 = '1';
        isEdge = false;
        
        xMouse = point(1,1);
        yMouse = point(1,2);
        
        x1 = profile(1);
        y1 = profile(2);
        x2 = profile(3);
        y2 = profile(4);
        
        %no need to go further if we are not even inside the rectangle
        %formed by point1 and point2
        if xMouse < (min(x1,x2)-szEdge) || ...
                xMouse > (max(x1,x2)+szEdge) || ...
                yMouse < (min(y1,y2)-szEdge) || ...
                yMouse > (max(y1,y2)+szEdge)
            return
        end
        
        %equation of profile
        a = (y2 - y1) / (x2 - x1);
        b = y1 - a*x1;
        f = @(x) a*x + b;
        
        %check if distance between point and line is less than szEdge
        if abs(yMouse - f(xMouse))/(sqrt(a^2+1)) <= szEdge
            
            %yes, we are over the profile
            result = true;
            
            if sqrt((yMouse - y1)^2 + (xMouse - x1)^2) <= szEdge
                
                isEdge = true;
                whichEdge_12 = '1';
                
            else if sqrt((yMouse - y2)^2 + (xMouse - x2)^2) <= szEdge
                    
                    isEdge = true;
                    whichEdge_12 = '2';
                    
                end
            end
            
        end
        
    end
    
    function moveLiveProfile(~)
        %will move the profile selected
        
        motionClickWithLeftClick = true;
        
        %current mouse position
        curMousePosition = get(roiAxes,'CurrentPoint');
        
        %offset to apply
        deltaX = curMousePosition(1,1) - pointRef(1,1);
        deltaY = curMousePosition(1,2) - pointRef(1,2);
        
        x1 = point1(1,1);
        y1 = point1(1,2);
        x2 = point2(1,1);
        y2 = point2(1,2);
        
        x1 = x1 + deltaX;
        y1 = y1 + deltaY;
        x2 = x2 + deltaX;
        y2 = y2 + deltaY;
        
        movingPoint1 = [x1 y1];
        movingPoint2 = [x2 y2];
        
        line([x1 x2],[y1 y2],'color','red');
        
    end
    
    function drawLiveProfile()
        %draw a line live with mouse moving
        
        motionClickWithLeftClick = true;
        livePoint = get(roiAxes, 'CurrentPoint');
        point2 = [livePoint(1,1) livePoint(1,2)];
        x1 = point1(1,1);
        x2 = point2(1,1);
        y1 = point1(1,2);
        y2 = point2(1,2);
        
        if x1 ~= x2 && y1 ~= y2
            
            line([x1 x2],[y1 y2],'color','red');
            
        end
        
    end
    
    function moveEdgeProfile(side)
        %will resize the rectangle by moving the left, right, top
        %or bottom edge
        
        motionClickWithLeftClick = true;
        
        %current mouse position
        curMousePosition = get(roiAxes,'CurrentPoint');
        
        switch side
            
            case 'point1'
                
                x1 = curMousePosition(1,1);
                y1 = curMousePosition(1,2);
                x2 = point2(1,1);
                y2 = point2(1,2);
                point1 = [x1, y1];
                movingPoint1 = point1;
                
            case 'point2'
                
                x1 = point1(1,1);
                y1 = point1(1,2);
                x2 = curMousePosition(1,1);
                y2 = curMousePosition(1,2);
                point2 = [x2, y2];
                movingPoint2 = point2;
                
        end
        
        line([x1 x2],[y1 y2],'color','red');
        
    end
    
    function newProfileSelection = formatProfileList()
        %this will format the profileSelection to populate the
        %listboxBAprofile list box of the main gui
        
        workingArray = {currentProfileList, ...
            roiRectangle, ...
            roiEllipse};
        
        circleStr = sprintf('circle%d',ellipseThickness);
%         circleStr = sprintf('circle');
        
        pref = {'line','rect',circleStr};
        newProfileSelection = {};
        index=1;
        
        for k=1:3
            
            tmpList = workingArray{k};
            sz = size(tmpList,2);
            for i=1:sz
                tmpProfile = tmpList{i};
                x1=int16(tmpProfile(1));
                y1=int16(tmpProfile(2));
                x2=int16(tmpProfile(3));
                y2=int16(tmpProfile(4));
                
                str = sprintf('%s:%s,%s,%s,%s',pref{k}, ...
                    num2str(x1), num2str(y1), ...
                    num2str(x2), num2str(y2));
                
                newProfileSelection{index} = str; %#ok<AGROW>
                index = index+1;
            end
            
        end
        
        
    end
    
end