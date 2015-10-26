function colormapSelection(hObject, ~)
    %will make sure only the colormap selected is checked
    
    handles = guidata(hObject);
    
    %checked only the selected menu button
    listChildren = get(handles.colormapMenu,'children');
    sz = numel(listChildren);
    for i=1:sz
        set(listChildren(i),'checked','off');
    end
    set(hObject,'checked','on');

    handles.colormap = get(hObject,'Label');
    guidata(hObject, handles);

    m_refreshPreviewRoi(hObject, true);
    
end