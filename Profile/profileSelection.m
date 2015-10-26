function profileSelection(hObject)
   % This function is reached by the Profile button of the BA ui panel
   % and will collect the previously selected profile (if any) and 
   % will pass it to the Profile Selection Tool GUI
   
   handles = guidata(hObject);
   profileSelection = get(handles.listboxBAprofile,'string');

   m_selectProfile(hObject, profileSelection);
    
end
