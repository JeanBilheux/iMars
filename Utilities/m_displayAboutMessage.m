function m_displayAboutMessage(hObject)
    
    handles = guidata(hObject);
    aboutFileName = handles.aboutFileName;
    
    fid = fopen(aboutFileName);

    aboutMessage = textscan(fid, '%s','Delimiter','\n');
    fclose(fid);
    
    nbrLine = size(aboutMessage{1});
    message = [];
    for i=1:nbrLine
        message = [message aboutMessage{1}(i)]; %#ok<AGROW>
    end
    
    %retrieve version number
    versionFileName = 'utilityFiles/version.txt';
    fid = fopen(versionFileName);
    version = textscan(fid,'%s','Delimiter','\n');
    fclose(fid);
    
    title = ['iMars - version ' char(version{1})];
    msgbox(message, title, 'modal');
    
end


