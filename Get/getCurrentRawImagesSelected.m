function imageSelected = getCurrentRawImagesSelected(hObject)
    % will return an image of the image(s) selected
    
    handles = guidata(hObject);
    
    %get the file(s) currently selected
    activeListBox = handles.listboxDataFile;
    fileHandles = handles.files;
    selection = get(activeListBox,'value');
    sz_selection = (size(selection));
    nbr_selection = sz_selection(2);
    
    imageSelected = fileHandles.images{selection(1)};
    if nbr_selection > 1
        for i=2:nbr_selection
            imageSelected = imageSelected + fileHandles.images{selection(i)};
        end
    end
    
end