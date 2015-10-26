function recalculateCombineImages(hObject)
    % Using the Basic analysis combine rois selected, this routine will
    % calculate the selected profiles of the selected images using the
    % methods selected (add, average and/or median)
    
    handles = guidata(hObject);
    
    signalSelection = handles.baCombineSignalSelection;
    backgroundSelection = handles.baCombineBackgroundSelection;
    % if signal or back ROI missing, we can not calculate the Signal/noise
    % ratio
    if isempty(signalSelection) || isempty(backgroundSelection)
        set(handles.textBAaddSNRvalue,'string','N/A');
        set(handles.textBAmedianSNRvalue,'string','N/A');
        set(handles.textBAsumSNRvalue,'string','N/A');
        return;
    end
    
    % make sure we have at least 2 files selected for add and average
    selection = get(handles.listboxDataFile,'value');
    sz_selection = (size(selection));
    nbr_selection = sz_selection(2);
    
    averageHandles = {handles.textBAaddSNRvalue, ...
        handles.textBAaddSBRvalue, ...
        handles.textBAaddSSDvalue, ...
        handles.textBAaddBSDvalue};
    medianHandles = {handles.textBAmedianSNRvalue, ...
        handles.textBAmedianSBRvalue, ...
        handles.textBAmedianSSDvalue, ...
        handles.textBAmedianBSDvalue};
    sumHandles = {handles.textBAsumSNRvalue, ...
        handles.textBAsumSBRvalue, ...
        handles.textBAsumSSDvalue, ...
        handles.textBAsumBSDvalue};
    
    if nbr_selection < 2
        for i=1:numel(averageHandles)
            set(averageHandles{i},'string','N/A');
        end
        for j=1:numel(medianHandles)
            set(medianHandles{j},'string','N/A');
        end
        for i=1:numel(sumHandles)
            set(sumHandles{j},'string','N/A');
        end
        return;
    end
    
    % Calculate combine of selection using Add algorithm
    calculateCombineImages(hObject, 'add');
    
    if nbr_selection < 3
        for j=1:numel(medianHandles)
            set(medianHandles{j},'string','N/A');
        end
        return;
    end
    
    % Calculate combine of selection using Median algorithm
    calculateCombineImages(hObject, 'median');
    
    % Calculate combine of selection using sum algorith
    calculateCombineImages(hObject, 'sum');
    
end

