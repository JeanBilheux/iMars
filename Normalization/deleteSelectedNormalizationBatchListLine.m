function deleteSelectedNormalizationBatchListLine(hObject)
   % will remove the selected line when the user click Delete keys 
    
   handles = guidata(hObject);
   
   % make sure there is something to remove first
   listfile = get(handles.listboxNormalizationBatchListOfFiles,'string');
   
   if numel(listfile) == 0
       return
   end
   
   sz = size(listfile);
   if sz(1) == 1
       set(handles.listboxNormalizationBatchListOfFiles,'string','list of data files');
       set(handles.listboxNormalizationBatchListOfFiles,'value',1);
       return
   end
   
   lineselected = get(handles.listboxNormalizationBatchListOfFiles,'value');
   if lineselected > 1
       set(handles.listboxNormalizationBatchListOfFiles,'value',lineselected-1);
   end
   listfile(lineselected) = [];
   set(handles.listboxNormalizationBatchListOfFiles,'string',listfile);
   
end