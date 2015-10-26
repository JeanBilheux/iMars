function m_activateLeftGui(hObject, forceStatus)
    %hactivate (status = 'on') or not (status = 'off')
    %left side of GUI
    
    handles = guidata(hObject);
    
    if nargin == 2
        status = forceStatus;
    else
        if handles.files.nbr > 0
            status = 'on';
        else
            status = 'off';
        end
    end
    
    %hide the Preview axes
    listPreviewChildren = get(handles.axesPreview,'children');
    if (handles.preview.imshow ~= 0)
        set(handles.preview.xlabel,'visible',status);
%         set(handles.preview.ylabel,'visible',status);
        set(handles.preview.colorbar,'visible',status);
        set(handles.preview.imshow,'visible',status);
    end
    if ~isempty(listPreviewChildren)
        set(listPreviewChildren(:),'visible',status);
    end
    
    set(handles.axesPreview, 'visible', status);
    
    
    %disable the list box
    set(handles.listboxDataFile, 'enable', status);
    
    kids2 = get(handles.uipanelImageDomain, 'children');
    set(kids2(1:4), 'enable', status);
    
    %display delete button
    delete_icon = imread('UtilityFiles/delete.jpg','jpg');
    set(handles.pushbuttonDataDelete,'CData',delete_icon, ...
        'visible',status);
end