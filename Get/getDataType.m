function handles = getDataType(handles, fullFileName,type)
    %Determine the data type of the data file
    
    switch (type)
        case 'fits'
            info = fitsinfo(fullFileName);
            handles.files.DataType = info.PrimaryData.DataType;
        case 'tif'
            info = imfinfo(fullFileName);
            bitDepth = info.BitDepth;
            switch (bitDepth)
                case '16'
                    handles.files.DataType = 'int16';
                case '8'
                    handles.files.DataType = 'int8';
            end
        case 'ascii'
            handles.files.DataType = 'int16';
    end
    
end