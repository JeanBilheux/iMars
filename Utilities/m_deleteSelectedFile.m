function m_deleteSelectedFile(hObject, sourceType)
    %This function will delete all the selected data
    % sourceType: ['data','openBeam','darkField']
    
    handles = guidata(hObject);
    
    listHandles = [handles.listboxDataFile, ...
        handles.listboxOpenBeam, ...
        handles.listboxDarkField];
    
    switch sourceType
        case 'data'
            listboxHandles = listHandles(1);
        case 'openBeam'
            listboxHandles = listHandles(2);
        case 'darkField'
            listboxHandles = listHandles(3);
    end
    
    listFile = get(listboxHandles,'string');
    [selection] = get(listboxHandles,'value');
    
    try
        
        listFile(selection) = [];
        set(listboxHandles,'string', listFile);
        
    catch err
        
        return
        
    end
    
    %make sure we are not overshooting the selection
    newSelection = get(listboxHandles,'value');
    %keep only last element selected
    if numel(newSelection) > 1
        newSelection = newSelection(end);
    end
    if newSelection > length(listFile)
        newSelection = length(listFile);
    end
    %          newSelection = 1;
    
    switch sourceType
        case 'data'
            handles.files.images(selection) = [];
            handles.files.nbr = length(listFile);
            handles.files.fileNames(selection) = [];
            handles.files.paths(selection) = [];
        case 'openBeam'
            handles.obfiles.images(selection) = [];
            handles.obfiles.nbr = length(listFile);
            handles.obfiles.fileNames(selection) = [];
            handles.obfiles.paths(selection) = [];
        case 'darkField'
            handles.dffiles.images(selection) = [];
            handles.dffiles.nbr = length(listFile);
            handles.dffiles.fileNames(selection) = [];
            handles.dffiles.paths(selection) = [];
    end
    
    guidata(hObject, handles);
    m_updateGuiAfterDelete(hObject, sourceType);
    
    function m_updateGuiAfterDelete(hObject, sourceType)
        %This function will check if there is still a data file
        %to previewed in the data list box, or the
        %open beam or dark field...if there is nothing more to display,
        %it will hide the preview
        
        handles = guidata(hObject);
        
        nbrDataFiles = handles.files.nbr;
        nbrOBFiles = handles.obfiles.nbr;
        nbrDFFiles = handles.dffiles.nbr;
        listNbrFiles = [nbrDataFiles, nbrOBFiles, nbrDFFiles];
        listDeleteButton = [handles.pushbuttonDataDelete, ...
            handles.pushbuttonOBdelete, ...
            handles.pushbuttonDFdelete];
        listSourceType = {'data','openBeam','darkField'};
        
        %determine the priority list
        %[sourceType, Data, DF or OB]
        switch sourceType
            case 'data'
                indexArray = [1,2,3];
            case 'openBeam'
                indexArray = [2,1,3];
            case 'darkField'
                indexArray = [3,1,2];
        end
        listNbrFiles = listNbrFiles(indexArray);
        listHandles = listHandles(indexArray);
        listSource = listSourceType(indexArray);
        listDelete = listDeleteButton(indexArray);
        
        if listNbrFiles(1) ~= 0
            set(listHandles(1),'value',newSelection);
            m_displayImage(hObject, listSource{1});
        else
            set(listHandles(1),'enable','off');
            set(listDelete(1),'visible','off');
            set(handles.pushbuttonNormalize,'enable','off');
            uicontrol(listHandles(2));
            if listNbrFiles(2) ~= 0
                m_displayImage(hObject, listSource{2});
            else
                set(listHandles(2),'enable','off');
                set(listDelete(2),'visible','off');
                uicontrol(listHandles(3));
                if listNbrFiles(3) ~= 0
                    m_displayImage(hObject, listSource{3});
                else
                    set(listHandles(3),'enable','off');
                    set(listDelete(3),'visible','off');
                    drawnow
                    %disable everything
                    m_activateRightGui(hObject,'off');
                    m_activateLeftGui(hObject,'off');
                end
            end
        end
        
    end
    
end
