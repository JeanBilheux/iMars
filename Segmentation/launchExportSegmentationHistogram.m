function launchExportSegmentationHistogram(hObject)
    % This function will launch the Export Histogram Segmentation GUI
    % that will allow the user to select which 
    % files he wants to histogrammed and get as an ascii.
    
    handles = guidata(hObject);
    exportSegmentationGui = exportSegmentationHistogramFigure(hObject, handles);
    handles.exportSegmentationGui = exportSegmentationGui;
    guidata(hObject, handles);
    
end