function refreshBasicAnalysisPreviewCombineROI(hObject)
    % will plot the BA combine rois selected
    
    handles = guidata(hObject);
    
    axes(handles.axesPreview);
    
    % signal
    baCombineSignalSelection = handles.baCombineSignalSelection;
    if isempty(baCombineSignalSelection)
        return;
    end
    
    sz = size(baCombineSignalSelection,2);
    for i=1:sz
        
        tmpRoi = baCombineSignalSelection{i};
        
        x = tmpRoi(1);
        y = tmpRoi(2);
        w = tmpRoi(3);
        h = tmpRoi(4);
        
        rectangle('position',[x,y,w,h], ...
            'linewidth', 1, ...
            'edgecolor','blue');
        
%         % display label at the last corner of the profile box
%         str = sprintf('#%d',i);
%         xPos = x+w-65;
%         yPos = y+h-40;
%         text(xPos, yPos, str, 'color', 'red');
        
    end
    
    % background
    baCombineBackgroundSelection = handles.baCombineBackgroundSelection;
    if isempty(baCombineBackgroundSelection)
        return;
    end
    
    sz = size(baCombineBackgroundSelection,2);
    for i=1:sz
        
        tmpRoi = baCombineBackgroundSelection{i};
        
        x = tmpRoi(1);
        y = tmpRoi(2);
        w = tmpRoi(3);
        h = tmpRoi(4);
        
        rectangle('position',[x,y,w,h], ...
            'linewidth', 1, ...
            'edgecolor','red');
        
%         % display label at the last corner of the profile box
%         str = sprintf('#%d',i);
%         xPos = x+w-65;
%         yPos = y+h-40;
%         text(xPos, yPos, str, 'color', 'blue');
        
    end
    
end