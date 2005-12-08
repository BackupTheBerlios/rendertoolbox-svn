%test for new renderroom
%11/27/05 dpl wrote it. based on bx's RenderRoom
%
%parameters:
%   currentConditionNumber-the number of the current condition, which 
%is assigned in batchRender. starts from 1 and counts upwards. this is not
%stored in the conditions file.
%   currentConditions-a struct with fields corresponding to the first line
%of the conditions file. the field values correspond to the values stored
%for the currentCondition
%   objectProperties-struct read from objectProperties file
%   lightProperties-struct read from lightProperties file


function  RenderRoom(currentConditionNumber,currentConditions,objectProperties,lightProperties)
%object directory
%**(this is hardcoded for now. can put into one of the text files to make it
%flexible with each project or each condition. could even put it in the
%objects text file so that objects wouldnt' have to be stored in the
%same place. but for now, leave it here.)
objectDirectory='scene_objects';
previousDirectory=pwd;
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


%place object properties, according to the condition file, into a struct to
%use with the rest of bei's code
disp 'processing objects...';
for currentObject=1:numObjects
    materialParam=[];
    %add wavelengths field
    %**(will put this into conditions file soon).
    materialParam.wavelength=wls;
    %step through each property of the object
    for currentObjectProperty=1:numObjectPropertyNames 
        %get the name and value of the current property for the current
        %object
        [name value]=Parameters_GetPropVal(currentObjectProperty,currentObject,objectProperties,currentConditions);
        %map this property into the correct field of materialParam
        materialParam=Parameters_MapObjNameToField(S,materialParam,currentObject,objectProperties,name,value);
    end 
    %now save file.
    %**(this is assuming that there was a field called object name and there
    %is a materialParam field corresponding to it. can check for this in
    %the future.)
    %**(make this cell to use later in bei's code)
    objectNames{currentObject}=materialParam.name;
    save(objectNames{currentObject},'materialParam');
    clear materialParam;
end


%do lights
%**(the light properties file is a little unnecessary right now
%as the only supported types of lights have a D65 spectrum. accordingly
%the spectrumType field must read D65. We also expect a lightName field,
%the values of which correspond to the filenames in the scene_objects
%folder, not including file extentions.)
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
        [name value]=Parameters_GetPropVal(currentLightProperty,currentLight,lightProperties,currentConditions);
   
        %mape name value pairs into correct fields of materialParams
        materialParam=Parameters_MapLightPropertyToField(S,materialParam,currentLight,lightProperties,currentConditions.lightPower,name,value);
    end
    %set the type to light
    %**(currently don't require this field in the light properties file. we
    %do require 'lighttype', which for now is only area, and 'spectrumType,
    %which for now is only D65.)
    materialParam.type='light';
    %put the wavelength in there
    %**(when wavelength goes into the text files, this will have to
    %be moved above into the parsing/mapping routines)
    materialParam.wavelength=wls;
    %save this struct
    lightName=materialParam.name;
    %**(for use in bei's code)
    objectNames{numObjects+currentLight}=lightName;
    save(lightName,'materialParam');
    clear materialParam;
end



%**************
%the above script has produced an output that should be identical to that
%which bei's code did, but now we've used to the new parameter system. for
%this version, we will follow through with the rest of the rendering using
%bei's code.

%but first some code to assign the right values to variables that bei
%requires.
objDir=objectDirectory;
whichCondition=currentConditionNumber;
objCount=numObjects+numLights;
objNames=objectNames;
scene_name=currentConditions.sceneName;
%**(will have to take note of which are nums and which are strs)
imageRes=num2str(currentConditions.imageRes);
whichImage=currentConditions.whichImage;
%**(this requires rif directory to be already made)
rifDir=sprintf('%s_%d','rifFiles',currentConditionNumber);
coneImageDir=currentConditions.coneImagesDirectory;

%put us in the right place to start Bei's code
cd(previousDirectory);


%***************
% and now, bei's code:


% Load in human cones
load T_cones_ss2;
T_cones = T_cones_ss2;
S_cones = S_cones_ss2;

fprintf('convert all of the objects to Radiance format\n');
% Convert all of the objects to Radiance format.
    RenObjToRad(objDir,whichCondition); 

% Now we make materials folder
dirName = sprintf('%s_%d','materials',whichCondition);
if (~exist(dirName,'dir') )
    mkdir(dirName);
end
cd(dirName); unix('rm *.rad'); cd ..;

fprintf('construct material structures\n');
% Construct material structres for each light/surface object for
% Radiance.
for i = 1:objCount
    eval(['load',' ',objDir,'/',objNames{i},'.mat']);
	materialStructures(i).name = objNames(i);
    materialStructures(i).type = materialParam.type;
    switch (materialStructures(i).type)
        case 'ward',
			materialStructures(i).rho = materialParam.rho;
			materialStructures(i).alpha = materialParam.alpha;
	        materialStructures(i).spectrum  = materialParam.spectrum;
            materialStructures(i).wavelength = materialParam.wavelength; 
        case 'light',
            materialStructures(i).spectrum = materialParam.spectrum;
            materialStructures(i).wavelength = materialParam.wavelength;
            materialStructures(i).lighttype = materialParam.lighttype;
        otherwise
            error(sprintf('Unsupported material type %s entered\n',materialStructures(i).type));
    end
    
    % Make .rad files from the materialStructures
	RenStructToMaterial(materialStructures(i),char(objNames(i)),dirName);
end

fprintf('about to render\n'); 
% Generate hyperspetral images.  This is the rendering step where we
% use Radiance for each wavelength, drawing on the spectral information
% in the materials files we created just above.
RenCatRad(wls,dirName);
%objectDir = 'objects';
%RenCatObj(objectDir);
if(objCount >15)
    catObjFlag = 1;
    objectDir = 'objects_1';
    RenCatObj(objectDir);
else
    catObjFlag = 0;
end
fprintf('cat files together\n');

% Make and write the rif structure for the whole scene.
rs = RenMake_rif_struct(scene_name,imageRes,whichImage);
fprintf('make and write rif files\n');
RenWrite_rifs(wls,rs,whichCondition,catObjFlag);

% Render the scene at each wavlength
RenRender_rifs(wls,rs);

% get the rif prefix
rifFilePrefix = rs.rif_name;

% Move the current project 's .rif, .pic.,.oct files into a subfolder.
% rifDir = sprintf('%s_%d','rifFiles',whichCondition);
% if (~exist(rifDir,'dir') )
%     mkdir(rifDir);
% end
cmd = char(strcat('mv',{' '},rifFilePrefix,'*.rif',{' '},rifDir,'/'));
unix(cmd);
cmd = char(strcat('mv',{' '},rifFilePrefix,'*.oct',{' '},rifDir,'/'));
unix(cmd);
cmd = char(strcat('mv',{' '},rifFilePrefix,'*_1.pic',{' '},rifDir,'/'));
unix(cmd);

% Pull the floating data out of the Pic file format.
picMat = RenPicToMat(wls,rs,rifDir);

% Use simulator toolbox to render a monitor image.  We may want to split
% out the LMS image as a separate step at some point.
RenHypMakeSimgFromPic('image_data',wls,rs,picMat);
coneImage = RenMakeConeImage('image_data',coneImageDir, rs.rif_name,T_cones,S_cones);

%calfile = 'StereoLeft_8';
%RenMakeMonitorImageNew(coneImage,'image_data',rs.rif_name,calfile,T_cones,S_cones,1,0,8,0.3);    
%RenRenderPurge;
