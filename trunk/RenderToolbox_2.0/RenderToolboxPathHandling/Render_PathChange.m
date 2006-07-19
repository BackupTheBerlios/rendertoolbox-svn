function Render_PathChange(version,directory)
% Render_PathChange(version)
%
% PathChange adds the path to the redertoolbox of the passed version
% number and takes all other versions off the path.
%
% 1/12/06 dpl wrote it.
% 2/14/06 dpl fixed bug that chopped off the last path entry on each run :)

%hard code paths to different versions
%**(can make this smarter sometime)
% versionPaths{1}=%fill in the rest of this path: '/repos/rendertoolbox/branches/RenderToolbox_1.0';
%versionPaths{2}='/Users.local/Shared/dpl/repos/simulatortoolbox/trunk/SimToolbox';

if nargin==1
    versionPaths{version}='/Users.local/Shared/dpl/repos/rendertoolbox/trunk/RenderToolbox_2.0';
elseif nargin==2
    versionPaths{version}=directory;
end
    
%put the whole path into a cell of strings
fullMatlabPath=matlabpath;
currentPosition=1;
separator=pathsep;
pathCell={};

for k=1:inf
   token=strtok(fullMatlabPath(currentPosition:end), separator);
   pathCell{k}=token;
   currentPosition=currentPosition+length(token)+1;
   if(currentPosition>=length(fullMatlabPath)) break, end;
end

%remove all rendertoolboxes from the path
numVersions=length(versionPaths);
numDirs=length(pathCell);
for currentDir=1:numDirs
    for currentVersion=1:numVersions
        if strfind(pathCell{currentDir},versionPaths{currentVersion})
            pathCell{currentDir}='';
        end
    end
end

%get directories for the new version
%**(the current version of Render_genpath always puts a trailing ':' after
%the string so we do not need to add one below.)
newDirs=Render_genpath(versionPaths{version});

%put patchCell into string 
newPath=newDirs;
for currentDir=1:numDirs
    if ~strcmp(pathCell{currentDir},'')
        newPath=[newPath pathCell{currentDir} separator];
    end
end

%set this to be the path
path(newPath);

