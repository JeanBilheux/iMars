function myStartup()
    %Startup script for ImProVis
    %This script will add the various folder to the Matlab path

    if isdeployed
        warning off %#ok<WNOFF>
        return
    end 
    
    %Names of three main directories
    rootDir = fileparts(mfilename('fullpath'));
    
    %Add three main directories to path
    if ~(ismcc || isdeployed)
        addpath(rootDir,'-end');
    end
    
    %Get list of directories in root folder
    fileList = dir(rootDir);
    dirList = fileList([fileList.isdir] == 1);
    dirList = dirList(3:end);  %remove the '.' and '..' directories
    
    %Call the addpath scripts of each course directory
    for i = 1:length(dirList)
        try
            %remove .svn folder
            if ~strcmp('.svn',dirList(i).name)
                if ~(ismcc || isdeployed)
                    addpath(dirList(i).name,'-end');
                end
            end
        catch errorMessage
            disp(['Problem adding ' dirList(i).name ' to path - ' ...
                errorMessage.message]);
        end
    end
    
    %Navigate to work directory
    cd(rootDir)
end