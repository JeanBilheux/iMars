function m_activateRightGuiHandles(handles,forceStatus)
    %right side of GUI
    
    if nargin == 2
        status = forceStatus;
    else
        nbrData = handles.files.nbr;
        if nbrData > 0
            status = 'on';
        else
            status = 'off';
        end
    end
    
    set(handles.toggleNormalization, 'enable', status);
    set(handles.toggleBasicAnalysis, 'enable', status);
    set(handles.toggleSegmentation, 'enable', status);
    set(handles.toggleAlignment, 'enable', status);
    
    [status, activeButton] = m_getActiveTabHandles(handles);
    
    switch activeButton
        case 'normalizaton'
            m_activateNormalizationWidgets(handles, status);
        case 'Basic analysis'
        case 'Segmentation'
        case 'alignment'
        otherwise
            m_activateNormalizationWidgets(handles, status);
    end
    
end
