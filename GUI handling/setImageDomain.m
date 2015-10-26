function setImageDomain(hObject, ImageDomainStatus)
    
    handles = guidata(hObject);
    radioButtons = get(handles.uipanelImageDomain,'children');
    for i=1:4
        set(radioButtons(i), 'enable', ImageDomainStatus);
    end
    
end