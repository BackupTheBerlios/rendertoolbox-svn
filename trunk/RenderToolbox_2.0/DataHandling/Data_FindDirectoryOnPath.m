function directoryLocation=Data_FindDirectoryOnPath(dirName)
% directory=Data_FindDirectoryOnPath(dirName)
%
% Search for a specific directory in the current Matlab path and return the
% full path to that directory. If the directory is not there or there is
% more than one directory with the given name, FindDirectoryOnPath sends an
% error.
%
% 3/13/2006 dpl wrote it.

%first get a cell of each item in the matlab path
fullMatlabPath=matlabpath;
currentPosition=1;
separator=pathsep;
pathCell={};
for k=1:inf
   token=strtok(fullMatlabPath(currentPosition:end), separator);
   pathCell{k}=token;
   currentPosition=currentPosition+length(token)+1;
   if isempty(strfind(fullMatlabPath(currentPosition:end),separator)) break, end;
end

%now search through the matlab path for 'RenderDataFiles'
directoryLocation='';
for k=1:length(pathCell)
    if(strfind(pathCell{k},dirName))
        if(~isempty(directoryLocation))
            error([dirName ' found more than once in current ' ... 
                'matlab path. The Render toolbox was probably added to ' ...
                'the path incorrectly. See Render_PathChange.']);
        end
        directoryLocation=pathCell{k};
    end
end

%see if we found it
if strcmp(directoryLocation,'')
    error([dirName 'not found on the current matlab path. ' ...
        'The Rendertoobox was probably added to the path ' ...
        'incorrectly. See Render_PathChange.']);
end
