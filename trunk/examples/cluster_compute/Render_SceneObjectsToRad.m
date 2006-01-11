function Render_SceneObjectsToRad(objectMaterialParams,lightMaterialParams,currentConditionNumber)
%converts objects in scene_objects directory into radiance files and
%and sorts into objects and lights folders:
%*objects that are not lights are converted to rad files using the binary application
%obj2rad and then placed into objects_[condition#] directory
%*lights are already .rad files and are copied into lights_[condition#]
%directory
%
%parameters: objectProperties,numObjects/lightProperties,numLights are passed into RenderRoom
%currentConditionNumber is the number of the current condition.
%
%note that this function expects matlab to be in the experiment directory,
%not the scene_objects directory.
%
%**(bei's RenObjToRad simply copied .obj files instead of applying obj2rad
%if they included 'plane' in  their name. i didn't understand this, and
%left this function out for now. the two scenes that I am working with,
%spherePatch and singleSphere don't have planes, so this may become
%relevant with other experiments.)
%
%12/24/05 dpl wrote it. based on bx's RenObjToRad

sourceDirectory='scene_objects';

%get some stats
numObjects=length(objectMaterialParams);
numLights=length(lightMaterialParams);

%see if there is an object directory of the right name.
destinationDirectory=['objects_' num2str(currentConditionNumber)];
if (~exist(destinationDirectory,'dir') )
    mkdir(destinationDirectory);
end

%now convert object files
for currentObject=1:numObjects
    currentObjectName=objectMaterialParams(currentObject).name;
    cmd=['obj2rad ' sourceDirectory '/' currentObjectName '.obj > ' destinationDirectory '/' currentObjectName '.obj.rad'];
    unix(cmd);
end
    
%see if there is a light directory of the right name.
destinationDirectory=['lights_' num2str(currentConditionNumber)];
if (~exist(destinationDirectory,'dir') )
    mkdir(destinationDirectory);
end

%for lights, we just copy the files
%**(this assumes that lights are already .rad files, which seems to be the
%case so far)
for currentLight=1:numLights
    currentLightName=lightMaterialParams(currentLight).name;
    cmd=['cp ' sourceDirectory '/' currentLightName '.rad ' destinationDirectory '/' currentLightName '.rad'];
    unix(cmd);
end