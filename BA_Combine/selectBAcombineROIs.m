function selectBAcombineROIs(hObject)
    % will allow the user to select one or more SIGNAL regions
    % and one or more BACKGROUND regions
    
    handles = guidata(hObject);
    selectedColormap = handles.colormap;
    
    %-- variable that will be used in the selection tool only
    leftClick = false; %status of the left click
    motionClickWithLeftClick = false;
    point1 = [-1 -1];
    point2 = [-1 -1];
    lastRectangle = [-1 -1 -1 -1]; %last rectangle ploted
    rectangleInitialPosition  = [-1 -1 -1 -1]; %rectangle to move
    pointRef = [-1 -1]; %position to refer to in order to move rectangle
%     roiRectangle = handles.baCombineSelection;
    roiSignalRectangle = handles.baCombineSignalSelection;
    roiBackgroundRectangle = handles.baCombineBackgroundSelection;
    
    signalColor = 'blue';
    backgroundColor = 'red';
    
    currentSelectionType = 'signal';
    
%     activeSignalRectangleIndex = -1;
%     activeBackgroundRectangleIndex = -1;
    activeRectangleIndex = -1;
    
    previousActiveRectangleIndex = -1;
    
    image = handles.currentImagePreviewed;
    [imageHeight, imageWidth] = size(image);
    
    %['top','bottom','right','left','topl','topr','botl','botr','hand'
    pointer = 'crosshair'; %cursor shape
    
    %-----------------------------------------------------
    
    ScreenSize = get(0,'ScreenSize');
    figWidth = 800;
    figHeight = 800;
    figX = (ScreenSize(3)-figWidth)/2;
    figY = (ScreenSize(4)-figHeight)/2;
    
    figroi = figure('menubar','none',...
        'position',[figX, figY, figWidth, figHeight]);
    handles.figroi = figroi;
    
    ht=uitoolbar(figroi);
    
    signal_icon = imread('UtilityFiles/signal.jpg','jpg');
    back_icon = imread('UtilityFiles/background.jpg','jpg');
    
    signalTool = uitoggletool(ht, 'CData', signal_icon, ...
        'TooltipString','Select region from signal', ...
        'State','on', ...
        'tag', 'signal_roi');
    
    backTool = uitoggletool(ht, 'CData', back_icon, ...
        'TooltipString','Select region from background', ...
        'State','off', ...
        'tag', 'background_roi');
    
    drawnow
    
    %define the callback functions of the toolbar
    set(signalTool, ...
        'clickedCallback', {@clickedSignalTool});
    set(backTool, ...
        'clickedCallback', {@clickedBackgroundTool});
    
    %create an axes object
    roiAxes = axes();
    set(roiAxes, ...
        'tickdir','out', ...
        'position',[0 0 1 1]);
    
    %set figure properties
    set(figroi, 'numbertitle','off',...
        'name','ROI Selection Tool', ...
        'units','normalized', ...
        'pointer','crosshair', ...
        'WindowButtonMotionFcn',{@hFigure_MotionFcn, hObject}, ...
        'WindowKeyPressFcn',{@hFigure_KeyPressFcn, hObject}, ...
        'WindowButtonDownFcn', {@hFigure_DownFcn, hObject}, ...
        'WindowButtonUpFcn', {@hFigure_UpFcn, hObject}, ...
        'CloseRequestFcn', {@hFigure_closeRequestFcn, hObject});
    
    % set(handles.roiHaxes,'XAxisLocation','top');
    guidata(hObject, handles);
    
    RoiRefreshImage (hObject); %plot the image
    
    % next threee functions make sure that the toggleTool
    % behave the way they suppose to
    % when one is pressed, the other should be depressed
    function clickedSignalTool(~, ~)
        clickedToggleButton('signal');
        currentSelectionType = 'signal';
    end
    
    function clickedBackgroundTool(~, ~)
        clickedToggleButton('background');
        currentSelectionType = 'background';
    end
    
    function clickedToggleButton(button)
        switch (button)
            case 'signal'
                signal_status = 'on';
                background_status = 'off';
            case 'background'
                signal_status = 'off';
                background_status = 'on';
        end
        set(signalTool,'state',signal_status);
        set(backTool,'state',background_status);
    end
    
    
    %% RoiRefreshImage
    function RoiRefreshImage (~)
        %Refresh the image plot
        
        %get current saved image to preview
        axes(roiAxes);
        img = image;
        colormap(selectedColormap);
        imagesc(img);
        
        sz = size(roiSignalRectangle,2);
        if sz > 0
            for i=1:sz
                
                %roi #
                %                 roiNbr = sprintf('#%d',i);
                
                rect = roiSignalRectangle{i};
                
                rectangle('position',rect,...
                    'lineWidth',1, ...
                    'edgeColor',signalColor);
                %                 text(rect(1)+15,rect(2)+15,roiNbr,...
                %                     'color','yellow', ...
                %                     'fontWeight','bold');
                
                if strcmp(currentSelectionType,'signal') && ...
                        activeRectangleIndex == i
                    
                    cornerRectangles = getCornerRectangles(roiSignalRectangle{i});
                    for j=1:8
                        rectangle('position',cornerRectangles{j},...
                            'lineWidth',1, ...
                            'edgeColor',signalColor);
                    end
                end
                
            end
        end
        
        sz = size(roiBackgroundRectangle,2);
        if sz > 0
            for i=1:sz
                
                %roi #
                %                 roiNbr = sprintf('#%d',i);
                
                rect = roiBackgroundRectangle{i};
                
                rectangle('position',rect,...
                    'lineWidth',1, ...
                    'edgeColor',backgroundColor);
                %                 text(rect(1)+15,rect(2)+15,roiNbr,...
                %                     'color','yellow', ...
                %                     'fontWeight','bold');
                
                if strcmp(currentSelectionType,'background') && ...
                        activeRectangleIndex == i
                    
                    
                    cornerRectangles = getCornerRectangles(roiBackgroundRectangle{i});
                    for j=1:8
                        rectangle('position',cornerRectangles{j},...
                            'lineWidth',1, ...
                            'edgeColor',backgroundColor);
                    end
                end
                
            end
            
        end
        
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
        
        switch currentSelectionType
            case 'signal'
                color = signalColor;
            case 'background'
                color = backgroundColor;
        end
        rectangle('position',lastRectangle,...
            'lineStyle','--',...
            'lineWidth',1, ...
            'edgeColor',color);
        
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
        
        switch currentSelectionType
            case 'signal'
                color = signalColor;
            case 'background'
                color = backgroundColor;
        end
        rectangle('position',lastRectangle,...
            'lineStyle','--',...
            'lineWidth',1, ...
            'edgeColor',color);
        
    end
    
    %% MotionFcn
    function hFigure_MotionFcn(~, ~, hObject)
        %This function is reached any time the mouse is moving over the figure
        
        %         try
        
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
            set(figroi, 'pointer',pointer);
            
            %refresh plot only if something changed
            if previousActiveRectangleIndex ~= activeRectangleIndex
                RoiRefreshImage(hObject);
                previousActiveRectangleIndex = activeRectangleIndex;
            end
            
        end
        
        %         catch errMessage %#ok<NASGU>
        %
        %             %do nothing
        %
        %         end
        
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
        
        switch currentSelectionType
            case 'signal'
                % check first within the signal array
                sz = size(roiSignalRectangle,2);
                if sz > 0
                    for i=1:sz
                        [isOverRectangle, isEdge, whichEdge_trbl] = ...
                            isMouseOverEdge(point, roiSignalRectangle{i});
                        if isOverRectangle
                            yesItIs = true;
                            index = i;
                            currentSelectionType = 'signal';
                            return
                        end
                    end
                end
            case 'background'
                % check background signal array now
                sz = size(roiBackgroundRectangle,2);
                if sz > 0
                    for i=1:sz
                        [isOverRectangle, isEdge, whichEdge_trbl] = ...
                            isMouseOverEdge(point, roiBackgroundRectangle{i});
                        if isOverRectangle
                            yesItIs = true;
                            index = i;
                            currentSelectionType = 'background';
                            return
                        end
                    end
                end
            otherwise
        end
        
    end
    
    function [result, isEdge, whichEdge_trbl] = isMouseOverEdge(point, rectangle)
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
    
    function addLastRectangleToListRectangle
        %add the last rectangle ROI to the list of Rectangle ROIs
        
        switch currentSelectionType
            case 'signal'
                sz = size(roiSignalRectangle,2);
                roiSignalRectangle{sz+1} = lastRectangle;
%                 activeSignalRectangleIndex = sz+1;
            case 'background'
                sz = size(roiBackgroundRectangle,2);
                roiBackgroundRectangle{sz+1} = lastRectangle;
%                 activeBackgroundRectangleIndex = sz+1;
        end
        
    end
    
    function removeRectangleToList(index)
        % no rectangle selected, just return
        if index == -1
            return;
        end
        %remove the rectangle at the index given
        switch currentSelectionType
            case 'signal'
                if isempty(roiSignalRectangle)
                    return
                end
                roiSignalRectangle(index) = [];
            case 'background'
                if isempty(roiBackgroundRectangle)
                    return
                end
                roiBackgroundRectangle(index) = [];
        end
    end
    
    %% DownFcn
    function hFigure_DownFcn(~, ~, hObject)
        leftClick = true;
        units = get(roiAxes,'units');
        set(roiAxes,'units','normalized');
        point1 = get(roiAxes,'CurrentPoint');
        set(roiAxes,'units',units);
        
        %we need to keep record of the exact position of active rectangle
        if ~strcmp(pointer,'crosshair')
            switch currentSelectionType
                case 'signal'
                    rectangleInitialPosition = roiSignalRectangle{activeRectangleIndex};
                case 'background'
                    rectangleInitialPosition = roiBackgroundRectangle{activeRectangleIndex};
            end
            lastRectangle = rectangleInitialPosition;
            %get reference position
            pointRef = get(roiAxes,'CurrentPoint');
            removeRectangleToList(activeRectangleIndex);
            activeRectangleIndex = -1;
            moveLiveRectangle(hObject);
        end
        
    end
    
    %% UpFcn
    function hFigure_UpFcn(~, ~, hObject)
        leftClick = false;
        if motionClickWithLeftClick
            %add last rectangle to list of rectangle ROIs
            addLastRectangleToListRectangle();
            RoiRefreshImage(hObject);
        end
        motionClickWithLeftClick = false;
    end
    
    function cornerRectangles = getCornerRectangles(currentRectangle)
        %this function will create a [8x4] array of the corner
        %rectangles used to show the user that it can resize the ROI
        
        cornerRectangles = {};
        
        x = currentRectangle(1);
        y = currentRectangle(2);
        w = currentRectangle(3);
        h = currentRectangle(4);
        
        ratio = 2/100;
        wBox = ratio*imageWidth;
        hBox = ratio*imageHeight;
        
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
        
        switch currentSelectionType
            case 'signal'
                color = signalColor;
            case 'background'
                color = backgroundColor;
        end
        
        rectangle('position',[x,y,w,h],...
            'lineStyle','--',...
            'lineWidth',1, ...
            'edgeColor',color);
        
        set(roiAxes,'units',units);
        
    end
    
    %% KeyPressFcn
    function hFigure_KeyPressFcn(~, eventdata, ~)
        
        switch eventdata.Key
            
            case 'delete'
                removeRectangleToList(activeRectangleIndex);
                RoiRefreshImage (hObject);
            case 'backspace'
                removeRectangleToList(activeRectangleIndex);
                RoiRefreshImage (hObject);
            otherwise
        end
        
    end
    
    
    %% closeRequestFcn
    function hFigure_closeRequestFcn(hFigure, ~, hObject)
        %this function will record all the ROIs and will transform them
        %into a pixels axis
        
        handles.baCombineSignalSelection = roiSignalRectangle;
        handles.baCombineBackgroundSelection = roiBackgroundRectangle;
        
        guidata(hObject, handles);
        m_refreshPreviewRoi(hObject, true);
        
        delete(hFigure);
        
    end
    
end