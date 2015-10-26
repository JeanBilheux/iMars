function segmentationTab_mouseAction(hObject, mouseAction)
    % reached when the segementation tab is selected and the
    % mouse moves over the main figure
    % mouseAction will be either mouseDown, mouseMove, mouseUp
    
    handles = guidata(hObject);
    
    % only care if the mouse is over the top axis (histogram)
    units_iMarsGUI = get(handles.iMarsGUI,'Units');
    set(handles.iMarsGUI,'Units','pixels');
    
    units_segmentHisto = get(handles.axesSegmentationHistogram,'Units');
    set(handles.axesSegmentationHistogram,'Units','pixels');
    axisPosition = get(handles.axesSegmentationHistogram, 'position');
    %position of uipanel
    set(handles.uipanelSegmentation,'Units','pixels');
    uipanelPosition = get(handles.uipanelSegmentation,'position');
    finalAxisPosition = [uipanelPosition(1)+axisPosition(1), ...
        uipanelPosition(2)+axisPosition(2), ...
        axisPosition(3), ...
        axisPosition(4)];
    
    %current mouse position
    curMousePosition = get(handles.iMarsGUI,'CurrentPoint');
    
    set(handles.iMarsGUI,'Units',units_iMarsGUI);
    set(handles.axesSegmentationHistogram,'Units',units_segmentHisto );
    set(handles.uipanelSegmentation,'Units',units_segmentHisto );
    
    %continue only if we are inside the plot
    curMouseX = curMousePosition(1);
    curMouseY = curMousePosition(2);
    
    axisX = finalAxisPosition(1);
    axisY = finalAxisPosition(2);
    axisWidth = finalAxisPosition(3);
    axisHeight = finalAxisPosition(4);
    
    if (curMouseX >= axisX) && ...
            (curMouseX <= (axisX + axisWidth)) && ...
            (curMouseY >= axisY) && ...
            (curMouseY <= (axisY + axisHeight))
        
        switch mouseAction
            case 'mouseDown'
                
                %disable the Export...
                set(handles.pushbuttonSegmentationRun,'enable','off');
                
                set(gcf,'pointer','watch');
                
                guidata(hObject, handles);
                recordLiveThresholdPositionType(hObject);
                refreshPlot(hObject);
                
                set(gcf,'pointer','arrow');
                
            otherwise
                return
        end
        
    end
    
    handles = guidata(hObject);
    refreshSegmentationPreview(handles, true);
    
end

function refreshPlot(hObject)
    %refresh the thresholds on the histogram plot
    
    handles = guidata(hObject);
    
    liveSelection = handles.liveThresholdValue;
    
    if isempty(liveSelection)
        return
    end
    
    %plot the thresholds
    handles = addLiveSegmentationThreshold(handles, true);
    guidata(hObject, handles);
    
    %plot the line of the live threshold
    liveThresholdValue = handles.liveThresholdValue;
    x = liveThresholdValue(1);
    y = handles.maxValueOfHistogramPlot;
    
    axes(handles.axesSegmentationThresholds);
    line([x x],[0,y],'color','blue', ...
        'lineWidth',2, ...
        'lineStyle','-.');
    drawnow
    
end


function recordLiveThresholdPositionType(hObject)
    % will record the position of the cursor and
    % the type of threshold (left or right exclusion)
    
    handles = guidata(hObject);
    
    units_segmentHisto = get(handles.axesSegmentationHistogram,'Units');
    
    %     if ~handles.isMouseButtonDown
    %         return
    %     end
    
    cursorPosition = get(handles.axesSegmentationThresholds, ...
        'CurrentPoint');
    
    liveXPosition = cursorPosition(1);
    
    handles.liveThresholdValue = [liveXPosition, ...
        handles.maxValueOfHistogramPlot];
    
    %     handles.liveThresholdValue
    
    set(handles.axesSegmentationThresholds,'Units',units_segmentHisto );
    
    guidata(hObject, handles);
    
    set(handles.pushbuttonAddLiveThreshold,'enable','on');
    set(handles.pushbuttonCancelLiveThreshold,'enable','on');
    
end







