function m_toggleTabButtonHandles(handles, indexSelected)
    
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
    m_activateRightGuiHandles(handles);
    
end
    
    