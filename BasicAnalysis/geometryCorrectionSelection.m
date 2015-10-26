function geometryCorrectionSelection(hObject)
    
    % Select one or several line to get profile
    % and provide the possibility to move, resize and delete any
    % of the profile at any time.
    % Input
    %    hObject
    %    profileSelection: {'circle4:81,52,226,225'}
    
    handles = guidata(hObject);
    
    %-- variable that will be used in the selection tool only
    leftClick = false; %status of the left click
    %     motionClickWithLeftClick = false;
    point1 = [-1 -1];
    point2 = [-1 -1];
    selectionPoint1 = [-1 -1];
    selectionPoint2 = [-1 -1];
    selectedColormap = handles.colormap;
    
    %     pointRef = [-1 -1]; %position to refer to in order to move rectangle
    
    image = handles.currentImagePreviewed;
    %     images = handles.files.images;
    %     image = images{1}
    [imageHeight, imageWidth] = size(image);
    
    %     pointer = 'crosshair'; %cursor shape
    
    %     currentProfileList = {};
    %     previousActiveProfileIndex = -1;
    activeProfileIndex = -1;
    
    cylinderX1Y1X2Y2 = handles.cylinderX1Y1X2Y2;
    secondCylinderX1Y1X2Y2 = handles.secondCylinderX1Y1X2Y2;
    if isempty(cylinderX1Y1X2Y2)
        buttonEnable = 'off';
    else
        buttonEnable = 'on';
    end
    radiusMainCylinder = 0;
    secondCylinderOffset = 1;
    
    % narrow calculation region flag
    calculationRegionFlag = false;
    calculationRegion = handles.calculationRegion;
    
    ScreenSize = get(0,'ScreenSize');
    figWidth = 800;
    figHeight = 800;
    figX = (ScreenSize(3)-figWidth)/2;
    figY = (ScreenSize(4)-figHeight)/2;
    
    figgeo = figure('menubar','none','position',[figX, figY, figWidth, figHeight]);
    handles.figgeo = figgeo;
    guidata(hObject, handles);
    ht = uitoolbar(figgeo);
    
    minus_icon = imread('UtilityFiles/minus_sign.jpg','jpg');
    plus_icon = imread('UtilityFiles/plus_sign.jpg','jpg');
    selection_icon = imread('UtilityFiles/working_selection.jpg','jpg');
    delete_selection_icon = imread('UtilityFiles/working_selection_delete.jpg','jpg');
    
    % icons for helping plot
    viewHelper = imread('UtilityFiles/geoCorrectionHelperPlot.jpg','jpg');
    
    minusTool = uipushtool(ht,'CData', minus_icon, ...
        'tooltipstring','Decrease the 2nd cylinder edge radius', ...
        'tag', 'cylinder_minus_button',...
        'enable',buttonEnable);
    plusTool = uipushtool(ht,'CData', plus_icon, ...
        'tooltipstring','Increase the 2nd cylinder edge radius', ...
        'tag', 'cylinder_plus_button', ...
        'enable',buttonEnable);
    selectionTool = uitoggletool(ht,'CData', selection_icon, ...
        'tooltipstring','Select the region where the calculation should be performed (will speed up the calculation)', ...
        'tag', 'selection_button',...
        'state','off', ...
        'separator', 'on');
    deleteSelectionTool = uipushtool(ht,'CData', delete_selection_icon, ...
        'tooltipstring','Reset the calculation region', ...
        'tag', 'selection_button');
    
    drawnow;
    
    % define the callback functions of the toolbar
    set(minusTool, ...
        'clickedCallback', {@clickedminusCylinderTool});
    set(plusTool, ...
        'clickedCallback', {@clickedplusCylinderTool});
    set(selectionTool, ...
        'clickedCallback', {@clickedSelectionTool});
    set(deleteSelectionTool, ...
        'clickedCallback', {@clickedDeleteSelectionTool});
    
    %create an axes object
    roiAxes = axes();
    set(roiAxes, ...
        'tickdir','out', ...
        'position',[0 0.2 0.8 0.8]);
    helperPlotxaxis = axes();
    set(helperPlotxaxis, ...
        'position',[0 0 0.8 0.2]);
    set(helperPlotxaxis,'xtick',[],'ytick',[]);
    helperPlotyaxis = axes();
    set(helperPlotyaxis, ...
        'position',[0.8 0.2 0.2 0.8]);
    set(helperPlotyaxis,'xtick',[],'ytick',[]);
    
    %set figure properties
    set(figgeo, 'numbertitle','off',...
        'name','CLICK first edge and DRAG to second edge to define CYLINDER!', ...
        'units','normalized', ...
        'pointer','crosshair', ...
        'WindowButtonMotionFcn',{@hFigure_MotionFcn, hObject}, ...
        'WindowKeyPressFcn',{@hFigure_KeyPressFcn, hObject}, ...
        'WindowButtonDownFcn', {@hFigure_DownFcn, hObject}, ...
        'WindowButtonUpFcn', {@hFigure_UpFcn, hObject}, ...
        'CloseRequestFcn', {@hFigure_closeRequestFcn, hObject});
    
    RoiRefreshImage (hObject); %plot the image
    colormap(selectedColormap);
    
    function clickedDeleteSelectionTool(~,~)
        % this will reset the selection region
        calculationRegion = [];
        RoiRefreshImage (hObject);
    end
    
    function checkPlusMinusToolbarStatus()
        if isempty(cylinderX1Y1X2Y2)
            buttonEnable = 'off';
        else
            buttonEnable = 'on';
        end
        set(minusTool,'enable',buttonEnable);
        set(plusTool,'enable',buttonEnable);
    end
    
    function clickedSelectionTool(~,~)
        % triggered by the selection button
        % will allow the user to narrow the region of calculation
        % this will increase the calculation speed
        
        if strcmp(get(selectionTool,'state'),'on')
            calculationRegionFlag = true;
        else
            calculationRegionFlag = false;
        end
    end
    
    function clickedminusCylinderTool(~,~)
        % triggered by the minus button
        % will decrease the radius of the 2nd cylinder edge
        
        % refresh background image and current selection
        determineSecondCylinder('minus');
        RoiRefreshImage (hObject);
        
    end
    
    function clickedplusCylinderTool(~,~)
        % triggered by the plus button
        % will increase the radius of the 2nd cylinder edge
        
        % refresh background image and current selection
        determineSecondCylinder('plus');
        RoiRefreshImage (hObject);
        
    end
    
    function determineSecondCylinder(type)
        % will get the current second cylinder infos and
        % will apply the type ('plus' or 'minus') to it before
        
        tmp_xy12 = num2cell(cylinderX1Y1X2Y2);
        [x1,y1,x2,y2] = tmp_xy12{:};
        
        % recalculate radius of main cylinder
        radiusMainCylinder = getDistancePointToPoint(x1,y1,x2,y2) / 2.;
        
        % determine center coordinates
        xc = (x1+x2)/2.;
        yc = (y1+y2)/2.;
        
        % calculate new second cylinder offset
        switch (type)
            case 'minus'
                secondCylinderOffset = secondCylinderOffset - 1;
            case 'plus'
                secondCylinderOffset = secondCylinderOffset + 1;
        end
        
        if secondCylinderOffset == 0
            secondCylinderX1Y1X2Y2 = [];
            return;
        end
        
        % determine intersections between (radius+secondCylinderOffset)
        % and line that goes through (x1,y1) and (x2,y2)
        new_radius = radiusMainCylinder + secondCylinderOffset;
        secondCylinderX1Y1X2Y2 = getIntersectionCircleLine(xc, yc, new_radius, cylinderX1Y1X2Y2);
        
    end
    
    
    %% DownFcn
    function hFigure_DownFcn(~, ~, ~)
        %user click mouse (left or right)
        leftClick = true;
        
        livePoint = get(roiAxes,'CurrentPoint');
        
        if calculationRegionFlag
            selectionPoint1 = [livePoint(1,1) livePoint(1,2)];
            calculationRegion = [];
        else
            point1 = [livePoint(1,1) livePoint(1,2)];
            cylinderX1Y1X2Y2 = [];
            secondCylinderOffset = 1;
        end
        RoiRefreshImage();
        
    end
    
    %% UpFcn
    function hFigure_UpFcn(~, ~, hObject)
        
        RoiRefreshImage (hObject); %plot the image
        plotLivePosition();
        drawLiveProfile();
        leftClick = false;
        
        if calculationRegionFlag
            addRegion();
        else
            addProfile();
            checkPlusMinusToolbarStatus();
        end
    end
    
    %% MotionFcn (Mouse is moving)
    function hFigure_MotionFcn(~, ~, hObject)
        %This function is reached any time the mouse is moving over the figure
        
        RoiRefreshImage (hObject); %plot the image
        plotLivePosition();
        
        if leftClick %we need to draw something
            drawLiveProfile();
        end
        
    end
    
    %% KeyPressFcn
    function hFigure_KeyPressFcn(hObject, eventdata, ~)
        
        switch eventdata.Key
            case 'delete'
                removeProfileToList(activeProfileIndex);
                RoiRefreshImage (hObject);
            case 'backspace'
                removeProfileToList(activeProfileIndex);
                RoiRefreshImage (hObject);
            otherwise
                
        end
    end
    
    function plotLivePosition()
        % plot the live position of the cursor (horizontal and vertical
        % lines)
        
        try
            axes(roiAxes);
            hold on;
            
            livePoint = get(roiAxes, 'CurrentPoint');
            x=livePoint(1,1);
            y=livePoint(1,2);
            
            if x>0 && x<=imageWidth
                plot([x,x],[0,imageHeight],'color','white',...
                    'linewidth',1, 'linestyle','--');
            end
            
            if y>0 && y<=imageHeight
                plot([0,imageWidth],[y,y],'color','white', ...
                    'linewidth',1, 'linestyle','--');
            end
            
            hold off;
            
            % display projections
            if x>0 && x<=imageWidth
                xprojection = image(fix(y),:);
                plot(helperPlotxaxis, 1:imageWidth, xprojection, ...
                    [x x],[0 max(xprojection(:))]);
                drawnow;
            end
            
            if y>0 && y<=imageHeight
                yprojection = image(:,fix(x));
                plot(helperPlotyaxis, 1:imageHeight, yprojection, ...
                    [y y],[0 max(yprojection(:))]);
                set(helperPlotyaxis,'ytick',[],'xtick',[]);
                view(helperPlotyaxis,[-90,-90]);
                drawnow;
            end
            %
        catch errMess
        end
        
    end
    
    %% RoiRefreshImage
    function RoiRefreshImage (~)
        %Refresh the image plot and the profile plot
        
        %get current saved image to preview
        axes(roiAxes);
        img = image;
        imagesc(img);
        set(roiAxes,'xtick',[],'ytick',[]);
        drawnow;
        
        if ~isempty(cylinderX1Y1X2Y2)
            
            cylinderXY = num2cell(cylinderX1Y1X2Y2);
            [x1,y1,x2,y2] = cylinderXY{:};
            
            line([x1 x2],[y1 y2],'color','red','linewidth',2);
            drawCylinderEdges(x1,x2,y1,y2);
            
            set(minusTool,'enable','on');
            set(plusTool,'enable','on');
            
            if ~isempty(secondCylinderX1Y1X2Y2)
                
                secondCylinderXY = num2cell(secondCylinderX1Y1X2Y2);
                [x1,y1,x2,y2] = secondCylinderXY{:};
                
                line([x1 x2],[y1 y2], 'color','blue','linewidth',2);
                drawCylinderEdges(x1,x2,y1,y2,'blue');
                
            end
            
        end
        
        if ~isempty(calculationRegion)
            
            region = num2cell(calculationRegion);
            [x1,y1,x2,y2] = region{:};
            
            w = abs(x1-x2);
            h = abs(y1-y2);
            
            rectangle('position',[x1 y1 w h], ...
                'lineWidth', 1, ...
                'edgeColor', 'red', ...
                'lineStyle', ':');
            
        end
        
    end
    
    function formatCylindricalPosition()
        % make sure the [x1,y1,x2,y2] is format with x1 < x2
        
        if ~isempty(secondCylinderX1Y1X2Y2)
            secondCylinderXY = num2cell(secondCylinderX1Y1X2Y2);
            [x1,y1,x2,y2] = secondCylinderXY{:};
            if (x2 < x1)
                secondCylinderX1Y1X2Y2 = [x2,y2,x1,y1];
            end
        end
        
    end
    
    %% CloseRequestFcn
    function hFigure_closeRequestFcn(hFigure, ~, hObject)
        %this function will record all the profiles and
        % rectangles and will transform
        %into a cell array for the main gui
        
        formatCylindricalPosition();
        
        recordCylindricalPostion(hObject, cylinderX1Y1X2Y2, ...
            secondCylinderX1Y1X2Y2, ...
            calculationRegion);
        try
            findobj(viewHelperHandles.figure1);
            delete(viewHelperHandles.figure1);
        catch errMessage %#ok<NASGU>
            
        end
        delete(hFigure);
        drawnow update;
        updateBAgeoCorrection(hObject);
        
    end
    
    function addProfile()
        % save the cylindrical profile
        cylinderX1Y1X2Y2 = [point1(1,1) point1(1,2) point2(1,1) point2(1,2)];
        secondCylinderX1Y1X2Y2 = [];
    end
    
    function addRegion()
        % save the calculation region
        calculationRegion = [selectionPoint1(1,1) selectionPoint1(1,2) selectionPoint2(1,1) selectionPoint2(1,2)];
    end
    
    function drawLiveProfile()
        %draw a line live with mouse moving
        
        axes(roiAxes);
        livePoint = get(roiAxes, 'CurrentPoint');
        
        if calculationRegionFlag
            
            selectionPoint2 = [livePoint(1,1) livePoint(1,2)];
            x1 = selectionPoint1(1,1);
            x2 = selectionPoint2(1,1);
            y1 = selectionPoint1(1,2);
            y2 = selectionPoint2(1,2);
            
            % make sure we really have a rectangle
            if x1 ~= x2 && y2 ~= y1
                
                w = abs(x2-x1);
                h = abs(y2-y1);
                
                rectangle('position',[x1 y1 w h], ...
                    'lineWidth', 2, ...
                    'edgeColor', 'red', ...
                    'lineStyle', ':');
                
            end
            
        else
            
            point2 = [livePoint(1,1) livePoint(1,2)];
            x1 = point1(1,1);
            x2 = point2(1,1);
            y1 = point1(1,2);
            y2 = point2(1,2);
            
            if x1 ~= x2
                
                line([x1 x2],[y1 y2],'color','red','linewidth',2);
                drawCylinderEdges(x1,x2,y1,y2);
                
            end
            
        end
    end
    
    function drawCylinderEdges(x1,x2,y1,y2,color)
        % this function display the edges of the cylinder
        
        if nargin < 5
            color='red';
        end
        
        [a1,b1] = getPerpendicularEquation([x1,y1,x2,y2],[x1,y1]);
        [a2,b2] = getPerpendicularEquation([x1,y1,x2,y2],[x2,y2]);
        
        if ~isinf(a1)
            
            [x1_per_1, y1_per_1, x2_per_1, y2_per_1] = getLineExtremities(a1,b1,imageWidth);
            [x1_per_2, y1_per_2, x2_per_2, y2_per_2] = getLineExtremities(a2,b2,imageWidth);
            
        else
            
            x1_per_1 = x1;
            x2_per_1 = x1;
            y1_per_1 = 0;
            y2_per_1 = imageHeight;
            
            x1_per_2 = x2;
            x2_per_2 = x2;
            y1_per_2 = 0;
            y2_per_2 = imageHeight;
            
        end
        
        line([x1_per_1 x2_per_1],[y1_per_1 y2_per_1], 'color',color, ...
            'linewidth',2);
        line([x1_per_2 x2_per_2],[y1_per_2 y2_per_2], 'color',color, ...
            'linewidth',2);
        
    end
    
end