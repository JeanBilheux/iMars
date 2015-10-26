function [statusLoad, handles] = m_OpenImage(hObject, ...
        handles, ...
        fullFileName, fileIndex, sourceType)
    % Open an image and return the status of the process
    % true: worked
    % false: did not work
    % source type: ['data','openBeam','darkField']
    
    %%Text File Extension Match
    %Make sure all the files have the same extension as the first file loaded
    if (fileIndex > 1)
        [~, ~, ext] = fileparts(fullFileName);
        if ~isExtMatches(ext, handles.files.ext)
            statusLoad = false;
            msgbox([fullFileName ' extension does not match previously loaded file!'], ...
                'Extension mistmatch !', ...
                'error');
            return
        end
    else %if first file loaded of GUI, record extension, type...
        [~, ~, ext] = fileparts(fullFileName);
        switch lower(ext)
            case '.fits'
                handles.files.ext = {'.fits'};
                handles = getDataType(handles, fullFileName,'fits');
            case '.tiff'
                handles.files.ext = {'.tif','.tiff'};
                handles = getDataType(handles, fullFileName,'tif');
            case '.tif'
                handles.files.ext = {'.tif','.tiff'};
                handles = getDataType(handles, fullFileName,'tif');
            case ''
                handles.files.ext =  '';
                handles = getDataType(handles, fullFileName,'ascii');
            otherwise
                msgbox('Image File Format Not Supported by This Version of ImProVis!', ...
                    'File Format not Supported!','error');
        end
        handles.files.class = class(fullFileName);
    end
    
    %     try
    switch (ext)
        case '.fits'
            tmpImage = fitsread(fullFileName);
        case '.tif'
            tmpImage = imread(fullFileName);
        case '.tiff'
            tmpImage = imread(fullFileName);
        case ''
            tmpImage = textread(fullFileName);
        otherwise
    end
    
    sz = size(tmpImage);
    if numel(sz) == 3
        tmpImage = rgb2gray(tmpImage);
    end
    
    % apply chips offset if flag is on
    if strcmpi(get(handles.fileMenuMCPflag,'checked'),'on')
        try
            tmpImage = shiftChips(hObject, tmpImage);
        catch err
            message = sprintf('Are you really using an MCP ?');
            
            statusBarMessage(hObject, message, 5, true);
            handles = guidata(hObject);
            statusLoad = false;
            return;
        end
    end
    switch sourceType
        case 'data'
            handles.files.images{fileIndex} = double(tmpImage);
        case 'openBeam'
            handles.obfiles.images{fileIndex} = double(tmpImage);
        case 'darkField'
            % check if we need to reject or not the image loaded
            validDarkField = isValidDarkField(handles, tmpImage);
            if ~validDarkField
                statusLoad = false;
                return
            end
            handles.dffiles.images{fileIndex} = double(tmpImage);
    end
    
    dataType = handles.files.DataType;
    switch dataType
        case 'uint8'
            maxIntensity = 255;
        case 'uint16'
            maxIntensity = 65535;
        otherwise
            maxIntensity = max(tmpImage(:));
    end
    
    switch sourceType
        case 'data'
            handles.files.globalMaxIntensity = maxIntensity;
        case 'openBeam'
            handles.obfiles.globalMaxIntensity = maxIntensity;
        case 'darkField'
            handles.dffiles.globalMaxIntensity = maxIntensity;
    end
    
    %     catch errorMessage
    %
    %         tmpImage = {}; % if everything else failed
    %
    %         message = sprintf('Error loading Image:   %s - %s -> %s', ...
    %             fullFileName, errorMessage.identifier, errorMessage.message);
    %
    %         statusBarMessage(hObject, message, 5, true);
    %         handles = guidata(hObject);
    %         statusLoad = false;
    %         return;
    %     end
    
    statusLoad = true;
    
end