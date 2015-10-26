function addOrReplaceBAprofileInputEntry(hObject, type)
    
    %this function will regroup the input informations and will replace them
    %with the current selected row in the profile list box
    
    handles = guidata(hObject);
    
    newEntry = getNewFormattedBAprofileInputEntry(hObject);
    
    %get full list of profiles
    [listProfile] = get(handles.listboxBAprofile,'string');
    
    if strcmp(type,'add')
        
        nbrProfile = numel(listProfile);
        listProfile{nbrProfile+1} = newEntry;
        
    else
        
        rowSelected = get(handles.listboxBAprofile,'value');
        listProfile{rowSelected} = newEntry;
        
    end
    
    set(handles.listboxBAprofile,'string',listProfile);
    
    updateBAprofile2d(hObject);
    m_refreshPreviewRoi(hObject, true);
    
end