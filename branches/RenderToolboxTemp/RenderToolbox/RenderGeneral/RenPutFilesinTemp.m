% RenPutFilesInTemp
%
% Take a bunch of intermediate files that get made during the rendering
% process and hide them out of the way.
%
% 8/12/04   dhb, bx     Added comments.

clear;

% Make temporary folder
dirName = 'tempFiles';
if (~exist(dirName,'dir') )
    mkdir(dirName);
end


% Clean up the working directory by moving and deleting.
unix(['mv *.rif tempFiles/']);
unix(['mv *.pic tempFiles/']);
unix(['mv *.oct tempFiles/']);
unix(['mv *.pic tempFiles/']);
unix(['rm -rf *.unf']);
