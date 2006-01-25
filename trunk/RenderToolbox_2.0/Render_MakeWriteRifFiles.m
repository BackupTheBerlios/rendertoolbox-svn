function Render_MakeWriteRifFiles(objectMaterialParams,lightMaterialParams,currentConditions)
%makes and writes the rif files for the scene. replaces RenMake_rif_struct
%and RenWrite_rifs from Bei's code. I'm not sure why they were separated
%before. To make these structures and work with them separately from
%writing the files, see the above functions in the RenderToolbox.
%
%12/27/05 dpl wrote it. based on bx's RenMake_rif_struct and RenWrite_rifs
%1/23/06  dpl changed to use temporary directory

%get condition number
currentConditionNumber=currentConditions.currentConditionNumber;

%directory info
tempDirectory=currentConditions.tempDirectory;

%set name of rif directory in temp folder and make it if it doesn't already
%exists
%**(name must be in accord with that stored in Render_RenderScene)
rifDirectoryName=['rifFiles_' int2str(currentConditionNumber)];
rifDirectoryPath=[tempDirectory '/' rifDirectoryName];
if (~exist(rifDirectoryPath,'dir') )
    mkdir(rifDirectoryPath);
end



%populate variables for rif file
octree=currentConditions.sceneName;
picture=currentConditions.sceneName;
resolution=int2str(currentConditions.imageRes);
rif_name=currentConditions.sceneName;

%view file. hardcoded for now.
if strcmp(currentConditions.whichImage,'left')
    view='-vf  view_left_01.vf';
else
    view='-vf view_right_01.vf';
end

%**(the rest of these are hardcoded strings. we can put these into the
%conditions file at some point if we want).
zone='Interior 0 40.1 0 25.5 0 19.4';
exposure='1.0';
z='Z';
quality='Medium';
penumbras='True';
indirect='2';
detail='Medium';
variability='Medium';
report='0.2';
render='-dj 0.6 -dt 0.01 -dr 3 -ds 0.1 -sj 0.7 -st 0.15 -dc 0.5 -lr 1 -aw 0 -av 0.5 0.5 0.5';

%get list of lights and objects
%**(note that for now, I left out the RenCatObj step from Bei's code, so we
%will not look for masterObj.rad like Bei did in RenWrites_rifs)
%**(for now also, ever object ends with .obj.rad after it's been converted
%from a obj file to a rad file, and every light ends with .rad).
%get some stats
objectsFolder=[tempDirectory '/' 'objects_' int2str(currentConditionNumber)];
for currentObject=1:length(objectMaterialParams)
   objectNames{currentObject}=objectMaterialParams(currentObject).name;
end
objectsList=sprintf([objectsFolder '/%s.obj.rad '],objectNames{:});
lightsFolder=[tempDirectory '/' 'lights_' int2str(currentConditionNumber)];
for currentLight=1:length(lightMaterialParams)
    lightNames{currentLight}=lightMaterialParams(currentLight).name;
end
lightsList=sprintf([lightsFolder '/%s.rad '],lightNames{:});
bigList=[objectsList lightsList];





numWavelengths=length(currentConditions.wls);
for i=1:numWavelengths
    currentWavelengthValue=int2str(currentConditions.wls(i));
    materialsFile=[tempDirectory '/'  'materials_' int2str(currentConditionNumber) '/obj_material_' currentWavelengthValue '.rad'];
    S = '';
    S = [S,'OCTREE = ',octree,'_',currentWavelengthValue,'.oct',char(10)];
    S = [S,'ZONE = ',zone,char(10)];
    S = [S,'EXPOSURE = ',exposure,char(10)];  
    S = [S,'materials = ',materialsFile,char(10)];
    S = [S,'scene = ',bigList,char(10)];
    S = [S,'UP = ',z,char(10)];
    S = [S,'view = ',view,char(10)];
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
