function refreshPreviewBasicAnalysisRoi(hObject)
    %refresh the preview with ROI selected in the normalization tab
    
    handles = guidata(hObject);
    
    drawnow
    listRoi = get(handles.listboxBAroi,'string');
    if isempty(listRoi)
        return
    end
    
    rowSelected = get(handles.listboxBAroi,'value');
    if rowSelected == 0
        return
    end
    roiSelection = listRoi(rowSelected);

    formatedRoiSelection = {};
    if ~isempty(roiSelection)
        nbrRoi = size(roiSelection,1);
        expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
        for i=1:nbrRoi
            [result] = regexp(roiSelection{i},...
                expression,'tokens');
            formatedRoiSelection{i} = result{1}; %#ok<AGROW>
        end
    end
    
    sz = size(formatedRoiSelection,2);
    if sz > 0
        for i=1:sz
            
            tmpRoi = formatedRoiSelection{i};
            
            x1 = str2double(tmpRoi(2));
            y1 = str2double(tmpRoi(3));
            w = str2double(tmpRoi(4));
            h = str2double(tmpRoi(5));
            
            rectangle('position',[x1, y1, w, h], ...
                'lineWidth',1, ...
                'edgeColor','blue');
        end
    end
end
