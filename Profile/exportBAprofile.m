function exportBAprofile(hObject)
    % This routine will export the profiles into an excel spreadsheet
    
    handles = guidata(hObject);
    
    % get full list of profiles
    [listProfile] = get(handles.listboxBAprofile, 'string');
    if isempty(listProfile)
        return
    end
    
    path = handles.path;
    folderName = uigetdir(path, ...
        'Where do you want to create the profile files?');
    
    if folderName == 0
        return
    end
    
    % save the name of the new folder
    handles.path = folderName;
    
    % get list of profiles selected
    listProfileRowSelected = get(handles.listboxBAprofile,'value');
    if listProfileRowSelected == 0
        return
    end
    listProfileSelected = listProfile(listProfileRowSelected);
    nbrProfiles = numel(listProfileSelected);
    
    % get list of data image selected
    listDataRowSelected = get(handles.listboxDataFile,'value');
    dataFilesImages = handles.files.images;
    dataFilesImagesSelected = dataFilesImages(listDataRowSelected);
    nbrFiles = numel(dataFilesImagesSelected);
    dataFileNames = handles.files.fileNames;
    
    % figure out the Image Domain we requested
    yaxisLabel = getImageDomainSelected(hObject);
    
    handles.myProgress = statusProgressBar(nbrFiles * nbrProfiles, ...
        handles.backgroundProgressBar, ...
        handles.movingProgressBar);
    guidata(hObject, handles);
    
    % will create one csv file for each data file selected
    
    expression='(\w+):(\d+),(\d+),(\d+),(\d+)';
    
    csvArray = [];
    
    comments = {};
    comments{1} = sprintf('%s', yaxisLabel);
    comments{2} = 'line:x1,y1,x2,y2 or rect:x1,y1,width,height';
    
    for j=1:nbrProfiles
        
        tmpProfile = listProfileSelected{j};
        
        comments{3} = tmpProfile;
        comments{4} = '';
        comments{5} = 'List of files:';
        
        [result] = regexp(tmpProfile, expression,'tokens');
        tmpFormatedProfile = result{1};
        x1 = str2double(tmpFormatedProfile(2));
        y1 = str2double(tmpFormatedProfile(3));
        x2 = str2double(tmpFormatedProfile(4));
        y2 = str2double(tmpFormatedProfile(5));
        
        for i=1:nbrFiles
            
            comments{5+i} = sprintf('Column %d: %s', (i+2), ...
                dataFileNames{i}); %#ok<AGROW>
            
            image = getImageForPreview(hObject, ...
                dataFilesImagesSelected{i}, 'data');
            
            if strcmp(tmpFormatedProfile(1),'line') % line profile
                
                x1 = str2double(tmpFormatedProfile(2));
                y1 = str2double(tmpFormatedProfile(3));
                x2 = str2double(tmpFormatedProfile(4));
                y2 = str2double(tmpFormatedProfile(5));
                [cx,cy,c] = improfile(image,[x1 x2],[y1 y2]);
                
            elseif strcmp(tmpFormatedProfile(1),'rect') % rect profile
                
                x1 = str2double(tmpFormatedProfile(2));
                y1 = str2double(tmpFormatedProfile(3));
                w = str2double(tmpFormatedProfile(4));
                h = str2double(tmpFormatedProfile(5));
                imageCropped = image(y1:y1+h,x1:x1+w);
                if h>=w %we will sum over the width
                    factorDiv = size(imageCropped,2);
                    dimensionToSum = 2;
                else
                    factorDiv = size(imageCropped,1);
                    dimensionToSum = 1;
                end
                total = sum(imageCropped,dimensionToSum);
                total = total/(factorDiv-1);
                if h>=w
                    cx = ones(1,numel(total))*x1;
                    cy = (1:numel(total))+y1;
                else
                    cx = (1:numel(total))+x1;
                    cy = ones(1,numel(total))*y1;
                end
                c = total;
                
            else % ellipse profile
                
                tmpPro = tmpFormatedProfile{1};
                ellipseThickness = str2double(tmpPro(7:end));
                precision = getEllipsePlotPrecision(ellipseThickness);
                offset = -ellipseThickness;
                
                x = str2double(tmpFormatedProfile(2));
                y = str2double(tmpFormatedProfile(3));
                w = str2double(tmpFormatedProfile(4));
                h = str2double(tmpFormatedProfile(5));
                
                tmp_x = x+offset;
                tmp_y = y+offset;
                tmp_w = w + 2*offset;
                tmp_h = h + 2*offset;
                
                % get profile of the central ellipse
                [profileArray, ellipse_x, ellipse_y] = getEllipseProfile(image,...
                    tmp_x, ...
                    tmp_y, ...
                    tmp_w, ...
                    tmp_h, ...
                    precision);
                
                cx = ellipse_x;
                cy = ellipse_y;
                c = profileArray;
                
            end
            
            %             else
            %                 progressDone(hObject);
            %                 return;
            %             end
            %
            if i==1
                csvArray(1:numel(cx),1) = cx;       % %x axes
                csvArray(1:numel(cx),2) = cy;       % %y axes
            end
            
            csvArray(1:numel(cx),3+(i-1)) = c;        %#ok<AGROW> %counts
            %             csvArray(1:numel(cx),4+(j-1)*4) = sqrt(c);  %#ok<AGROW> %error
            
            handles.myProgress = handles.myProgress.nextStep();
            
        end %for i=1:nbrFiles
        
        %define output file name
        prefix = sprintf('profile#%d_',j);
        suffix = sprintf('_etAll');
        outputFileName = createProfileOutputFileName(folderName, dataFileNames{i}, prefix, suffix, 'csv');
        
        %create the output file
        createProfileOutputFile(hObject, outputFileName, csvArray, comments, nbrFiles);
        
    end %for j=1:nbrProfiles
    
    guidata(hObject,handles);
    progressDone(hObject);
    
