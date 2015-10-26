function menuSaveAsPng(hObject)
    
    handles = guidata(hObject);
    
    %define output file name
    [fileName, pathName] = uiputfile('*.png', 'Define output file name', ...
        handles.path);
    
    if isempty(fileName)
        return
    end
        
    outputFileName = [pathName fileName];
    
    F = getframe(gcf);
    imwrite(F.cdata,outputFileName,'png');
    
end