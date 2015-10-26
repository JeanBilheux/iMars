function deleteSelectedBAcombineListLine(hObject)
   % will remove the selected line when the user click Delete keys 
    
   handles = guidata(hObject);
   
   % make sure there is something to remove first
   listfile = get(handles.listboxBAcombineBatchListFiles,'string');
   
   if numel(listfile) == 0
       return
   end
   
   sz = size(listfile);
   if sz(1) == 1
       set(handles.listboxBAcombineBatchListFiles,'string','List of files to combine here');
       set(handles.listboxBAcombineBatchListFiles,'value',1);
       return
   end
   
   lineselected = get(handles.listboxBAcombineBatchListFiles,'value');
   if lineselected > 1
       set(handles.listboxBAcombineBatchListFiles,'value',lineselected-1);
   end
   listfile(lineselected) = [];
   set(handles.listboxBAcombineBatchListFiles,'string',listfile);
   
end