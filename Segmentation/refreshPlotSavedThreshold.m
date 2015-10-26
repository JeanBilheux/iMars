function handles = refreshPlotSavedThreshold(handles, ...
        histoThresholdValues, ...
        histoThresholdTypes)
    % This function will plot the already saved threshold in the
    % segmentation tab
    
    if nargin<3
        histoThresholdValues = handles.histoThresholdValues;
        histoThresholdTypes = handles.histoThresholdTypes;
    end
    
    %     axes(handles.axesSegmentationHistogram);
    
    nbrThreshold = numel(histoThresholdValues);
    if nbrThreshold == 0
        return
    end
    
    vertices = [];
    faces = [];
    
    ax2 = handles.axesSegmentationThresholds;
    axes(ax2);
    cla(ax2);
    hold on;
    
    %determine the various vertices and faces
    if nbrThreshold == 1
        
        type = histoThresholdTypes{1};
        switch type
            case 'left'
                y = handles.maxValueOfHistogramPlot;
                x = histoThresholdValues(1);
                xmin = 0;
                
                vertices = [xmin 0; xmin y; x y; x 0];
                faces = [1 2 3 4];
                
            case 'right'
                y = handles.maxValueOfHistogramPlot;
                x = histoThresholdValues(1);
                xmax = handles.histo.maxX;
                
                vertices = [xmax 0; xmax y; x y; x 0];
                faces = [1 2 3 4];
        end
        
        patch('Faces', faces, ...
            'Vertices', vertices, ...
            'FaceAlpha', 0.5, ...
            'FaceColor', [1 0.2 0.2], ...
            'parent', ax2);
        
    else %more than 1 threshold
        
        i=1;
        while (i<=nbrThreshold)
            
            val1 = histoThresholdValues(i);
            type1 = histoThresholdTypes{i};
            y = handles.maxValueOfHistogramPlot;
            
            if i==1 && strcmp(type1,'left') %first threshold excludes the left
                
                x = val1;
                xmin = 0;
                
                vertices = [xmin 0; xmin y; x y; x 0];
                faces = [1 2 3 4];
                
            else
                
                if (i+1) <= nbrThreshold
                    
                    x2 = histoThresholdValues(i+1); %can only be left
                    x1 = val1;
                    
                    vertices = [x2 0; x2 y; x1 y; x1 0];
                    faces = [1 2 3 4];
                    
                    i = i + 1;
                    
                else %we are working with the last one
                    
                    x = val1;
                    xmax = handles.histo.maxX;
                    
                    vertices = [xmax 0; xmax y; x y; x 0];
                    faces = [1 2 3 4];
                    
                end %if (i+1) <= nbrThreshold
                
            end %if i==1 && strcmp(type1....)
            
            patch('Faces', faces, ...
                'Vertices', vertices, ...
                'FaceAlpha', 0.5, ...
                'FaceColor', [1 0.2 0.2], ...
                'parent', ax2);
            
            i=i+1;
            
        end %end of while loop
        
    end %end of if nbrThreshold ==1
    
    hold off;
    
end


