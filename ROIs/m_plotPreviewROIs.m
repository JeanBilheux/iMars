function m_plotPreviewROIs(hObject, isRefresh)
    %This function will plot the ROI loaded in the ROI list box
    
    handles = guidata(hObject);
    
    if ~isRefresh %we need to parse ROI and populate cell arrays
        
%         roiRectangleSelection = handles.roiRectangleSelection;
%         isRoiRectangleEllipse = handles.isRoiRectangleEllipse;
        
        roiRectangleSelection = {};
        isRoiRectangleEllipse = {};

        [preLoadedRoi] = get(handles.listboxNormalizationRoi,'string');
        
        nbrRow = size(preLoadedRoi,1);
        if nbrRow > 0
            
            expression='([rc]):(\d+)[, ](\d+)[, ](\d+)[, ](\d+)';
            
            for i=1:nbrRow
                
                currentLine = preLoadedRoi{i};
                [solution] = regexp(currentLine,expression,'tokens');
                if strcmp(solution{1}(1),'r')
                    isRoiRectangleEllipse{i} = false; %#ok<AGROW>
                else
                    isRoiRectangleEllipse{i} = true; %#ok<AGROW>
                end
                
                roiRectangleSelection{i} = [str2double(solution{1}{2}) ...
                    str2double(solution{1}{3}) ...
                    str2double(solution{1}{4}) ...
                    str2double(solution{1}{5})]; %#ok<AGROW>
            end
            
        else %reset
            
            roiRectangleSelection = {};
            isRoiRectangleEllipse = {};
            
        end
        
        handles.roiRectangleSelection = roiRectangleSelection;
        handles.isRoiRectangleEllipse = isRoiRectangleEllipse;
        guidata(hObject, handles);
        
    end %end of ~isRefresh
    
    m_refreshPreviewImage(hObject);
    m_refreshPreviewRoi(hObject);
    
end