function updateBAroi2D(hObject)
    % Update the 2D BA Roi plot
    
    handles = guidata(hObject);
    
    %get full list of roi
    [listRoi] = get(handles.listboxBAroi,'string');
    
    if isempty(listRoi)
        return
    end
    
    %get list of data file selected
    dataRowSelected = get(handles.listboxBAroi,'value');
    if dataRowSelected == 0
        return
    end
    
    axes(handles.axesBAroi);
    
    if get(handles.radiobuttonBAroiAllrois,'value')
        plotBAroiAllrois(hObject, listRoi(dataRowSelected));
    else
        plotBAroiEachRoi(hObject, listRoi(dataRowSelected));
    end
    
end

function plotBAroiEachRoi(hObject, listRoi)
    % Reached when the user select the
    % 'each selected ROI has its own point'
    
    handles = guidata(hObject);
    
    dataRowSelected = get(handles.listboxDataFile,'value');
    nbrDataFile = numel(dataRowSelected);
    dataImages = handles.files.images;
    
    [arrayHeight, arrayWidth] = size(dataImages{1});
    
    %if there is only 1 data file selected, we should plot
    %counts vs rois index
    
    if nbrDataFile > 1 %plot counts vs data files
        
        nbrListRoi = numel(listRoi);
        for k=1:nbrListRoi
            
            tmpListRoi = listRoi(k);
            roiLogicalArray = getBAroiLogicalArray(tmpListRoi, ...
                arrayWidth, arrayHeight);
            
            arrayOfImageRoisMean = [];
            globalMean = 0;
            for i=1:nbrDataFile
                
                tmpImage = dataImages{dataRowSelected(i)};
                bSaveNewMax = false;
                tmpImage = getImageForPreview(hObject, ...
                    tmpImage, 'data', bSaveNewMax);
                tmpImageInRoi = tmpImage(roiLogicalArray);
                tmpMean = mean(mean(tmpImageInRoi));
                arrayOfImageRoisMean(i) = tmpMean; %#ok<AGROW>
                globalMean = globalMean + tmpMean;
                
            end
            
            globalMean = globalMean / nbrDataFile;
            std = calculateStd(arrayOfImageRoisMean, globalMean);
            
            plot((1:nbrDataFile),arrayOfImageRoisMean, '--rs', ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','g');
            xlim([0,nbrDataFile+1]);
            [myYlim, myYlabel] = getYlimYlabel(hObject);
            if ~isempty(myYlim)
                ylim(myYlim);
            end
            xlabel('File #');
            ylabel(myYlabel);
            set(gca,'XTick', 0:nbrDataFile);
            
            if k==1
                hold on
            end
            
            tmpMean(1:(nbrDataFile+2)) = globalMean;
            tmpGlobalMean1 = tmpMean+std;
            tmpGlobalMean2 = tmpMean-std;
            
            newXaxis = 0:nbrDataFile+1;
            
            plot(newXaxis,tmpMean,'color','red');
            str = sprintf('Mean = %.3f', globalMean);
            text(nbrDataFile,tmpMean(nbrDataFile),str, ...
                'color','white',...
                'fontSize',13,...
                'backgroundcolor',[0 0.2 0.2], ...
                'fontWeight','bold');
            
            if nbrDataFile > 1
                
                plot(newXaxis, tmpGlobalMean1,'color','blue');
                str1 = sprintf('Mean+STD');
                text(nbrDataFile+0.2,tmpGlobalMean1(nbrDataFile), str1, ...
                    'color','white',...
                    'backgroundcolor',[0.5 1 0.3], ...
                    'fontWeight','bold');
                plot(newXaxis, tmpGlobalMean2,'color','blue');
                str2 = sprintf('Mean-STD');
                text(nbrDataFile+0.2,tmpGlobalMean2(nbrDataFile), str2, ...
                    'color','white',...
                    'backgroundcolor',[0.5 1 0.3], ...
                    'fontWeight','bold');
                
            end
            
        end %nbrListRoi
        
    else % plot counts vs rois
        
        arrayOfImageRoisMean = [];
        globalMean = 0;
        
        nbrListRoi = numel(listRoi);
        for k=1:nbrListRoi
            
            tmpListRoi = listRoi(k);
            roiLogicalArray = getBAroiLogicalArray(tmpListRoi, ...
                arrayWidth, arrayHeight);
            tmpImage = dataImages{dataRowSelected(1)};
            tmpImage = getImageForPreview(hObject, ...
                tmpImage, 'data');
            tmpImageInRoi = tmpImage(roiLogicalArray);
            tmpMean = mean(mean(tmpImageInRoi));
            arrayOfImageRoisMean(k) = tmpMean; %#ok<AGROW>
            globalMean = globalMean + tmpMean;
            
        end
        
        globalMean = globalMean / nbrListRoi;
        std = calculateStd(arrayOfImageRoisMean, globalMean);
        
        plot((1:nbrListRoi), arrayOfImageRoisMean, '--rs', ...
            'MarkerEdgeColor','k', ...
            'MarkerFaceColor','g');
        xlim([0,nbrListRoi+1]);
        [myYlim, myYlabel] = getYlimYlabel(hObject);
        if ~isempty(myYlim)
            ylim(myYlim);
        end
        xlabel('ROI #');
        ylabel(myYlabel);
        set(gca, 'XTick', 0:nbrListRoi);
        
        hold on
        
        tmpMean(1:(nbrListRoi+2)) = globalMean;
        tmpGlobalMean1 = tmpMean + std;
        tmpGlobalMean2 = tmpMean - std;
        
        newXaxis = 0:nbrListRoi+1;
        
        plot(newXaxis, tmpMean, 'color', 'red');
        str = sprintf('Mean = %.3f', globalMean);
        text(0.5, globalMean, str, ...
            'color','black',...
            'fontSize',13,...
            'fontWeight','bold');
        %         plot(newXaxis, tmpGlobalMean1,'color','blue');
        plot(newXaxis, tmpGlobalMean1,'color',[0.5 1 0.3]);
        
        %         str1 = sprintf('Mean+STD');
        %         text(nbrListRoi+0.2,tmpGlobalMean1(nbrListRoi), str1, ...
        %             'color','white',...
        %             'backgroundcolor',[0 0 0.5], ...
        %             'fontWeight','bold');
        plot(gca,newXaxis, tmpGlobalMean2,'color',[0.5 1 0.3]);
        %        plot(gca,newXaxis, tmpGlobalMean2,'color','blue');
        %         str2 = sprintf('Mean-STD');
        %         text(nbrListRoi+0.2,tmpGlobalMean2(nbrListRoi), str2, ...
        %             'color','white',...
        %             'backgroundcolor',[0 0 0.5], ...
        %             'fontWeight','bold');
        
    end
    
    hold off
    
end

function plotBAroiAllrois(hObject, listRoi)
    % Reached when the user select the
    % 'All selected ROI have the same data point'
    
    handles = guidata(hObject);
    
    dataRowSelected = get(handles.listboxDataFile,'value');
    nbrDataFile = numel(dataRowSelected);
    dataImages = handles.files.images;
    
    [arrayHeight,arrayWidth] = size(dataImages{1});
    roiLogicalArray = getBAroiLogicalArray(listRoi, arrayWidth, arrayHeight);
    
    arrayOfImageRoisMean = [];
    globalMean = 0;
    for i=1:nbrDataFile
        
        tmpImage = dataImages{dataRowSelected(i)};
        tmpImage = getImageForPreview(hObject, ...
            tmpImage, 'data');
        tmpImageInRoi = tmpImage(roiLogicalArray);
        tmpMean = mean(mean(tmpImageInRoi));
        arrayOfImageRoisMean(i) = tmpMean; %#ok<AGROW>
        globalMean = globalMean + tmpMean;
        
    end
    
    globalMean = globalMean / nbrDataFile;
    std = calculateStd(arrayOfImageRoisMean, globalMean);
    
    plot((1:nbrDataFile),arrayOfImageRoisMean, '--rs', ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','g');
    xlim([0,nbrDataFile+1]);
    [myYlim, myYlabel] = getYlimYlabel(hObject);
    if ~isempty(myYlim)
        ylim(myYlim);
    end
    xlabel('File #');
    ylabel(myYlabel);
    set(gca,'XTick', 0:nbrDataFile);
    
    hold on
    
    tmpMean(1:(nbrDataFile+2)) = globalMean;
    tmpGlobalMean1 = tmpMean+std;
    tmpGlobalMean2 = tmpMean-std;
    
    newXaxis = 0:nbrDataFile+1;
    
    plot(newXaxis,tmpMean,'color','red');
    str = sprintf('Mean = %.3f', globalMean);
    text(nbrDataFile+0.1,tmpMean(nbrDataFile),str, ...
        'color','white',...
        'fontSize',13,...
        'backgroundcolor',[0 0.2 0.2], ...
        'fontWeight','bold');
    
    if nbrDataFile > 1
        
        plot(newXaxis, tmpGlobalMean1,'color','blue');
        str1 = sprintf('Mean+STD');
        text(nbrDataFile+0.2,tmpGlobalMean1(nbrDataFile), str1, ...
            'color','white',...
            'backgroundcolor',[0.5 1 0.3], ...
            'fontWeight','bold');
        plot(newXaxis, tmpGlobalMean2,'color','blue');
        str2 = sprintf('Mean-STD');
        text(nbrDataFile+0.2,tmpGlobalMean2(nbrDataFile), str2, ...
            'color','white',...
            'backgroundcolor',[0.5 1 0.3], ...
            'fontWeight','bold');
        
    end
    
    hold off
    
end

function [myYlim, myYlabel] = getYlimYlabel(hObject)
    % will determine the y range according to the Image domain requested
    % if the array return is empty, just use autoscale.
    
    handles = guidata(hObject);
    
    display_type = getDisplayType(handles);
    
    switch (display_type)
        case 'radiobuttonIntensityValue'
            myYlabel = 'Intensity Values';
%             myYlim = [];
        case 'radiobuttonTransmissionPercent'
            myYlabel = 'Transmission %';
%             myYlim = [0 100];
        case 'radiobuttonAttenuation'
            myYlabel = 'Attenuation [0 1]';
%             myYlim = [0 1];
        case 'radiobuttonTransmissionIntensity'
            myYlabel = 'Transmission [0 1]';
%             myYlim = [0 1];
    end
    
    myYlim = [];  %auto scale for now
    
end


function roiLogicalArray = getBAroiLogicalArray(listRoi, arrayWidth, arrayHeight)
    % will return the logical arrays of all the regions selected
    
    nbrRois = numel(listRoi);
    roiLogicalArray = false(arrayHeight, arrayWidth);
    for i=1:nbrRois
        roiLogicalArray = getLogicalArrayFromRectangle(roiLogicalArray, listRoi{i});
    end
    
end

function roiLogicalArray = getLogicalArrayFromRectangle(roiLogicalArray, roi)
    
    expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
    [result] = regexp(roi, expression,'tokens');
    tmpFormatedRoi = result{1};
    
    roiLeft = str2double(tmpFormatedRoi(2));
    roiTop = str2double(tmpFormatedRoi(3));
    roiWidth = str2double(tmpFormatedRoi(4));
    roiHeight = str2double(tmpFormatedRoi(5));
    
    tmpTrue = true(roiHeight, roiWidth);
    roiLogicalArray(roiTop:(roiTop+roiHeight-1), roiLeft:(roiLeft+roiWidth-1)) = tmpTrue;
    
end