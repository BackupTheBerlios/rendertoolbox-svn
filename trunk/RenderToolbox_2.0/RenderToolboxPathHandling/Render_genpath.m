function p = Render_genpath(d)
% p = Render_genpath(d)
%
% Exactly the same as the MathWorks supplied genpath, but skips folders that
% start with '.' or are called 'Conflicts Folder'. This is important
% because if the toolbox is stored as an SVN depository, the matlab genpath
% will add all of SVN's folders which creates conflicts.
%
% 1/11/06 dpl wrote it.


if nargin==0,
  p = Render_genpath(fullfile(matlabroot,'toolbox'));
  if length(p) > 1, p(end) = []; end % Remove trailing pathsep
  return
end

% initialise variables
methodsep = '@';  % qualifier for overloaded method directories
p = '';           % path to be returned

% Generate path based on given root directory
files = dir(d);
if isempty(files)
  return
end

% Add d to the path even if it is empty.
p = [p d pathsep];

% set logical vector for subdirectory entries in d
isdir = logical(cat(1,files.isdir));
%
% Recursively descend through directories which are neither
% private nor "class" directories.
%
dirs = files(isdir); % select only directory entries from the current listing

for i=1:length(dirs)
   dirname = dirs(i).name;
  
   if    ~strcmp( dirname,'.')         & ...
         ~strcmp( dirname,'..')        & ...
         ~strncmp( dirname,methodsep,1)& ...
         ~strcmp( dirname,'private')   & ...
         isempty(strfind(dirname,'.svn')) %dpl: added this line
      p = [p Render_genpath(fullfile(d,dirname))]; % recursive calling of this function.
   end
end


