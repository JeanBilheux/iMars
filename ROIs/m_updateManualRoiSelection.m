function m_updateManualRoiSelection(hObject)
    %This function will populate the Manual
    %ROI selection panel
    
    handles = guidata(hObject);
    
    [preLoadedRoi] = get(handles.listboxNormalizationRoi,'string');
    rowNbrSelected = get(handles.listboxNormalizationRoi,'value');
    
    %in case we removed the last entry
    if rowNbrSelected > length(preLoadedRoi)
        rowNbrSelected = rowNbrSelected-1;
    end
    
    if rowNbrSelected == 0
        set(handles.pushbuttonRoiReplace,'visible','off');
        set(handles.pushbuttonSaveRoi,'enable','off');
    else
        set(handles.pushbuttonRoiReplace,'visible','on');
        set(handles.pushbuttonSaveRoi,'enable','on');
    end
    
    %reset if no more roi in the list box
    if isempty(preLoadedRoi)
        set(handles.checkboxRoiRectangle,'value',1);
        set(handles.checkboxRoiEllipse,'value',0);
        set(handles.editRoiX0,'string','');
        set(handles.editRoiY0,'string','');
        set(handles.editRoiWidth,'string','');
        set(handles.editRoiHeight,'string','');
        set(handles.listboxNormalizationRoi,'enable','off');
        return
    else
        set(handles.listboxNormalizationRoi,'enable','on');
    end
    rowSelected = preLoadedRoi(rowNbrSelected);
    
    expression='([rc]):(\d+)[, ](\d+)[, ](\d+)[, ](\d+)';
    [solution] = regexp(rowSelected, expression, 'tokens');
    
    %rectangle or ellipse selection
    if strcmp(solution{1}{1}(1),'r')
        set(handles.checkboxRoiRectangle,'value',1);
        set(handles.checkboxRoiEllipse,'value',0);
    else
        set(handles.checkboxRoiRectangle,'value',0);
        set(handles.checkboxRoiEllipse,'value',1);
    end
    
    %collect x0,y0,width and height
    x0 = solution{1}{1}(2);
    y0 = solution{1}{1}(3);
    width = solution{1}{1}(4);
    height = solution{1}{1}(5);
    
    set(handles.editRoiX0,'string',x0);
    set(handles.editRoiY0,'string',y0);
    set(handles.editRoiWidth,'string',width);
    set(handles.editRoiHeight,'string',height);
   
end


