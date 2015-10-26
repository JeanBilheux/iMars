function closeAllFigure(handles)
%Will make sure that all the independent windows are closed before
%leaving the main program

    % Normalization ROI and Basic Analysis ROI
    if isfield(handles,'figroi') && ishandle(handles.figroi)
        delete(handles.figroi);
    end

    % Basic Analysis profile
    if isfield(handles,'figprofile') && ishandle(handles.figprofile)
        delete(handles.figprofile);
    end
    
    % geometry correction
    if isfield(handles,'figgeo') && ishandle(handles.figgeo)
        delete(handles.figgeo);
    end
    
    % edit Threshold in segmentation tab
    if isfield(handles,'editThresholdGui') && ishandle(handles.editThresholdGui)
        delete(handles.editThresholdGui);
    end
    
    % export segmentation preview and histogram
    if isfield(handles,'exportSegmentationGui') && ishandle(handles.exportSegmentationGui)
        delete(handles.exportSegmentationGui);
    end
    
end