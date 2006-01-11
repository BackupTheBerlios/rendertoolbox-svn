function  RenderRoom_new(currentConditions,currentConditionNumber,objectMaterialParams,lightMaterialParams)
%parameters:
%   currentConditionNumber-the number of the current condition, which 
%is assigned in batchRender. starts from 1 and counts upwards. this is not
%stored in the conditions file.
%   currentConditions-a struct with fields corresponding to the first line
%of the conditions file. the field values correspond to the values stored
%for the currentCondition
%   objectProperties-struct read from objectProperties file
%   lightProperties-struct read from lightProperties file
%
%note: matlab must be in the experiment directory for RenderRoom to work
%
%11/27/05 dpl wrote it. based on bx's RenderRoom
%12/24/05 dpl modifying later portions to clarfiy the code and make it more
%               general
%1/11/06 dpl put Render_ProcessMaterialProps into batchRender



%convert objects and lights into radiance files and sort into
%objects_[condition#] and lights_[condition#]
%**(this is relacing RenObjToRad and using the parameter files
%that were just read above instead of reading the file names of each object.
%I am preserving the directory organization. and note the note inside of
%the function about planes and lights.)
display('convert objects and lights into radiance files...');
Render_SceneObjectsToRad(objectMaterialParams,lightMaterialParams,currentConditionNumber);


%now save material structures as rad files
%**(replacing some code that was in RenderRoom, RenStructToMaterial and
%RenCatRad.)
display('save radiance material files...');
dirName=Render_RadMaterialFiles(objectMaterialParams,lightMaterialParams,currentConditions,currentConditionNumber);


%**(leaving out RenCatObj, which only runs with more than 15 objects. The
%code for this step seemed to be haphazardly placed before.)


%make and write rif files for the whole scene
display('generating and writing rif files...');
Render_MakeWriteRifFiles(objectMaterialParams,lightMaterialParams,currentConditions,currentConditionNumber)

%render the scene
display('render the scene...');
Render_RenderScene(currentConditions);



%don't do the rest for now
return;

%bei's code is below here now:
%with these conversions.
%**(this requires rif directory to be already made)
rifFilePrefix=currentConditions.sceneName;
rifDir=sprintf('%s_%d','rifFiles',currentConditionNumber);
coneImageDir=currentConditions.coneImagesDirectory;
wls=currentConditions.wls;
if strcmp(currentConditions.whichImage,'left')
    whichImage=1;
else
    whichImage=0;
end

%%%%%
%rs = RenMake_rif_struct(scene_name,imageRes,whichImage);
rs = RenMake_rif_struct(currentConditions.sceneName,currentConditions.imageRes,whichImage);
%%%%%

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



% Load in human cones
load T_cones_ss2;
T_cones = T_cones_ss2;
S_cones = S_cones_ss2;


% Use simulator toolbox to render a monitor image.  We may want to split
% out the LMS image as a separate step at some point.
RenHypMakeSimgFromPic('image_data',wls,rs,picMat);
coneImage = RenMakeConeImage('image_data',coneImageDir, rs.rif_name,T_cones,S_cones);

%calfile = 'StereoLeft_8';
%RenMakeMonitorImageNew(coneImage,'image_data',rs.rif_name,calfile,T_cones,S_cones,1,0,8,0.3);    
%RenRenderPurge;