end


function outputFileName = createProfileOutputFileName(path, inputFileName, prefix, suffix, ext)
    %This function will parse the input file and will create the
    %output file name using the prefix, suffix and ext
    %
    % ex:  pat: '/users/Messi/Desktop/'
    %      inputFileName: '20445_EGR_0004.fits'
    %      prefix: 'profile_'
    %      suffix: '_etAll'
    %      ext: 'csv'
    %
    %     outputFileName:
    %     '/users/Messi/Deskotp/profile_profile_20445_EGR_0004_etAll.csv'
    %
    
    [~, name, ~] = fileparts(inputFileName);
    
    tmpOutputFileName = [prefix name suffix '.' ext];
    outputFileName = fullfile(path,tmpOutputFileName);
    
end


function createProfileOutputFile(hObject, fullFileName, data, comments, nbrFiles)
    %this will create a comma separated ascii file of the data
    %after the commented lines
    
    fid = fopen(fullFileName,'w');
    if fid == -1
        message = sprintf('Error writing in this folder');
        statusBarMessage(hObject, message, 5, true);
        return
    end
    
    %write comments
    for i=1:numel(comments)
        fprintf(fid, '#%s\n' , comments{i});
    end
    
    fprintf(fid, '#\n');
    
    initStr = 'x,y,counts (1 column for each file)';
    str = initStr;
    fprintf(fid,'#%s\n', str);
    
    [row,~] = size(data);
    for k=1:row
        
        str = sprintf('%d, %d, %d', data(k,1), data(k,2), data(k,3));
        if nbrFiles > 1
            for j=2:nbrFiles
                preStr = sprintf('%d', data(k,j+2));
                str = [str ',' preStr]; %#ok<AGROW>
            end
        end
        fprintf(fid, '%s\n', str);
        
    end
    
    fclose(fid);
    
end