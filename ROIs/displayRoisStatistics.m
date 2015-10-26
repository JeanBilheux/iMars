function [newRoiInfoFigureId, roiInfoHandles] = displayRoisStatistics(roiInfoFigureId, ...
        roiInfoHandles, ...
        defaultPath, ...
        roiRectangle, ...
        isRoiRectangleEllipse, ...
        image)
    % This function will pop up a figure with a list box (if not
    % already there) and will display various metadata (mean values,
    % total counts, number of pixels...) about the ROIs selected
    
    newRoiInfoFigureId = roiInfoFigureId;
    
    %if no ROI, stop right there
    if isempty(roiRectangle)
        return
    end
    
    if roiInfoFigureId == -1 %never opened yet
        
        launchRoiInfoFigure();
        
    else %make sure the figure is still alive
        
        try
            
            findobj(roiInfoHandles.figure1);
            
        catch errMessage %#ok<NASGU>
            
            launchRoiInfoFigure();
            
        end
        
    end
    
    [height, width] = size(image);
    
    %define table
    cNames = {'ROI#','Area (pixels)','Mean','Min','Max','Total Counts'};
    cFormat = {'numeric','numeric','numeric','numeric','numeric','numeric'};
    cEditable = [false false false false false false];
    dataTable = {};
    
    nbrRoi = numel(roiRectangle);
    for i=1:nbrRoi
        
        roiLogicalArray = false(height, width);
        if isRoiRectangleEllipse(i)
            roiLogicalArray = getLogicalArrayFromEllipse(roiLogicalArray, ...
                roiRectangle{i});
        else
            roiLogicalArray = getLogicalArrayFromRectangle(roiLogicalArray, ...
                roiRectangle{i});
        end
        
        %roi number
        dataTable{i,1} = i; %#ok<AGROW>
        
        %number of pixels
        
        dataTable{i,2} = numel(roiLogicalArray(roiLogicalArray == 1));%#ok<AGROW>
        
        %mean
        imageRoi = image(roiLogicalArray);
        dataTable{i,3} = mean(mean(imageRoi));%#ok<AGROW>
        
        %min
        dataTable{i,4} = min(min(imageRoi));%#ok<AGROW>
        
        %max
        dataTable{i,5} = max(max(imageRoi));%#ok<AGROW>
        
        %total counts
        dataTable{i,6} = sum(sum(imageRoi));%#ok<AGROW>
        
    end
    
    set(roiInfoHandles.uitableRoiInfo,'ColumnName',cNames);
    set(roiInfoHandles.uitableRoiInfo,'ColumnFormat',cFormat);
    set(roiInfoHandles.uitableRoiInfo,'ColumnEditable',cEditable);
    set(roiInfoHandles.uitableRoiInfo,'Data',dataTable);
    
    newRoiInfoFigureId = roiInfoFigureId;
    
    function launchRoiInfoFigure()
        % This function will launch the Roi Menu figure table
        
        myRoiInfo = roiInfo(roiRectangle, isRoiRectangleEllipse, image, defaultPath);
        
        newId = int16(rand()*cputime());
        strId = sprintf('id#%d',newId);
        set(myRoiInfo,'Tag',strId);
        roiInfoFigureId = newId;
        
        roiInfoHandles = guidata(myRoiInfo);
        
    end
    
end