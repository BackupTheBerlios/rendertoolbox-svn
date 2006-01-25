function Render_RenderScene(currentConditions)
%Render_RenderScene(currentConditions)
%
%Render the scene using the rif structures, which depend on the object,
%material and light files generated before.
%
% 12/27/05 dpl wrote it. based on bx's RenRender_rifs
% 1/23/06  dpl changed to use temporary directory

%get condition number
currentConditionNumber=currentConditions.currentConditionNumber;

%temp directory locations
rifDirectoryName=['rifFiles_' int2str(currentConditionNumber)];
tempDirectory=currentConditions.tempDirectory;
rifDirectoryPath=[tempDirectory '/' rifDirectoryName];


%check to see if temp directory for radiance output exist
radianceOutDirName=['radOutput_' int2str(currentConditionNumber)];
radianceOutDirPath=[tempDirectory '/' radianceOutDirName];
if (~exist(radianceOutDirPath,'dir') )
    mkdir(radianceOutDirPath);
end

sceneName=currentConditions.sceneName;

numWavelengths=length(currentConditions.wls);
for currentWavelengthNumber=1:numWavelengths
    %do the rendering
    currentWavelength=int2str(currentConditions.wls(currentWavelengthNumber));
    cmd = ['rad ' rifDirectoryPath '/' sceneName,'_',currentWavelength,'.rif'];
    unix(cmd);
    %move oct and pic files into temp directory
    cmd=['mv *.oct ' radianceOutDirPath '/'];
    unix(cmd);
    cmd=['mv *.pic ' radianceOutDirPath '/'];
    unix(cmd);

end
