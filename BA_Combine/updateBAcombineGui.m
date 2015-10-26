function updateBAcombineGui(hObject)
    % Will disable the buttons if we don't have at least two files selected
    
    handles = guidata(hObject);
    
    baCombineSignalSelection = handles.baCombineSignalSelection;
    if isempty(baCombineSignalSelection)
       signalText = 'NO';
       signalColor = 'red';
    else
       signalText = 'YES';
       signalColor = 'green';
    end
    set(handles.textBAcombineSignalSelected,'string',signalText, ...
        'foregroundColor',signalColor);
    
    baCombineBackgroundSelection = handles.baCombineBackgroundSelection;
    if isempty(baCombineBackgroundSelection)
       backgroundText = 'NO';
       backgroundColor = 'red';
    else
       backgroundText = 'YES';
       backgroundColor = 'green';
    end
    set(handles.textBAcombineBackgroundSelected,'string',backgroundText, ...
        'foregroundColor',backgroundColor);
    
%     selection = get(handles.listboxDataFile,'value');
%     sz_selection = (size(selection));
%     nbr_selection = sz_selection(2);
%    
%     statusAdd = 'off';
%     statusMedian = 'off';
%     
%     if nbr_selection > 1
%         statusAdd = 'on';
%     end
%     
%     if nbr_selection > 2
%         statusMedian = 'on';
%     end
%     
%     listHandlesAdd = {handles.textBAaddLabel, ...
%         handles.textBAaddSNRlabel, ...
%         handles.textBAaddSNRvalue};
%     
%      for i=1:numel(listHandlesAdd)
%         set(listHandlesAdd{i},'enable',statusAdd);
%      end
%     
%     listHandlesMedian = {handles.textBAmedianLabel, ...
%         handles.textBAmedianSNRlabel, ...
%         handles.textBAmedianSNRvalue};
%     
%     for i=1:numel(listHandlesMedian)
%         set(listHandlesMedian{i},'enable',statusMedian);
%     end
%     
end