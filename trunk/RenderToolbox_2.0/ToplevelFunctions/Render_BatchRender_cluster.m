function Render_BatchRender_cluster(experimentDirectory)

display(['running at ' datestr(now)]);

%add the RenderToolbox to the path
% eval(['../RenderToolbox_2.0/RenderToolboxPathHandling/' ...
%         'Render_PathChange(2,''/home1/brainard/dpl/RenderToolbox_2.0''']);


%if there are no arguments, make experimentDirectory the working directory
if nargin==0
    experimentDirectory=pwd;
end

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
pbrtScriptsDirectory='pbrt_scripts';
pbrtOutputDirectory='pbrt_output';
logDirectory='logs';

%read from conditions file
sceneConditions=Parameters_ReadStructsFromTabText('conditions.txt');
isRadiance=strcmp(sceneConditions.renderer,'radiance');
numConditions=length(sceneConditions);

%check to make sure we have required fields in conditions file
requirements={'sceneName','renderer','imageRes','wavelengthsStart','wavelengthsStep', ...
    'wavelengthsNumSteps','humanCones','tonemap','calibrationFile','lightPower'};
if isRadiance
    requirements=[requirements 'viewFile'];
end
for i=1:length(requirements)
    if ~isfield(sceneConditions,requirements{i})
        error(['ERROR. conditions file missing required conditions ' requirements{i}]);
        return;
    end
end

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

if isRadiance
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
end


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

if isRadiance
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
    sceneConditions(currentConditionNumber).objectDirectory=objectDirectory;
    sceneConditions(currentConditionNumber).imageDirectory=imageDirectory;
    sceneConditions(currentConditionNumber).coneImageDirectory=coneImageDirectory;
    sceneConditions(currentConditionNumber).temporaryDirectory=temporaryDirectory;
    sceneConditions(currentConditionNumber).currentConditionNumber=currentConditionNumber;
    sceneConditions(currentConditionNumber).monitorImageDirectory=monitorImageDirectory;
    sceneConditions(currentConditionNumber).viewFilesDirectory=viewFilesDirectory;
    sceneConditions(currentConditionNumber).pbrtScriptsDirectory=pbrtScriptsDirectory;
    sceneConditions(currentConditionNumber).pbrtOutputDirectory=pbrtOutputDirectory;   
end



%render the scene
for currentConditionNumber=1:numConditions
        display(['**Current condition: ' sceneConditions(currentConditionNumber).sceneName ...
            ', ' datestr(now)]);

        %process image properties
        [objectMaterialParams lightMaterialParams currentConditions] = ...
            Render_ProcessMaterialProps(objectProperties,lightProperties,sceneConditions(currentConditionNumber));
        
        %see if conditions and parameters have already been saved
%         fileNamePath=[temporaryDirectory '/' logDirectory '/conditionsAndParameters_' ...
%             num2str(currentConditionNumber) '.mat'];
        
        
     
        
        switch(sceneConditions(currentConditionNumber).renderer)
            case 'radiance'
                Render_RenderRadiance(currentConditions,objectMaterialParams,lightMaterialParams,rendererParams);
            case 'pbrt'
                doImageProcess=Render_RenderPBRT(currentConditions,objectMaterialParams,lightMaterialParams);
            otherwise
                error('Only the radiance and pbrt renderers are currently supported.');
        end
        
        %now take output of rendering and process into a monitor image
        if doImageProcess
        	display('generating monitor images...');
        	Render_ProcessImage(currentConditions);
        	unix(['rm ' temporaryDirectory '/image_processing.loc']);
        end
        
        display(['Finished at ' datestr(now)]);
        display(' ');
end
