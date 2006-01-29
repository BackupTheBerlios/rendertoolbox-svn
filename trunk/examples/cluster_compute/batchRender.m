% new batchRender file
%11/27/05 dpl wrote it. based on bx's batchRender
%12/28/05 dpl modified to link objectProperties, lightProperties and
%conditions within this file.
%assumptions about conditions and object files:
% *first field in each condition is sceneName
% *in objectProperties, if a c_ preceeds the value it's value is looked up
%in conditions. the scricpt searches for a field name corresponding to the
%value it finds in objectProperties, not including the prdeceeding 'c_'
%d  *if a value is not a string, it assumes its a number, and converts it into
%a string

clear all;
display(['running at ' datestr(now)]);

%deal with path--add current directory to path
addpath(pwd);

%set which rendertoolbox we're using
versionNumber=2;
Render_PathChange(versionNumber);

%set which experiment we're doing
experimentName='singleSphere_new';
cd(experimentName);

%remove previous temporary files
unix('rm -rf temporary_files');

%set directory locations
%**(this can be made flexible sometime if we want)
objectDirectory='scene_objects';
imageDirectory='image_data';
coneImageDirectory='cone_image_data';
temporaryDirectory='temporary_files';

%read from object file
objectProperties=ReadStructsFromText('objectProperties.txt');
numObjects=length(objectProperties);
objectPropertyNames=fieldnames(objectProperties(1));
numObjectPropertyNames=length(objectPropertyNames);

%check to make sure we have required fields in objects file
requirements={'objectName','objectType'};
for i=1:length(requirements)
    if ~isfield(objectProperties,requirements{i})
        error(['ERROR. objectProperties file missing required field ' requirements{i}]);
        return;
    end
end

%check to make sure objectProperties file matches objects in object directory
%**(this does not check if there are extra objects in the object directory)
cd(objectDirectory);
files=ls('*.obj *.rad');
for i=1:numObjects
    name=objectProperties(i).objectName;
    result=regexp(files,[name '.(rad|obj)']);
    if isempty(result)
       error(['ERROR. object ' name ' in objectProperties does not have corresponding file in object directory']);
       return;
    end
end
cd ..;


%read from lights file
lightProperties=ReadStructsFromText('lightProperties.txt');
numLights=length(lightProperties);   

%check to make sure we have required fields in lights file
requirements={'lightName','spectrumType','lightType'};
for i=1:length(requirements)
    if ~isfield(lightProperties,requirements{i})
        error(['ERROR. lightProperties file missing required field ' requirements{i}]);
        return;
    end
end

%check to make sure lightProperties file matches lights in object directory
%**(this does not check if there are extra lights in the object directory)
cd(objectDirectory);
files=ls('*.obj *.rad');
for i=1:numLights
    name=lightProperties(i).lightName;
    result=regexp(files,[name '.(rad|obj)']);
    if isempty(result)
       error(['ERROR. object ' name ' in lightProperties does not have corresponding file in object directory']);
       return;
    end
end
cd ..;

%read from conditions file
allConditions=ReadStructsFromText('conditions.txt');
numConditions=length(allConditions);

%check to make sure we have required fields in conditions file
requirements={'sceneName','imageRes','wavelengthsStart','wavelengthsStep', ...
    'wavelengthsNumSteps','rifDir','coneImagesDirectory','lightPower'};
for i=1:length(requirements)
    if ~isfield(allConditions,requirements{i})
        error(['ERROR. conditions file missing required conditions ' requirements{i}]);
        return;
    end
end

%add stuff to conditions file
for currentConditionNumber=1:numConditions
    allConditions(currentConditionNumber).objectDirectory=objectDirectory;
    allConditions(currentConditionNumber).imageDirectory=imageDirectory;
    allConditions(currentConditionNumber).coneImageDirectory=coneImageDirectory;
    allConditions(currentConditionNumber).temporaryDirectory=temporaryDirectory;
    allConditions(currentConditionNumber).currentConditionNumber=currentConditionNumber;
end
   
%render the scene
for currentConditionNumber=1:numConditions
    %link the objectProperties and lightProperties to condition dependant
    %parametersc stored in the conditions files in order to pass them to
    %RenderRoom
    [objectMaterialParams lightMaterialParams currentConditions] = ...
        Render_ProcessMaterialProps(objectProperties,lightProperties,allConditions(currentConditionNumber));
    %note: we must be in the experiment directory for this function to
    %work.
    RenderRoom(currentConditions,objectMaterialParams,lightMaterialParams);

end

cd ..;
