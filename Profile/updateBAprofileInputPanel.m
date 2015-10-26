function updateBAprofileInputPanel(hObject)
    % This function will update the contain of the Basic Analysis
    % Profile Input UIpanel
    % The box will be disabled if none or more than 1 field are selected.
    
    updateBAprofileInputGUI(hObject);
    
    handles = guidata(hObject);
    
    %get full list of profiles
    [listProfile] = get(handles.listboxBAprofile,'string');
    
    %get list of profiles selected
    listProfileRowSelected = get(handles.listboxBAprofile,'value');
    if listProfileRowSelected == 0
        return
    end
    listProfileSelected = listProfile(listProfileRowSelected);
    nbrProfiles = numel(listProfileSelected);
        
    %if nothing selected or more than 1 field
    if isempty(listProfile) || nbrProfiles > 1 %reset contains
        x1 = '';
        y1 = '';
        x2orWidth = '';
        y2orHeight = '';
        workingType = 'N/A';
        BAprofileInputx2orWidthLabel = 'right';
        BAprofileInputy2orHeightLabel = 'bottom';
        
    else
        
        expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
        tmpProfile = listProfileSelected{1};
        [result] = regexp(tmpProfile, expression,'tokens');
        tmpFormatedProfile = result{1};
        
        if strcmp(tmpFormatedProfile(1),'line')
            workingType = 'Line';
            BAprofileInputx2orWidthLabel = 'right';
            BAprofileInputy2orHeightLabel = 'bottom';
        elseif strcmp(tmpFormatedProfile(1),'rect')
            workingType = 'Rectangle';
            BAprofileInputx2orWidthLabel = 'width';
            BAprofileInputy2orHeightLabel = 'height';
        else
            workingType = 'Ellipse';
            BAprofileInputx2orWidthLabel = 'width';
            BAprofileInputy2orHeightLabel = 'height';
        end
        
        x1 = str2double(tmpFormatedProfile(2));
        y1 = str2double(tmpFormatedProfile(3));
        x2orWidth = str2double(tmpFormatedProfile(4));
        y2orHeight = str2double(tmpFormatedProfile(5));
        
    end
    
    set(handles.editBAprofileManualX1input,'string',x1);
    set(handles.editBAprofileManualY1input,'string',y1);
    set(handles.editBAprofileManualX2orWidthInput,'string',x2orWidth);
    set(handles.editBAprofileManualY2orHeightInput,'string',y2orHeight);
    set(handles.textBAprofileManualWorkingType,'string',workingType);
    set(handles.BAprofileInputx2orWidthLabel,'string',BAprofileInputx2orWidthLabel);
    set(handles.BAprofileInputy2orHeightLabel,'string',BAprofileInputy2orHeightLabel);
    
end