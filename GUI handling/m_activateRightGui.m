function m_activateRightGui(hObject,forceStatus)
    %right side of GUI
    
    handles = guidata(hObject);
    
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
    
    [status, activeButton] = m_getActiveTab(hObject);
    
    switch activeButton
        case 'normalizaton'
            m_activateNormalizationWidgets(handles, status);
        case 'Basic analysis'
        case 'Segmentation'
        case 'alignment'
            initializeAlignmentTable(handles)
        otherwise
            m_activateNormalizationWidgets(handles, status);
    end
    
end
