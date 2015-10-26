function bMatch = isExtMatches(ext, files_ext)

    bMatch = false;
    sz = numel(files_ext);
    for i=1:sz
        i_files_ext = files_ext{i};
        if strcmp(ext, i_files_ext)
            bMatch = true;
            return
        end
    end

end