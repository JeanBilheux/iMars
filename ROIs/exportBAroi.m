function exportBAroi(hObject)
    %Will export the Roi selected for the data file selected
    
    handles = guidata(hObject);
    
    %get full list of rois
    [listRois] = get(handles.listboxBAroi,'string');
    if isempty(listRois)
        return
    end
    
    path = handles.path;
    folderName = uigetdir(path, ...
        'Where do you want to create the ROI data files?');
    
    if folderName == 0
        return
    end
    
    %get list of rois selected
    listRoiRowSelected = get(handles.listboxBAroi,'value');
    if listRoiRowSelected == 0
        return
    end
    listRoiSelected = listRois(listRoiRowSelected);
    nbrRois = numel(listRoiSelected);
    
    %get list of data image selected
    listDataRowSelected = get(handles.listboxDataFile,'value');
    dataFilesImages = handles.files.images;
    dataFilesImagesSelected = dataFilesImages(listDataRowSelected);
    nbrFiles = numel(dataFilesImagesSelected);
    dataFileNames = handles.files.fileNames;
    dataFileNamesSelected = dataFileNames(listDataRowSelected);
    
    %figure out the Image Domain we requested
    yaxisLabel = getImageDomainSelected(hObject);
    
    prefix = '';
    ext = 'csv';
    
    isError = false;
    
%     try
        
        if get(handles.radiobuttonBAroiAllrois,'value')
            %if we gather all the ROIs into just one
            
            %nbrSteps = nbrDataFilesSelected
            handles.myProgress = statusProgressBar(nbrFiles, ...
                handles.backgroundProgressBar, ...
                handles.movingProgressBar);
            guidata(hObject, handles);
            
            %define output file name
            fileName = generateFileName('MeanOfAllMergeRoi');
            outputFileName = createOutputFileName(folderName, ...
                fileName, prefix, ext);
            
            [arrayOfImageRoisMean, ...
                globalMean, std] = getArrayFromAllRois(hObject, ...
                listRoiSelected);
            
            createOutputFileForAllRoisMerged(hObject, ...
                outputFileName, ...
                listRoiSelected, ...
                dataFileNamesSelected , ...
                arrayOfImageRoisMean, ...
                globalMean, std);
            
        else %each roi is treated separetly
            
            %define output file name
            fileName = generateFileName('MeanOfEachRoi');
            outputFileName = createOutputFileName(folderName, ...
                fileName, prefix, ext);
            
            %if only 1 file selected, create file counts vs ROI#
            if nbrFiles == 1
                
                handles.myProgress = statusProgressBar(nbrRois, ...
                    handles.backgroundProgressBar, ...
                    handles.movingProgressBar);
                guidata(hObject, handles);
                
                [arrayOfImageRoisMean, ...
                    globalMean, globalStd] = getArrayOfRoisFromSelectedDataFile(hObject, ...
                    listRoiSelected);
                
                createOutputFileForEachRoisOfSingleFileSelected(outputFileName, ...
                    yaxisLabel, ...
                    listRoiSelected, ...
                    dataFileNamesSelected, ...
                    arrayOfImageRoisMean, ...
                    globalMean, ...
                    globalStd);
                
            else %more than 1 data file selected
                
                handles.myProgress = statusProgressBar(nbrFiles*nbrRois, ...
                    handles.backgroundProgressBar, ...
                    handles.movingProgressBar);
                guidata(hObject, handles);
                
                [arrayOfImageRoisMean, ...
                    arrayOfMean, ...
                    arrayOfStd] = getArrayOfFilesFromSelectedRois(hObject, ...
                    listRoiSelected);
                
                createOutputFileForEachFileForSelectedRois(outputFileName, ...
                    yaxisLabel, ...
                    listRoiSelected, ...
                    dataFileNamesSelected, ...
                    arrayOfImageRoisMean, ...
                    arrayOfMean, ...
                    arrayOfStd);
                
            end
            
        end
        
        message = ['Created ' outputFileName];
        
%     catch errMessage
%         
%         isError = true;
%         message = ['FAILED to create ' outputFileName ' -> ' errMessage.message];
%         
%     end
    
    statusBarMessage(hObject, message, 5, isError);
    
    guidata(hObject,handles);    
    progressDone(hObject);
    
end

function fileName = generateFileName(base)
    % Generate a unique file name using the base and adding
    % date and time
    
    tmpDate = date();
    timeArray = clock();
    
    fileName1 = [base '_' tmpDate '_'];
    fileName2 = sprintf('%d_%d_%d',timeArray(4),timeArray(5),timeArray(6));
    fileName = [fileName1 fileName2];
    
end

