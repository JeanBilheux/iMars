function checkAlignmentGui(hObject)
    
    handles = guidata(hObject);
    
    fileNames = handles.files.fileNames;
    if isempty(fileNames)
        set(handles.pushbuttonAlignmentPreviousImage,'enable','off');
        set(handles.pushbuttonAlignmentNextImage,'enable','off');
        return;
    end
    
    selection = get(handles.listboxDataFile,'value');
    nbrSelection = numel(selection);
    if (numel(fileNames) == 1) || (numel(fileNames) == nbrSelection)
        set(handles.pushbuttonAlignmentPreviousImage,'enable','off');
        set(handles.pushbuttonAlignmentNextImage,'enable','off');
        return;
    else
        
        statusPrev = 'on';
        statusNext = 'on';
        
        firstRowSelected = selection(1);
        if firstRowSelected == 1
            statusPrev = 'off';
        end
        
        lastRowSelected = selection(nbrSelection);
        if lastRowSelected == numel(fileNames)
            statusNext = 'off';
        end
        
        set(handles.pushbuttonAlignmentNextImage,'enable',statusNext);
        set(handles.pushbuttonAlignmentPreviousImage,'enable',statusPrev);
        
    end
    
end
