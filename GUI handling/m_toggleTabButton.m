function m_toggleTabButton(hObject, indexSelected)
    % toggle the right tab button and ui panel
    
    handles = guidata(hObject);
    
    %array of toggle buttons
    toggleArray = [handles.toggleNormalization, ...
        handles.toggleBasicAnalysis, ...
        handles.toggleSegmentation, ...
        handles.toggleAlignment];
    
    %array of uipanel
    toggleUIpanel = [handles.uipanelNormalization, ...
        handles.uipanelBasicAnalysis, ...
        handles.uipanelSegmentation, ...
        handles.uipanelAlignment];
    
    m_toggleGeneralTab(toggleArray, toggleUIpanel, indexSelected);
    
    m_activateRightGui(hObject);
    
end

