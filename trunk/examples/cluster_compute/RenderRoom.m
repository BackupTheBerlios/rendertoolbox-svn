function  RenderRoom(currentConditions,objectMaterialParams,lightMaterialParams)
%parameters:
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
Render_SceneObjectsToRad(objectMaterialParams,lightMaterialParams,currentConditions);

%now save material structures as rad files
%**(replacing some code that was in RenderRoom, RenStructToMaterial and
%RenCatRad.)
display('save radiance material files...');
Render_RadMaterialFiles(objectMaterialParams,lightMaterialParams,currentConditions);

%make and write rif files for the whole scene
display('generating and writing rif files...');
Render_MakeWriteRifFiles(objectMaterialParams,lightMaterialParams,currentConditions)

%render the scene
display('render the scene...');
Render_RenderScene(currentConditions);

%turn pic into mat
display('make picture matrix...');
Render_PicToMat(currentConditions);

%make S image and cone images
display('generate image data...');
Render_MakeSimg(currentConditions);
%**(do this for now until we read cones in as conditions)
load T_cones_ss2;
currentConditions.T_cones = T_cones_ss2;
currentConditions.S_cones = S_cones_ss2;
Render_MakeConeImage(currentConditions);