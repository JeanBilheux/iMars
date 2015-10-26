function statusBarMessage(hObject, message, displayTime, isError)
    %This functionwill display the given message in the bottom status bar
    %of the GUI and will remove it after 'displayTime' seconds.
    %Input:
    %  hObject
    %  message       message to display
    %  displayTime   how long the message will be displ`ayed. 
    %                a value of 0 will keep the message until it's 
    %                manually removed
    %  isError       if it is, display the message in red
    
    handles = guidata(hObject);
    
    if isError
        set(handles.statusBar,'ForegroundColor',[1 0 0]);
        set(handles.movingProgressBar,'visible','off');
        set(handles.backgroundProgressBar,'visible','off');
    end
    
    set(handles.statusBar,'string',message);
    
    if displayTime ~= 0
        handles.sbTimer = timer('StartDelay', displayTime, ...
            'TimerFcn', {@timerFcn_callBack hObject});
        start(handles.sbTimer);
    end
    
    guidata(hObject, handles);
    
end

function timerFcn_callBack(~, ~, hObject)
    %clean up the status bar
    
    handles = guidata(hObject);
    set(handles.statusBar,'string','','ForegroundColor',[0 0 0]);
    
end