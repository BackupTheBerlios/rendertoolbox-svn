function [objectMaterialParams lightMaterialParams currentConditions] = ...
    Render_ProcessMaterialProps(objectProperties,lightProperties,currentConditions)
%
%
% 1/29/06 dpl took out unecessary comments and functions


%get stuff from conditions
objectDirectory=currentConditions.objectDirectory;
temporaryDirectory=currentConditions.temporaryDirectory;

%assume that we're in the experiment directory and the object directory is
%in that directory
cd(objectDirectory);

%get stats about conditions
conditionNames=fieldnames(currentConditions);
numConditionNames=length(conditionNames);

%get stats about objects
numObjects=length(objectProperties);
objectPropertyNames=fieldnames(objectProperties(1));
numObjectPropertyNames=length(objectPropertyNames);

%get wavelength sampling
S=[currentConditions.wavelengthsStart currentConditions.wavelengthsStep ...
    currentConditions.wavelengthsNumSteps];
wls=MakeItWls(S);
currentConditions.wls=wls;


%place object properties, according to the condition file, into a struct to
%use with the rest of bei's code
disp 'processing objects...';
for currentObject=1:numObjects
    materialParam=[];
    %add wavelengths field
    materialParam.wavelength=wls;
    %step through each property of the object
    for currentObjectProperty=1:numObjectPropertyNames 
        %get the name and value of the current property for the current
        %object
        [name value]=Parameters_LinkParamsConditions(currentObjectProperty,currentObject,objectProperties,currentConditions);
        %map this property into the correct field of materialParam
        materialParam=Parameters_LookUpFieldValues(S,materialParam,currentObject,objectProperties,name,value);
    end 
    objectMaterialParams(currentObject)=materialParam;
    clear materialParam;
end


%do lights
%**(the light properties file is a little unnecessary right now
%as the only supported types of lights have a D65 spectrum. accordingly
%the spectrumType field must read D65. We also expect a lightName field,
%the values of which correspond to the filenames in the scene_objects
%folder, not including file extentions. --update: batchRender checks
%for the name field as well.)
disp 'processing lights...';

%get stats about light properties
numLights=length(lightProperties);
lightPropertyNames=fieldnames(lightProperties);
numLightPropertyNames=length(lightPropertyNames);

for currentLight=1:numLights
    materialParam=[];
    for currentLightProperty=1:numLightPropertyNames
        %get the name and value of the current property for the current
        %object
        [name value]=Parameters_LinkParamsConditions(currentLightProperty,currentLight,lightProperties,currentConditions);
   
        %mape name value pairs into correct fields of materialParams
        materialParam=Parameters_MapLightPropertyToField(S,materialParam,currentLight,lightProperties,currentConditions.lightPower,name,value);
    end
    %set the type to light
    %**(currently don't require this field in the light properties file. we
    %do require 'lighttype', which for now is only area, and 'spectrumType,
    %which for now is only D65.)
    materialParam.type='light';
    %put the wavelength in there
    materialParam.wavelength=wls;
    %save this struct
    lightName=materialParam.name;
    lightMaterialParams(currentLight)=materialParam;
end

%cd back into the directory that we started in
cd ..
