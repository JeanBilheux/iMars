function switchImageDomain(hObject, newImageDomain)
    
    handles = guidata(hObject);
    
    radioButtons = get(handles.uipanelImageDomain,'children');
    for i=1:4
        tmpTag = get(radioButtons(i),'tag');
        if strcmp(tmpTag, newImageDomain)
            set(radioButtons,'value',1);
            return
        end
    end
    
end