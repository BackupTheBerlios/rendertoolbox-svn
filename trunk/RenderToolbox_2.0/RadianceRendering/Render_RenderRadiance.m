function  Render_RenderRadiance(currentConditions,objectMaterialParams,lightMaterialParams,rendererParams)
% Render_RenderRadiance(currentConditions,objectMaterialParams,lightMaterialParams, ...
%     rendererParams)
%
% Render_RenderRadiance prepares files for the radiance renderer according
% to the properties passed in its parameters and then renders the scene.
% These parameters are prepared by batchRender. The current MATLAB working
% directory must be the experiment directory.
%
% 11/27/05 dpl wrote it. based on bx's RenderRoom
% 12/24/05 dpl modifying later portions to clarfiy the code and make it more
%               general
% 1/11/06 dpl put Render_ProcessMaterialProps into batchRender
% 3/2/06 dpl removed some comments and changed name

%convert objects and lights into radiance files
display('convert objects and lights into radiance files...');
Render_SceneObjectsToRad(objectMaterialParams,lightMaterialParams,currentConditions);

%now save material structures as rad files
display('save radiance material files...');
Render_RadMaterialFiles(objectMaterialParams,lightMaterialParams,currentConditions);

%make and write rif files for the whole scene
display('generating and writing rif files...');
Render_MakeWriteRifFiles(objectMaterialParams,lightMaterialParams,currentConditions,rendererParams);

%render the scene
display('render the scene...');
Render_RenderScene(currentConditions);

%turn pic into mat
Render_RadiancePicToMat(currentConditions);