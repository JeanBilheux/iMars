function setBatchModeMode(hObject, type)
    % will make sure that the user can not select both add and median
    % to combine his images in the batch mode of the combine tab
    
    handles = guidata(hObject);
    
    switch type
        case 'average'
            averageStatus = 1;
            medianStatus = 0;
            fullStatus = 0;
        case 'median'
            averageStatus = 0;
            medianStatus = 1;
            fullStatus = 0;
        case 'sum'
            averageStatus = 0;
            medianStatus = 0;
            fullStatus = 1;
    end
    set(handles.radiobuttonBAcombineBatchAverage,'value',averageStatus);
    set(handles.radiobuttonBAcombineBatchMedian,'value',medianStatus);
    set(handles.radiobuttonBAcombineBatchSum,'value',fullStatus);
    
end
