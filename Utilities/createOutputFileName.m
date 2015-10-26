function outputFileName = createOutputFileName(path, inputFileName, prefix, ext)
    %This function will parse the input file and will create the
    %output file name using the prefix and ext
    %
    % ex:  path: '/users/Messi/Desktop/'
    %      inputFileName: '20445_EGR_0004.fits'
    %      prefix: 'profile_'
    %      ext: 'csv'
    %
    %     outputFileName:
    %     '/users/Messi/Deskotp/profile_20445_EGR_0004.csv'
    %
    
    if nargin < 4
        [~, name, ext] = fileparts(inputFileName);
        tmpOutputFileName = [prefix name ext];
    else
        [~, name, ~] = fileparts(inputFileName);
        tmpOutputFileName = [prefix name '.' ext];
    end
    
    outputFileName = fullfile(path,tmpOutputFileName);
    
end
