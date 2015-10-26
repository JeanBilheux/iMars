function launchSegmentationEditThreshold(hObject)
   %Will launch the Segmentation Threshold manual editor to life
   
   handles = guidata(hObject);
   editThresholdGui = segmentationEditThresholds(hObject, handles);
   handles.editThresholdGui = editThresholdGui;
   guidata(hObject, handles);

end