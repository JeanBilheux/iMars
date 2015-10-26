function designAlignmentControls(hObject)
    
    handles = guidata(hObject);
    
    arrow = [ ...
        '        1   ';
        '        10  ';
        '         10 ';
        '000000000000';
        '         10 ';
        '        10  ';
        '        1   '];
    width = 11;
    cmap = NaN(128,3);
    cmap(double('10'),:) = [0.5 0.5 0.5;0 0 0];
    arrow_im = NaN(7,76,3);
    arrow_im(:,33:33+width,:) = ind2rgb(double(arrow),cmap);
    set(handles.pushbuttonAlignmentRight,'CDATA',arrow_im);
    
    arrow = [ ...
        '    1   1   ';
        '    10  10  ';
        '     10  10 ';
        '000000000000';
        '     10  10 ';
        '    10  10  ';
        '    1   1   '];
    width = 11;
    cmap = NaN(128,3);
    cmap(double('10'),:) = [0.5 0.5 0.5;0 0 0];
    arrow_im = NaN(7,76,3);
    arrow_im(:,33:33+width,:) = ind2rgb(double(arrow),cmap);
    set(handles.pushbuttonAlignmentRightRight,'CDATA',arrow_im);

    arrow = [ ...
        '   1        ';
        '  01        ';
        ' 01         ';
        '000000000000';
        ' 01         ';
        '  01        ';
        '   1        '];
    width = 11;
    cmap = NaN(128,3);
    cmap(double('10'),:) = [0.5 0.5 0.5;0 0 0];
    arrow_im = NaN(7,76,3);
    arrow_im(:,33:33+width,:) = ind2rgb(double(arrow),cmap);
    set(handles.pushbuttonAlignmentLeft,'CDATA',arrow_im);
    
    arrow = [ ...
        '   1   1    ';
        '  01  01    ';
        ' 01  01     ';
        '000000000000';
        ' 01  01     ';
        '  01  01    ';
        '   1   1    '];
    width = 11;
    cmap = NaN(128,3);
    cmap(double('10'),:) = [0.5 0.5 0.5;0 0 0];
    arrow_im = NaN(7,76,3);
    arrow_im(:,33:33+width,:) = ind2rgb(double(arrow),cmap);
    set(handles.pushbuttonAlignmentLeftLeft,'CDATA',arrow_im);

    arrow = [ ...
        '      0      ';
        '     000     ';
        '    01010    ';
        '   01 0 10   ';
        '  01  0  10  ';
        '      0      ';
        '      0      ';
        '      0      ';
        '      0      ';
        '      0      '];
    
    cmap = NaN(128,3);
    cmap(double('10'),:) = [0.5 0.5 0.5;0 0 0];
    arrow_im = NaN(10,76,3);
    arrow_im(:,33:33+12,:) = ind2rgb(double(arrow),cmap);
    set(handles.pushbuttonAlignmentUp,'CDATA',arrow_im);
    
    arrow = [ ...
        '      0      ';
        '     000     ';
        '    01010    ';
        '   01 0 10   ';
        '  01  0  01  ';
        '    01010    ';
        '   01 0 10   ';
        '  01  0  10  ';
        '      0      ';
        '      0      '];
    
    cmap = NaN(128,3);
    cmap(double('10'),:) = [0.5 0.5 0.5;0 0 0];
    arrow_im = NaN(10,76,3);
    arrow_im(:,33:33+12,:) = ind2rgb(double(arrow),cmap);
    set(handles.pushbuttonAlignmentUpUp,'CDATA',arrow_im);

    arrow = [ ...
        '      0      ';
        '      0      ';
        '      0      ';
        '      0      ';
        '      0      ';
        '  01  0  10  ';
        '   01 0 10   ';
        '    01010    ';
        '     000     ';
        '      0      '];
    
    cmap = NaN(128,3);
    cmap(double('10'),:) = [0.5 0.5 0.5;0 0 0];
    arrow_im = NaN(10,76,3);
    arrow_im(:,33:33+12,:) = ind2rgb(double(arrow),cmap);
    set(handles.pushbuttonAlignmentDown,'CDATA',arrow_im);
    
    arrow = [ ...
        '      0      ';
        '      0      ';
        '  01  0  10  ';
        '   01 0 10   ';
        '    01010    ';
        '  01  0  10  ';
        '   01 0 10   ';
        '    01010    ';
        '     000     ';
        '      0      '];
    
    cmap = NaN(128,3);
    cmap(double('10'),:) = [0.5 0.5 0.5;0 0 0];
    arrow_im = NaN(10,76,3);
    arrow_im(:,33:33+12,:) = ind2rgb(double(arrow),cmap);
    set(handles.pushbuttonAlignmentDownDown,'CDATA',arrow_im);

    rarrow = [ ...
        '    00   ';
        '      00 ';
        '       00';
        '0     00 ';
        '000 00   ';
        '0000     ';
        '000000   '];
    
    cmap = NaN(128,3);
    cmap(double('0'),:) = [0 0 0];
    arrow_im = ind2rgb(double(rarrow),cmap);
    set(handles.pushbuttonAlignmentRotateRight,'CDATA',arrow_im);
   
    larrow = [ ...
        '000000   ';
        '0000     ';
        '000 00   ';
        '0     00 ';
        '       00';
        '      00 ';
        '    00   '];
    
    cmap = NaN(128,3);
    cmap(double('0'),:) = [0 0 0];
    arrow_im = ind2rgb(double(larrow),cmap);
    set(handles.pushbuttonAlignmentRotateLeft,'CDATA',arrow_im);
    
end
