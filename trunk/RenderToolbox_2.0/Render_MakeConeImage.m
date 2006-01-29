function [coneImage] = Render_MakeConeImage(currentConditions)
%
% Render_MakeConeImage(imageDirectory,coneImageDirectory, imagePrefix,T_cones,S_cones);
%
% 1/26/06 dpl wrote it. based on bx's RenMakeConeImage

%get stuff from conditions
imageDirectory=currentConditions.imageDirectory;
coneImageDirectory=currentConditions.coneImageDirectory;
imagePrefix=currentConditions.sceneName;
T_cones=currentConditions.T_cones;
S_cones=currentConditions.S_cones;

%make sure we have the cone directory
if (~exist(coneImageDirectory,'dir') )
    mkdir(coneImageDirectory);
end


currentDir = pwd;
if (strcmp(imageDirectory,'pwd'))
  imageDirectory = pwd;
end

cameraDistance = 10;
exposureDuration = 2;
fStop = 5.6;
theCamera = SimMakeConesCamera(T_cones,S_cones);
theImageName = fullfile(imageDirectory,imagePrefix); 
inputImageFile = [theImageName '.Simg'];
% Make cone image.
coneImage  = SimSimulateCamera(inputImageFile,theCamera,cameraDistance,exposureDuration,fStop);

fprintf('******save cone images \n');
eval([imagePrefix 'LMSImage = coneImage.images;']);
%eval(['save ' fullfile(coneImageDirectory,[imagePrefix 'LMSImage']) ' ' imagePrefix 'LMSImage' '' ' -v6']);
eval(['save ' fullfile(coneImageDirectory,[imagePrefix 'coneImage']) ' ' 'coneImage' '' ' -v6']);

% 
% cd(imageDirectory); 
% unix(['mv *LMSImage.mat ../BasisConeImages/']);
% unix(['mv *coneImage.mat ../BasisConeImages/']);
% cd ..