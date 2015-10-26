function newEntry = getNewFormattedBAprofileInputEntry(hObject)
   % This function will create the new string entry of the BA profile
   
   handles = guidata(hObject);
   
   if strcmpi(get(handles.textBAprofileManualWorkingType,'string'),'line')
       field1 = 'line';
   elseif strcmpi(get(handles.textBAprofileManualWorkingType,'string'),'rectangle')
       field1 = 'rect';
   else
       field1 = 'circle1';
   end
   
   field2 = strtrim(get(handles.editBAprofileManualX1input,'string'));
   field3 = strtrim(get(handles.editBAprofileManualY1input,'string'));
   field4 = strtrim(get(handles.editBAprofileManualX2orWidthInput,'string'));
   field5 = strtrim(get(handles.editBAprofileManualY2orHeightInput,'string'));
   
   newEntry = [field1 ':' field2 ',' field3 ',' field4 ',' field5];
    
end