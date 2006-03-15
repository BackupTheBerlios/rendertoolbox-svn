function Render_MakeWriteRifFiles(objectMaterialParams,lightMaterialParams,currentConditions,rendererParams)
% Render_MakeWriteRifFiles(objectMaterialParams,lightMaterialParams, ... 
%           currentConditions,rendererParams)
%
% Generates and writes .rif files for radiance based on conditions passed
% by RenderRadiance. Files are saved in
% [temporary_directory]/rifFiles_[condition#]
%
% 12/27/05 dpl wrote it. based on bx's RenMake_rif_struct and RenWrite_rifs
% 1/23/06  dpl changed to use temporary directory
% 2/3/06 dpl moved viewFile into currentConditions
% 3/2/06 dpl took out some comments

%get some stuff from conditions
currentConditionNumber=currentConditions.currentConditionNumber;
temporaryDirectory=currentConditions.temporaryDirectory;
viewFile=currentConditions.viewFile;
viewFilesDirectory=currentConditions.viewFilesDirectory;

%set name of rif directory in temp folder and make it if it doesn't already
%exists
%**(name must be in accord with that stored in Render_RenderScene)
rifDirectoryName=['rifFiles_' int2str(currentConditionNumber)];
rifDirectoryPath=[temporaryDirectory '/' rifDirectoryName];
if (~exist(rifDirectoryPath,'dir') )
    mkdir(rifDirectoryPath);
end

%populate variables for rif file
octree=currentConditions.sceneName;
picture=currentConditions.sceneName;
resolution=int2str(currentConditions.imageRes);
rif_name=currentConditions.sceneName;

%get values from rendererParams, converting everything into strings

zone=rendererParams.zone;
exposure=rendererParams.exposure;
z=rendererParams.z;
quality=rendererParams.quality;
penumbras=rendererParams.penumbras;
indirect=rendererParams.indirect;
detail=rendererParams.detail;
variability=rendererParams.variability;
report=rendererParams.report;
render=rendererParams.render;


%get list of lights and objects
%**(note that for now, I left out the RenCatObj step from Bei's code, so we
%will not look for masterObj.rad like Bei did in RenWrites_rifs)
%**(for now also, ever object ends with .obj.rad after it's been converted
%from a obj file to a rad file, and every light ends with .rad).
%get some stats
objectsFolder=[temporaryDirectory '/' 'objects_' int2str(currentConditionNumber)];
for currentObject=1:length(objectMaterialParams)
   objectNames{currentObject}=objectMaterialParams(currentObject).name;
end
objectsList=sprintf([objectsFolder '/%s.obj.rad '],objectNames{:});
lightsFolder=[temporaryDirectory '/' 'lights_' int2str(currentConditionNumber)];
for currentLight=1:length(lightMaterialParams)
    lightNames{currentLight}=lightMaterialParams(currentLight).name;
end
lightsList=sprintf([lightsFolder '/%s.rad '],lightNames{:});
bigList=[objectsList lightsList];





numWavelengths=length(currentConditions.wls);
for i=1:numWavelengths
    currentWavelengthValue=int2str(currentConditions.wls(i));
    materialsFile=[temporaryDirectory '/'  'materials_' int2str(currentConditionNumber) '/obj_material_' currentWavelengthValue '.rad'];
    S = '';
    S = [S,'OCTREE = ',octree,'_',currentWavelengthValue,'.oct',char(10)];
    S = [S,'ZONE = ',zone,char(10)];
    S = [S,'EXPOSURE = ',exposure,char(10)];  
    S = [S,'materials = ',materialsFile,char(10)];
    S = [S,'scene = ',bigList,char(10)];
    S = [S,'UP = ',z,char(10)];
    S = [S,'view = -vf ' viewFilesDirectory '/' ,viewFile,char(10)];
    S = [S,'RESOLUTION = ', resolution,char(10)];
    S = [S,'QUALITY = ',quality,char(10)];
    S = [S,'PENUMBRAS = ',penumbras,char(10)];
    S = [S,'PICTURE = ',picture,'_',currentWavelengthValue,char(10)];
    S = [S,'VARIABILITY = ',variability,char(10)];
    S = [S,'INDIRECT = ',indirect,char(10)];
    S = [S,'DETAIL = ',detail,char(10)];
    S = [S,'REPORT = ',report,char(10)];
    S = [S,'render = ',render,char(10)];
    fileDirectory=[rifDirectoryPath '/' rif_name,'_',currentWavelengthValue,'.rif'];
    fid = fopen(fileDirectory,'w');  
    count = fprintf(fid,'%s',S);
    fclose(fid);
    
end
