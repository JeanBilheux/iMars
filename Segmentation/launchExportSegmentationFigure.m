function launchExportSegmentationFigure(hObject)
   % This will launch the Export Segmentation GUI
   % that will allow the user to select which
   % files he wants to segment and where the output will
   % be created
    
   handles = guidata(hObject);
   exportSegmentationFigure(hObject, handles);
    
end