function [arrayOfImageRoisMean, globalMean, std] = getArrayFromAllRois(hObject, listRoi)
    
    handles = guidata(hObject);
    
    dataRowSelected = get(handles.listboxDataFile,'value');
    nbrDataFile = numel(dataRowSelected);
    dataImages = handles.files.images;
    
    [arrayHeight,arrayWidth] = size(dataImages{1});
    roiLogicalArray = getBAroiLogicalArray(listRoi, arrayWidth, ...
        arrayHeight);
    
    arrayOfImageRoisMean = [];
    globalMean = 0;
    
    for i=1:nbrDataFile
        
        tmpImage = dataImages{dataRowSelected(i)};
        tmpImage = getImageForPreview(hObject, ...
            tmpImage, 'data');
        tmpImageInRoi = tmpImage(roiLogicalArray);
        tmpMean = mean(mean(tmpImageInRoi));
        arrayOfImageRoisMean(i) = tmpMean; %#ok<AGROW>
        globalMean = globalMean + tmpMean;
        
        handles.myProgress = handles.myProgress.nextStep();
        
    end
    
    globalMean = globalMean / nbrDataFile;
    std = calculateStd(arrayOfImageRoisMean, globalMean);
    
end


function [arrayOfImageRoisMean, ...
        globalMean, globalStd] = getArrayOfRoisFromSelectedDataFile(hObject, ...
        listRoiSelected)
    %this is reached by the user when only 1 data file is selected
    %and at least 1 roi selected with the following ROI option
    %selected: Selected ROIs are treated individually
    
    handles = guidata(hObject);
    
    %get the only data file name selected
    dataRowSelected = get(handles.listboxDataFile,'value');
    dataImages = handles.files.images;
    
    imageSelected = dataImages{dataRowSelected};
    [arrayHeight,arrayWidth] = size(imageSelected);
    
    nbrRois = numel(listRoiSelected);
    
    arrayOfImageRoisMean = [];
    globalMean = 0;
    for i=1:nbrRois
        
        roiLogicalArray = getBAroiLogicalArray(listRoiSelected(i), ...
            arrayWidth, ...
            arrayHeight);
        
        tmpImage = getImageForPreview(hObject, ...
            imageSelected, 'data');
        tmpImageInRoi = tmpImage(roiLogicalArray);
        tmpMean = mean(mean(tmpImageInRoi));
        arrayOfImageRoisMean(i) = tmpMean; %#ok<AGROW>
        globalMean = globalMean + tmpMean;
        
        handles.myProgress = handles.myProgress.nextStep();
        
    end
    
    globalMean = globalMean / nbrRois;
    globalStd = calculateStd(arrayOfImageRoisMean, globalMean);
    
end


function [arrayOfImageRoisMean, ...
        arrayOfMean, ...
        arrayOfStd] = getArrayOfFilesFromSelectedRois(hObject, ...
        listRoiSelected)
    % Will create the ascii (csv) file for the ROI selected of the data file
    % selected. The arrayOfImageRoisMean will be a cell table arrays.
    % arrayOfImageRoisMean = { nbr rois, nbr data file, 2};
    % 3 is for File #, Mean and error
    
    handles = guidata(hObject);
    
    %get list of data image selected
    listDataRowSelected = get(handles.listboxDataFile,'value');
    dataFilesImages = handles.files.images;
    dataFilesImagesSelected = dataFilesImages(listDataRowSelected);
    
    nbrFiles = numel(dataFilesImagesSelected);
    nbrRois = numel(listRoiSelected);
    
    arrayOfImageRoisMean = zeros(nbrRois, nbrFiles, 2);
    
    [arrayHeight,arrayWidth] = size(dataFilesImagesSelected{1});
    
    arrayOfMean = [];
    arrayOfStd = [];
    
    for i=1:nbrRois
        
        roiLogicalArray = getBAroiLogicalArray(listRoiSelected(i), ...
            arrayWidth, ...
            arrayHeight);
        
        tmpGlobalMean = 0;
        
        for j=1:nbrFiles
            
            imageSelected = dataFilesImagesSelected{j};
            tmpImage = getImageForPreview(hObject, ...
                imageSelected, 'data');
            tmpImageInRoi = tmpImage(roiLogicalArray);
            tmpMean = mean(mean(tmpImageInRoi));
            arrayOfImageRoisMean(i,j,1) = tmpMean;
            arrayOfImageRoisMean(i,j,2) = sqrt(tmpMean); %error
            tmpGlobalMean = tmpGlobalMean + tmpMean;
            
            handles.myProgress = handles.myProgress.nextStep();
            
        end
        
        tmpGlobalMean = tmpGlobalMean / nbrFiles;
        tmpGlobalStd = calculateStd(arrayOfImageRoisMean(i,:,2), tmpGlobalMean);
        
        arrayOfMean(i) = tmpGlobalMean; %#ok<AGROW>
        arrayOfStd(i) = tmpGlobalStd; %#ok<AGROW>
        
    end
    
end


