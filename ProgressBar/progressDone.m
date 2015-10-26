function progressDone(hObject)
    
    handles = guidata(hObject);
    
    displayTime = 3;  %in seconds
    handles.progressTimer = timer('StartDelay', displayTime, ...
        'TimerFcn', {@progressFcn_callBack hObject});
    start(handles.progressTimer);

    guidata(hObject, handles);
    
end

function progressFcn_callBack(~, ~, hObject)
    %remove progress bars foreground and background
    
    handles = guidata(hObject);
    
    set(handles.movingProgressBar,'visible','off');
    set(handles.backgroundProgressBar,'visible','off');
    set(handles.backgroundProgressBar,'string','');
    
end