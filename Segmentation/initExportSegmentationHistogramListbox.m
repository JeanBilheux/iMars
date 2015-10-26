function initExportSegmentationHistogramListbox(hObject)
   
    handles = guidata(hObject);
    handlesMainGui = handles.handlesMainGui;
    
    listFiles = handlesMainGui.files.fileNames;
    
    set(handles.listboxExportSegmentationHistogram,'string',listFiles);
    
end