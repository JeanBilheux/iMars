function displayType = getDisplayType(handles)
% return the tag of the button checked in the Image Domain UI panel

radioButtons = get(handles.uipanelImageDomain,'children');
displayType = 'radiobuttonIntensityValue';

if ~get(handles.radiobuttonIntensityValue,'enable')
    return
end

for i=1:4
    if (get(radioButtons(i),'Value'))
        displayType = get(radioButtons(i),'tag');
        return
    end
end
