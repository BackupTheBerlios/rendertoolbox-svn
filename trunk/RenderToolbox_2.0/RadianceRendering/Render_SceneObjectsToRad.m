function Render_SceneObjectsToRad(objectMaterialParams,lightMaterialParams,currentConditions)
% Render_SceneObjectsToRad(objectMaterialParams,lightMaterialParams,currentConditions)
%
% SceneObjectsToRad converts each object in the scene directory into a
% radiance file, and stores it in [temporary_directory]/objects_[condition#]
% using the binary application obj2rad. Lights are already radiance files,
% so SceneObjectsToRad copies them into [temporary_directory]/lights_[condition#].
% The parameters are those passed to RenderRadiance by batchRender.
% Like RenderRadiance, the current working directory must be the
% experiment directory.
%
%12/24/05 dpl wrote it. based on bx's RenObjToRad

%get some stuff from the conditions
currentConditionNumber=currentConditions.currentConditionNumber;
objectDirectory=currentConditions.objectDirectory;
temporaryDirectory=currentConditions.temporaryDirectory;

%get some stats
numObjects=length(objectMaterialParams);
numLights=length(lightMaterialParams);

%see if there is an object directory of the right name.
destinationDirectory=[temporaryDirectory '/' 'objects_' num2str(currentConditionNumber)];
if (~exist(destinationDirectory,'dir') )
    mkdir(destinationDirectory);
end

%now convert object files
for currentObject=1:numObjects
    currentObjectName=objectMaterialParams(currentObject).name;
    cmd=['obj2rad ' objectDirectory '/' currentObjectName '.obj > ' destinationDirectory '/' currentObjectName '.obj.rad'];
    unix(cmd);
end
    
%see if there is a light directory of the right name.
destinationDirectory=[temporaryDirectory '/' 'lights_' num2str(currentConditionNumber)];
if (~exist(destinationDirectory,'dir') )
    mkdir(destinationDirectory);
end

%for lights, we just copy the files
%**(this assumes that lights are already .rad files, which seems to be the
%case so far)
for currentLight=1:numLights
    currentLightName=lightMaterialParams(currentLight).name;
    cmd=['cp ' objectDirectory '/' currentLightName '.rad ' destinationDirectory '/' currentLightName '.rad'];
    unix(cmd);
end