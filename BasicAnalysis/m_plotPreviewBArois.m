function m_plotPreviewBArois(hObject, isRefresh)
    %This function will plot the ROI loaded in the ROI list box
    
    %%REMOVE ME   
    %looks like this file is not used
    
    return
   
    
    handles = guidata(hObject);
    
    if ~isRefresh %we need to parse ROI and populate cell arrays
        
        baRoiRectangleSelection = {};

        [preLoadedRoi] = get(handles.listboxBAroi,'string');
        
        nbrRow = size(preLoadedRoi,1);
        if nbrRow > 0
            
            expression='([rc]):(\d+)[, ](\d+)[, ](\d+)[, ](\d+)';
            
            for i=1:nbrRow
                
                currentLine = preLoadedRoi{i};
                [solution] = regexp(currentLine,expression,'tokens');
                
                roiRectangleSelection{i} = [str2double(solution{1}{2}) ...
                    str2double(solution{1}{3}) ...
                    str2double(solution{1}{4}) ...
                    str2double(solution{1}{5})]; %#ok<AGROW>
            end
            
        end
        
        handles.baRoiRectangleSelection = baRoiRectangleSelection;
        guidata(hObject, handles);
        
    end %end of ~isRefresh
    
    m_refreshPreviewImage(hObject);
    m_refreshPreviewRoi(hObject);
    
end