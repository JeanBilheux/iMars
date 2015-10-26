function changeScale(hObject, type)
    % switch scale buttons
   
    handles = guidata(hObject);
    
    switch (type)
        case 'linear'
            linearStatus = 1;
            logStatus = 0;
        case 'log'
            linearStatus = 0;
            logStatus = 1;
    end
    
    set(handles.radiobuttonScaleLinear,'value',linearStatus);
    set(handles.radiobuttonScaleLog,'value',logStatus);
    drawnow;
    
end