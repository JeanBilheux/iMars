function updateBAvoids(hObject)
   % will use the current selecet data file and will display
   % histogram, mask...etc
    
    handles = guidata(hObject);

   % get first image selected and display histogram
   images = handles.files.images;
   
   selection = get(handles.listboxDataFile,'value');
   firstSelection = selection(1);
   
   workingImage = images{firstSelection};
   newImage = mat2gray(workingImage);
   
   handles.BAvoidsWorkingImage = newImage;
   guidata(hObject, handles);
   
   [counts, x] = imhist(newImage);
   axes(handles.axesBAvoidsHistoRawImage);
   plot(x,counts);
   
   updateBAvoidsMaskHistogram(hObject);
   
end