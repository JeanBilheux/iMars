function testPlotOnTopOfImage
    
    imageRaw = fitsread('verticalHollowCylinder.fits');
    fig = figure('menubar','none');
    set(fig,'numbertitle','off',...
        'units','normalized',...
        'pointer','crosshair', ...
        'WindowButtonMotionFcn',{@hFigure_MotionFcn});
    roiAxes = axes();
    set(roiAxes,...
        'tickdir','out',...
        'position',[0 0 1 1]);
    imagesc(imageRaw);
    hold on;
    
    listPosition = {[0.7 0.7 0.3 0.3], ...
        [0.7 0 0.3 0.3],...
        [0 0 0.3 0.3], ...
        [0 0.7 0.3 0.3]};
    
    plotAxes = axes();
    set(plotAxes,...
        'position',listPosition{4});
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    
    hold off;
    
    function hFigure_MotionFcn(~,~)
        
        livePoint = get(roiAxes,'CurrentPoint');
        x=fix(livePoint(2));
        y=fix(livePoint(1));
        
        horizontalAxe = imageRaw(x,:);
        maxValue = max(horizontalAxe(:));
        axis(plotAxes);
        plot(horizontalAxe);
        hold on;
        plot([x x],[0 maxValue],'color','red');
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        hold off;
        
    end
    
end
