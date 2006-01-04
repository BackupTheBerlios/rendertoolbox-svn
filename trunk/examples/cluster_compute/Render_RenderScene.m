function Render_RenderScene(currentConditions)
%Render_RenderScene(currentConditions)
%
%Render the scene using the rif structures, which depend on the object,
%material and light files generated before.
%
% 12/27/05 dpl wrote it. based on bx's RenRender_rifs

sceneName=currentConditions.sceneName;

numWavelengths=length(currentConditions.wls);
for currentWavelengthNumber=1:numWavelengths
    currentWavelength=int2str(currentConditions.wls(currentWavelengthNumber));
    S = ['rad ',sceneName,'_',currentWavelength,'.rif'];
    unix(S);
end