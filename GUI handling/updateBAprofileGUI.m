function updateBAprofileGUI(hObject, ~)
    %this will check what has to be visible or not
    % if keepSelection is not defined, false by default.
    
    handles = guidata(hObject);
    
    listProfile = get(handles.listboxBAprofile,'string');
    if isempty(listProfile)
        statusOnOff = 'off';
        newSelection = 0;
        set(handles.listboxBAprofile,'value',newSelection);
    else
        statusOnOff = 'on';
        if nargin<2
            newSelection = 1;
            set(handles.listboxBAprofile,'value',newSelection);
        end
    end
    
    set(handles.axesBAprofile,'visible',statusOnOff);
    set(handles.pushbuttonBAexportProfile,'enable', statusOnOff);
    set(handles.BAprofileLabel,'visible',statusOnOff);

   updateBAprofileInputGUI(hObject);
    
end