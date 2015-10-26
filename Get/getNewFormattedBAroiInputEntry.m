function newEntry = getNewFormattedBAroiInputEntry(hObject)
   % This function will create the new string entry of the BA profile
   
   handles = guidata(hObject);
   
   field1 = strtrim(get(handles.baRoiInputLeft,'string'));
   field2 = strtrim(get(handles.baRoiInputTop,'string'));
   field3 = strtrim(get(handles.baRoiInputWidth,'string'));
   field4 = strtrim(get(handles.baRoiInputHeight,'string'));
   
   newEntry = ['r:' , field1 ',' field2 ',' field3 ',' field4];
    
end