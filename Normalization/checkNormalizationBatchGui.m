function checkNormalizationBatchGui(hObject)
    
    handles = guidata(hObject);
    
    colorFieldMissing = [1,0,0];
    colorFieldOk = [0.929, 0.929, 0.929];
    
    colorStatusWrong = [1,0,0];
    colorStatusOk = [0,1,0];
    
    bAtLeastOneFieldMissing = false;
    
    % check output folder
    outputFolder = get(handles.editNormalizationBatchFolder,'string');
    if isempty(outputFolder) || (exist(outputFolder,'dir') == 0)
        color = colorFieldMissing;
        bAtLeastOneFieldMissing = true;
    else
        color = colorFieldOk;
    end
    set(handles.editNormalizationBatchFolder,'backgroundColor', color);
    
    % base file name
    baseFileName = get(handles.editNormalizationBatchBaseFileName,'string');
    if isempty(baseFileName)
        color = colorFieldMissing;
        bAtLeastOneFieldMissing = true;
    else
        color = colorFieldOk;
    end
    set(handles.editNormalizationBatchBaseFileName,'backgroundcolor', ...
        color);
    
    % data file status
    listFiles = get(handles.listboxNormalizationBatchListOfFiles,'string');
    sz = size(listFiles);
     if ((sz(1)==1) && strcmp(listFiles,'list of data files'))
        color = colorFieldMissing;
        bAtLeastOneFieldMissing = true;
     else
        color = colorFieldOk;
     end  
    set(handles.listboxNormalizationBatchListOfFiles,'backgroundcolor', ...
        color);
    
    % open beam status
    openBeam = handles.obfiles.nbr;
    if openBeam == 0
        color = colorStatusWrong;
        bAtLeastOneFieldMissing = true;
    else
        color = colorStatusOk;
    end
    set(handles.textNormalizationStatusOpenBeam,'foregroundcolor',color);
    
    % dark field status
    darkField = handles.dffiles.nbr;
    if darkField == 0
        color = colorStatusWrong;
        bAtLeastOneFieldMissing = true;
    else
        color = colorStatusOk;
    end
    set(handles.textNormalizationBatchDarkField,'foregroundcolor',color);
    
%     % ROI
%     roi = get(handles.listboxNormalizationRoi,'string');
%     if isempty(roi)
%         color = colorStatusWrong;
%         bAtLeastOneFieldMissing = true;
%     else
%         color = colorStatusOk;
%     end
%     set(handles.textNormalizationBatchRoi,'foregroundcolor',color);
     
    if bAtLeastOneFieldMissing
        status = 'off';
    else
        status = 'on';
    end
    set(handles.pushbuttonNormalizationBatchRun,'enable',status);
    
end