function refreshSegmentation(hObject, isRefreshOnly)
    % will display the histogram of the data selected, using
    % the selected filters and the preview of the resulting histogram
    % By the default, the histogram is recalculated, but if the
    % user turn on the isRefreshOnly, the save histogram will be
    % used instead
    
    handles = guidata(hObject);
    
    if nargin < 2
        isRefreshOnly = false;
    end
    
    % get the list of data file selected
    finalImage = handles.currentImagePreviewed;
    
    %make sure the right axis is activated
%     axes(handles.axesSegmentationHistogram);
    
    if ~isRefreshOnly
        
        minXaxis = 0;
        maxXaxis = max(finalImage(:));
        tmpHist = double(finalImage);
%         minValue = min(tmpHist(:));
        maxValue= max(tmpHist(:));
                
        % to go between 0 and 1
        tmpHist = tmpHist / maxXaxis;
                
%         xZoomMin = get(handles.editSegmentationMinValue,'string');
%         if isempty(xZoomMin)
            xZoomMin = minXaxis;
            value = sprintf('%d',xZoomMin);
            set(handles.editSegmentationMinValue,'string',value);
%         else
%             xZoomMin = str2double(xZoomMin);
%         end
        
%         xZoomMax = get(handles.editSegmentationMaxValue,'string');
%         if isempty(xZoomMax)
            xZoomMax = maxXaxis;
            value = sprintf('%d',xZoomMax);
            set(handles.editSegmentationMaxValue,'string',value);
%         else
%             xZoomMax = str2double(xZoomMax);
%         end

        [counts,~] = imhist(tmpHist);
%         max1 = numel(counts)-1;
%         nbrBins = numel(counts)-1;
        
        % display the histogram
        bar(handles.axesSegmentationHistogram, counts);
        
        %get the equivalent xZoomMin and xZoomMax in the [0,255] scale
%         xZoomMin255 = (xZoomMin * max1) / maxXaxis;
%         xZoomMax255 = (xZoomMax * max1) / maxXaxis;

        %record plot
        handles.histo.live = counts;
        
        %get yaxis
        maxYValue = max(counts);
        handles.histo.maxCounts = maxYValue;
        ylim(handles.axesSegmentationHistogram, [0,maxYValue]);
        
        % to make sure the xaxis goes from 0 to 255
        xlim(handles.axesSegmentationHistogram, [0,255]);
         set(handles.axesSegmentationHistogram,'xLimMode','manual');
%         set(handles.axesSegmentationHistogram,'xlim',[xZoomMin255,xZoomMax255]);
        
        %where to put the new label [0,255]
%         delta = (xZoomMax255-xZoomMin255)/10;
%         xtick = xZoomMin255:delta:xZoomMax255;
        
        delta = (255.-0.)/5.;
        xtick = 0:delta:255;
        set(handles.axesSegmentationHistogram,'xtick',xtick);
        
        
        %define the new label
        tmp_xTick = get(handles.axesSegmentationHistogram,'xtick');
        sz = numel(tmp_xTick);
        new_xTick = [];
        
        for i=1:sz
           new_xTick(i) = (tmp_xTick(i)/255.) * maxValue; %#ok<AGROW>
        end
        
%         for i=1:sz
%             new_xTick(i) = uint16((tmp_xTick(i)) / xZoomMax255); %#ok<AGROW>
%         end
        
        %xlabel = 0:uint32(maxXaxis/(sz-1)):maxXaxis;
         set(handles.axesSegmentationHistogram,'XTickLabel',new_xTick);
        
        units = get(handles.axesSegmentationHistogram,'units');
        
        %check if ax2 exists already
        if isfield(handles, 'axesSegmentationThresholds') && ...
                ~isempty(handles.axesSegmentationThresholds)
            
            ax2 = handles.axesSegmentationThresholds;
            cla(handles.axesSegmentationThresholds);
            axes(ax2);
            set(handles.axesSegmentationThresholds, 'xlim',[xZoomMin,xZoomMax], ...
                'ytick', []);
            % 'ylim', [0, maxValue]);
            
        else
            
            ax2 = axes('position', get(handles.axesSegmentationHistogram,'position'), ...
                'Color', 'none', ...
                'units', units, ...
                'xtick',[], ...
                'ytick',[], ...
                'xlim',[xZoomMin,xZoomMax], ...
                'xticklabel',[], ...
                'xLimMode','manual', ...
                'parent', handles.uipanelSegmentation);
%                 'ylim',[0,maxValue], ...
            
        end
        
        handles.histo.maxX = maxXaxis;
        handles.maxValueOfHistogramPlot = maxValue;
        handles.axesSegmentationThresholds = ax2;
        
        guidata(hObject,handles);
        
    end %is ~refreshOnly
    
    ylabel('Pixel Counts');
    grid on;
    
end