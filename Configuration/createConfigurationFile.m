function createConfigurationFile(hObject, fullFileName, ~)
%using the fullFileName passed as an argument, this function will
%create the config file
    
    updateHandlesToSave(hObject);
    handles = guidata(hObject);
    
    message = ['Saving Configuration File: ' ...
        fullFileName];
    statusBarMessage(hObject, message, 5, false);
    
    save(fullFileName,'-struct','handles');
    
%     handles.path = pathName;
%     guidata(hObject, handles);
    
end

function updateHandlesToSave(hObject)
    %this function takes care of saving the last pieces necessary to
    %create the configuration
    
    handles = guidata(hObject);
    
    handles.listboxNormalizationRoiString = get(handles.listboxNormalizationRoi,'string');
    handles.listboxNormalizationRoiRowSelection = get(handles.listboxNormalizationRoi,'value');
    handles.listboxBAprofileString = get(handles.listboxBAprofile,'string');
    handles.listboxBAprofileSelection = get(handles.listboxBAprofile,'value');
    handles.listboxBAroiString = get(handles.listboxBAroi,'string');
    handles.listboxBAroiSelection = get(handles.listboxBAroi,'value');
    handles.listboxBAcombineString = get(handles.listboxBAcombineBatchListFiles,'string');
    handles.isBAcombineAverageSelected = get(handles.radiobuttonBAcombineBatchAverage,'value');
    handles.BAcombineBaseFileName = get(handles.editBAcombineBatchBaseFileName,'string');
    handles.BAcombineGroupNumber = get(handles.editBAcombineBatchNbrFiles,'string');
    handles.outputPathnameOfBAcombine = get(handles.editBAcombineBatchPath,'string');
    handles.normalizationBatchListDataFiles = get(handles.listboxNormalizationBatchListOfFiles,'string');
    handles.normalizationBatchOutputFolder = get(handles.editNormalizationBatchFolder,'string');
    handles.normalizationBatchBaseFileName = get(handles.editNormalizationBatchBaseFileName,'string');
    handles.gammaFilteringFlag = get(handles.checkboxGammaFilteringFlag,'value');
    handles.alignmentMarkersTable = get(handles.uitableAlignmentMarkers','Data');
    handles.mcpFlag = get(handles.fileMenuMCPflag,'checked');
    
    guidata(hObject, handles);
    
end