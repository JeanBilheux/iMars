function combineImage = getBAcombineImageFromMedian(hObject)
    
    handles = guidata(hObject);
    
    selection = get(handles.listboxDataFile,'value');
    sz_selection = (size(selection));
    nbr_selection = sz_selection(2);
    if nbr_selection < 3
        combineImage = [];
        return;
    end
    
    lastString = get(handles.saveSessionMessageTag,'String');
    set(handles.saveSessionMessageTag,'String',{'PROCESSING CALCULATION ...','','Please Be Patient!'});
    set(handles.saveSessionMessageTag,'visible','on');
    drawnow update;
    
    images = handles.files.images;
    
    [height,width] = size(images{1});
    
    % init final image
    combineImage = zeros(size(images{1}));
    parfor h=1:height
        for w=1:width
            listCounts = zeros(1,nbr_selection);
            for f=1:nbr_selection
                tmp_image = images{selection(f)};
                listCounts(f) = tmp_image(h,w);
                medianValue = getMedianValue(listCounts);
                combineImage(h,w) = medianValue;
            end
        end
    end
    
    set(handles.saveSessionMessageTag,'visible','off');
    set(handles.saveSessionMessageTag,'String',lastString);
    drawnow update;
    
end