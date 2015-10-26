function checkMainTabsStatus(hObject)
    %This function will check if we are allowed to be on another tab
    %than the first one (Normalization). If there is no more data file
    %come back to first tab and deactivate the other ones
    
    handles = guidata(hObject);
    
    %number of data files left in the list box
    nbrDataFiles = handles.files.nbr;
    if nbrDataFiles > 0
        return
    end
    
    %current tab activated
    topTabSelected = getTopTabSelected(hObject);
    
    %if we are not on the first tab, come back to first one
    if ~strcmp(topTabSelected,'Normalization')
       m_toggleTabButton(hObject, 1);
    end
    
    %deactivate the other tabs
    m_activateRightGui(hObject,'off')
   
    m_activateMenu(hObject);
    
end