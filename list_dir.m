function files = list_dir(folder, extension)

     dir_contents = dir(folder);
     files = {};
     for file_num = 1:length(dir_contents)

     indExt = strfind(dir_contents(file_num).name, extension);
     if ~isempty(indExt)
     
     files{end+1} = [folder filesep dir_contents(file_num).name];

     end % if

     end % file_num