function createOutputFileForAllRoisMerged(hObject, ...
        outputFileName, ...
        listRoiSelected, ...
        dataFileNamesSelected, ...
        arrayOfImageRoisMean, ...
        globalMean, std)
    %will create the ascii (csv) file for the ROI selected of the data
    %file selected
    
    fid = fopen(outputFileName,'w');
    
    %figure out the Image Domain we requested
    yaxisLabel = getImageDomainSelected(hObject);
    fprintf(fid,'%s\n',yaxisLabel);
    
    %write comments
    fprintf(fid,'# %s\n#\n', yaxisLabel);
    
    nbrDataFileSelected = numel(dataFileNamesSelected);
    for i=1:nbrDataFileSelected
        fprintf(fid,'# %d, %s\n', i, dataFileNamesSelected{i});
    end
    
    fprintf(fid,'#\n');
    
    %output the rois selected
    nbrRois = numel(listRoiSelected);
    fprintf(fid, '# r: x1, y1, width, height\n');
    for k=1:nbrRois
        fprintf(fid,'# %s\n', listRoiSelected{k});
    end
    
    fprintf(fid,'#\n');
    
    fprintf(fid, '# Mean, %f\n',globalMean);
    fprintf(fid, '# Standard Deviation, %f\n#\n', std);
    fprintf(fid, '# File number, Mean Counts\n');
    
    for j=1:nbrDataFileSelected
        fprintf(fid, '%d,%f\n',j,arrayOfImageRoisMean(j));
    end
    
    fclose(fid);
    
end


function createOutputFileForEachRoisOfSingleFileSelected(outputFileName, ...
        yaxisLabel, ...
        listRoiSelected, ...
        dataFileNameSelected, ...
        arrayOfImageRoisMean, ...
        globalMean, ...
        globalStd)
    %will create the ascii (csv) file for the data file selected of all the
    %rois selected
    
    fid = fopen(outputFileName,'w');
    
    %write comments
    fprintf(fid,'# %s\n#\n', yaxisLabel);
    fprintf(fid,'# Data File Name, %s\n', dataFileNameSelected{1});
    
    fprintf(fid,'# Rois selected, r:x1, y1, width, height\n');
    nbrRoisSelected = numel(listRoiSelected);
    for i=1:nbrRoisSelected
        fprintf(fid,'# %s\n', listRoiSelected{i});
    end
    
    fprintf(fid,'#\n');
    
    fprintf(fid,'# Global Mean, %f\n', globalMean);
    fprintf(fid,'# Standard Deviation, %f\n', globalStd);
    fprintf(fid,'#\n');
    
    fprintf(fid, '# ROI number, Mean Counts\n');
    
    for j=1:nbrRoisSelected
        fprintf(fid, '%d,%f\n', j, arrayOfImageRoisMean(j));
    end
    
    fclose(fid);
    
end


function createOutputFileForEachFileForSelectedRois(outputFileName, ...
        yaxisLabel, ...
        listRoiSelected, ...
        dataFileNamesSelected, ...
        arrayOfImageRoisMean, ...
        arrayOfMean, ...
        arrayOfStd)
    %will create a single ascii (csv) file of the counts vs file # for each
    %roi selected
    
    fid = fopen(outputFileName,'w');
    
    %write comments
    fprintf(fid,'# %s\n#\n', yaxisLabel);
    
    fprintf(fid,'# Data File selected\n');
    nbrFiles = numel(dataFileNamesSelected);
    for i=1:nbrFiles
        fprintf(fid,'# %d, %s\n', i, dataFileNamesSelected{i});
    end
    
    fprintf(fid,'#\n');
    
    fprintf(fid,'# ROIs, r:x1,y1,width,height\n');
    nbrRois = numel(listRoiSelected);
    for j=1:nbrRois
        fprintf(fid,'# Column %d->%d, %s\n',(3*j-2),(3*j),listRoiSelected{j});
    end
    
    fprintf(fid,'#\n');
    
    fprintf(fid,'# ROI index, global mean, Standard Deviation\n');
    for k=1:nbrRois
        fprintf(fid,'# %d, %d, %d \n', k, arrayOfMean(k), arrayOfStd(k));
    end
    
    fprintf(fid,'#\n');
    axisLabelBluePrint = 'File index, Mean Counts, Error Counts';
    finalAxisLabel = axisLabelBluePrint;
    if nbrRois > 1
        for u=2:nbrRois
            finalAxisLabel = [finalAxisLabel ', ' axisLabelBluePrint]; %#ok<AGROW>
            
        end %end of for
    end %end of if
    fprintf(fid,'# %s\n', finalAxisLabel);
    
    for i=1:nbrFiles
        tmpLine = sprintf('%d,%f,%f',i,arrayOfImageRoisMean(1,i,1), ...
            arrayOfImageRoisMean(1,i,2));
        if nbrRois > 1
            for j=2:nbrRois
                newTmpLine = sprintf('%d,%f,%f',i,arrayOfImageRoisMean(j,i,1), ...
                    arrayOfImageRoisMean(j,i,2));
                tmpLine = [tmpLine ',' newTmpLine]; %#ok<AGROW>
            end %end of for
        end %end of if
        fprintf(fid,'%s\n',tmpLine);
    end
    
    fclose(fid);
    
end


