function initExportSegmentationListbox(hObject)
   
    handles = guidata(hObject);
    handlesMainGui = handles.handlesMainGui;
    hObjectMainGui = handles.hObjectMainGui;
    
    listFiles = handlesMainGui.files.fileNames;
    
    set(handles.listboxExportSegmentation,'string',listFiles);
    
end