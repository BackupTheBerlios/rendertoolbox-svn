function pbrtScript=Render_ReadInPBRTScript(currentConditions)
% pbrtScript=PBRT_ReadInScript(currentConditions)
%
% 1 july 2006 dpl wrote it.
%
% reads a pbrt script whose name is stored in currentConditions.sceneName
% plus a .pbrt suffix. looks only in the current working directory.

sceneName=currentConditions.sceneName;

%read raw pbrt file
fileName=[sceneName '.pbrt'];
f=fopen(fileName);
pbrtScript=fread(f);
fclose(f);