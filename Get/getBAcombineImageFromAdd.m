function combineImage = getBAcombineImageFromAdd(hObject)
    
    handles = guidata(hObject);
    
    selection = get(handles.listboxDataFile,'value');
    sz_selection = (size(selection));
    nbr_selection = sz_selection(2);
    if nbr_selection < 2
        combineImage = [];
        return;
    end
    
    combineImage = handles.currentImagePreviewed;
    
end