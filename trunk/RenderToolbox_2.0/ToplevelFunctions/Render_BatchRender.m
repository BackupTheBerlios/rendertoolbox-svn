function Render_BatchRender(experimentDirectory)
% Render_BatchRender(experimentDirectory)
%
% BatchRender is the function that starts the whole rendering process. It's
% parameter, 'experimentDirectory' specifies the full path of the
% directory in which the scene to be rendered is stored. BatchRender reads
% the complete scene description, including each of its conditions, from
% four textfiles: conditions.txt, lightProperties.txt,
% objectProperties.txt, and rendererParams.txt, as well as the files in the
% scene_objects directory. It calls RenderRoom once for each condition,
% passing it the current parameters for the scene. For more details
% concerning the organization of the experiment directory, the text
% parameter files and the scene_objects folder, see the documents in the
% documentations folder of this distribution.
%
% This version of BatchRender requires version 2 of the RenderToolbox. Run
% Render_PathChange(2) to make sure this version and no others are on the
% matlab path.
%
% 11/27/05 dpl wrote it. based on bx's batchRender
% 12/28/05 dpl modified to link objectProperties, lightProperties etc...
% 2/17/06 dpl major changes.


display(['running at ' datestr(now)]);

%deal with path--add current directory to path
addpath(pwd);

%cd into the experiment directory
cd(experimentDirectory);

%set directory locations
%**(this can be made flexible sometime if we want)
objectDirectory='scene_objects';
imageDirectory='image_data';
coneImageDirectory='cone_image_data';
monitorImageDirectory='monitor_image_data';
temporaryDirectory='tmp';
viewFilesDirectory='view_files';

%remove previous temporary files
unix(['rm -rf ' temporaryDirectory]);

%read from object file
objectProperties=Parameters_ReadStructsFromTabText('objectProperties.txt');
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
lightProperties=Parameters_ReadStructsFromTabText('lightProperties.txt');
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
allConditions=Parameters_ReadStructsFromTabText('conditions.txt');
numConditions=length(allConditions);

%check to make sure we have required fields in conditions file
requirements={'sceneName','renderer','imageRes','wavelengthsStart','wavelengthsStep', ...
    'wavelengthsNumSteps','viewFile','humanCones','tonemap','calibrationFile','lightPower'};
for i=1:length(requirements)
    if ~isfield(allConditions,requirements{i})
        error(['ERROR. conditions file missing required conditions ' requirements{i}]);
        return;
    end
end

%read from renderer properties file
rendererParams=Parameters_ReadStructsFromTabText('rendererParams.txt');

%check to make sure we have required fields
requirements={'zone','exposure','z','quality','penumbras', ...
    'indirect','detail','variability','report','render'};
for i=1:length(requirements)
    if ~isfield(rendererParams,requirements{i})
        error(['ERROR. renderer file missing required properties ' requirements{i}]);
        return;
    end
end

%turn number fields into text fields
%**(this code assumes that the requirements are the only fields in the
%structure)
for i=1:length(requirements)
    if ~ischar(rendererParams.(requirements{i}))
        rendererParams.(requirements{i})= ...
            num2str(rendererParams.(requirements{i}));
    end
end

%add stuff to conditions file
for currentConditionNumber=1:numConditions
    allConditions(currentConditionNumber).objectDirectory=objectDirectory;
    allConditions(currentConditionNumber).imageDirectory=imageDirectory;
    allConditions(currentConditionNumber).coneImageDirectory=coneImageDirectory;
    allConditions(currentConditionNumber).temporaryDirectory=temporaryDirectory;
    allConditions(currentConditionNumber).currentConditionNumber=currentConditionNumber;
    allConditions(currentConditionNumber).monitorImageDirectory=monitorImageDirectory;
    allConditions(currentConditionNumber).viewFilesDirectory=viewFilesDirectory;
end
   
%render the scene
for currentConditionNumber=1:numConditions
% 	try
        display(['**Current condition: ' allConditions(currentConditionNumber).sceneName ...
            ', ' datestr(now)]);
        %link the objectProperties and lightProperties to condition dependant
        %parameter stored in the conditions files in order to pass them to
        %RenderRoom
        [objectMaterialParams lightMaterialParams currentConditions] = ...
            Render_ProcessMaterialProps(objectProperties,lightProperties,allConditions(currentConditionNumber));
        switch(allConditions(currentConditionNumber).renderer)
            case 'radiance'
                %note: we must be in the experiment directory for this function to
                %work.
                Render_RenderRadiance(currentConditions,objectMaterialParams,lightMaterialParams,rendererParams);
            case 'pbrt'
                display('rendering pbrt...');
                Render_RenderPBRT(currentConditions,objectMaterialParams,lightMaterialParams);
            otherwise
                error('Only the radiance renderer is currently supported.');
        end
        display(['Finished at ' datestr(now)]);
        display(' ');
% 	catch
% 		display('Could not finish this condition for following reason:')
% 		display(lasterr);
% 		display(' ');
% 	end
%     
end

cd ..;
