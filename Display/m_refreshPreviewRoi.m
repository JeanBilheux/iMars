function m_refreshPreviewRoi(hObject, needsPreviewRefresh)
    % This function will refresh the Main preview according to the
    % tabs selected.
    % ex: if Normalization tab is selected, will display the ROI
    %     if Basic Analysis and Profile are selected, will display
    %     th profiles
    % needsPreviewRefresh can be turned on or off if we want or
    % not to refresh the preview
    
    if nargin<2
        needsPreviewRefresh = false;
    end
    
    if needsPreviewRefresh
        m_refreshPreviewImage(hObject);
    end
        
    handles = guidata(hObject);
    
    topTabSelected = getTopTabSelected(hObject);
    switch topTabSelected
        
        case 'Normalization'
            
            if ~isempty(handles.previousImageDomain)
                switchImageDomain(hObject, ...
                    handles.previousImageDomain);
                handles.previousImageDomain = '';
                guidata(hObject, handles);
                m_recalculateImageToDisplay(hObject,...
                    handles.activeListbox);
            end
            
            refreshPreviewNormalization(hObject);
            setImageDomain(hObject, 'on');
            
        case 'Analysis'
                        
            if ~isempty(handles.previousImageDomain)
                switchImageDomain(hObject, ...
                    handles.previousImageDomain);
                handles.previousImageDomain = '';
                guidata(hObject, handles);
                m_recalculateImageToDisplay(hObject, ...
                    handles.activeListbox);
            end
                        
            refreshPreviewBasicAnalysis(hObject);
            setImageDomain(hObject, 'on');
            
        case 'Segmentation'
            set(gcf,'pointer','watch');
            
            % switch the image domain to Intensity and
            % disable all the options
            switchImageDomainToIntensityMode(hObject)
            
            initSegmentationGui(hObject);
            updateSegmentationGui(hObject);
            refreshSegmentation(hObject);
            handles = guidata(hObject);
            handles = refreshPlotSavedThreshold(handles);
            refreshSegmentationPreview(handles);
            
            set(gcf,'pointer','arrow');
        
        case 'Alignment'
            
            if ~isempty(handles.previousImageDomain)
                switchImageDomain(hObject, ...
                    handles.previousImageDomain);
                handles.previousImageDomain = '';
                guidata(hObject, handles);
                m_recalculateImageToDisplay(hObject, ...
                    handles.activeListbox);
            end
            
            refreshAlignmentPreview(hObject);
            setImageDomain(hObject, 'on');
            checkAlignmentGui(hObject);
            
        otherwise
    end
    
end

function refreshPreviewBasicAnalysis(hObject)
    %refresh the preview with the profile or ROI of the Basic Analysis tab
    
    baTabSelected = getBasicAnalysisTabSelected(hObject);
    switch baTabSelected
        
        case 'Profile'
            updateBAprofileGUI(hObject,true);
            refreshPreviewBasicAnalysisProfile(hObject);
            updateBAprofile2d(hObject);
            
        case 'ROI'
            refreshPreviewBasicAnalysisRoi(hObject);
            m_updateManualBAroiSelection(hObject);
            updateBAroi2D(hObject);
            
        case 'Voids'
            updateBAvoids(hObject);
            
        case 'Geo. Correction'
            refreshPreviewBasicAnalysisCylinderSelection(hObject)
            updateBAgeoCorrection(hObject);
        
        case 'Combine'
            updateBAcombineGui(hObject);
            refreshBasicAnalysisPreviewCombineROI(hObject);
            recalculateCombineImages(hObject)
            checkBAcombineBatchModeGUI(hObject)
            
        otherwise
            
    end
    
end


