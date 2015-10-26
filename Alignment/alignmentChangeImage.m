function alignmentChangeImage(hObject, type)
    % type is 'next' or 'prev'
    
    handles = guidata(hObject);
    handles.blockAlignmentButton = true;
    guidata(hObject, handles);
   
    try
        
        % get current selection of data list
        selection = get(handles.listboxDataFile,'value');
        nbrSelection = numel(selection);
        
        switch nbrSelection
            case 1 % only 1 file selected
                rowSelected = selection(1);
                switch type
                    case 'prev'
                        if ~get(handles.pushbuttonAlignmentPreviousImage,'enable')
                            return;
                        end
                        newSelection = rowSelected-1;
                        set(handles.listboxDataFile,'value',newSelection);
                        m_displayImage(hObject,'data');
                    case 'next'
                        if ~get(handles.pushbuttonAlignmentNextImage,'enable')
                            return;
                        end
                        newSelection = rowSelected+1;
                        set(handles.listboxDataFile,'value', newSelection);
                        m_displayImage(hObject,'data');
                end
            otherwise % more than 1 file selected
                
                fileNames = handles.files.fileNames;
                nbrFiles = numel(fileNames);
                
                switch type
                    case 'next'
                        
                        if ~get(handles.pushbuttonAlignmentNextImage,'enable')
                            return;
                        end
                        
                        % get last row selected
                        lastRowSelected = selection(end);
                        if lastRowSelected == nbrFiles
                            return;
                        end
                        
                        % if we don't have enough files to keep the same selection
                        % range, just select all the last files
                        if (lastRowSelected + 1 + nbrSelection) > nbrFiles
                            newSelection = (lastRowSelected+1):nbrFiles;
                        else
                            newSelection = (lastRowSelected+1):(lastRowSelected+nbrSelection);
                        end
                        
                    case 'prev'
                        
                        if ~get(handles.pushbuttonAlignmentPreviousImage,'enable')
                            return
                        end
                        
                        % get first row selected
                        firstRowSelected = selection(1);
                        if firstRowSelected == 1
                            return;
                        end
                        
                        % if we don't have enough files to keep the same
                        % selection range, just select all the first files
                        if nbrSelection > (firstRowSelected-1)
                            newSelection = 1:(firstRowSelected-1);
                        else
                            newSelection = (firstRowSelected-nbrSelection):(firstRowSelected-1);
                        end
                        
                end
                
                set(handles.listboxDataFile,'value', newSelection);
                checkAlignmentGui(hObject);
                m_displayImage(hObject,'data');
                
        end
        
    catch err
    end
    
    
end