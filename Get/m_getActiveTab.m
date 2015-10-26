function [status, activeButton] = m_getActiveTab(hObject)
    %This will return the current active tab
    %['', 'normalization','basicAnalysis, segmentation','alignment']
    %'' is when the tabs are inactived
    
    handles = guidata(hObject);
    %array of toggle buttons
    toggleArray = [handles.toggleNormalization, ...
        handles.toggleBasicAnalysis, ...
        handles.toggleSegmentation, ...
        handles.toggleAlignment];
    
    if strcmp(get(toggleArray(1),'enable'),'off')
        status = 'off';
    else
        status = 'on';
    end
    
    activeIndex = -1;
    for i=1:length(toggleArray)
        if get(toggleArray(i),'value') == 1
            activeIndex = i;
        end
    end
    
    switch activeIndex
        case 1
            activeButton = 'normalizaton';
        case 2
            activeButton = 'basicAnalysis';
        case 3
            activeButton = 'segmentation';
        case 4
            activeButton = 'alignment';
        otherwise
            activeButton = '';
    end
    
end