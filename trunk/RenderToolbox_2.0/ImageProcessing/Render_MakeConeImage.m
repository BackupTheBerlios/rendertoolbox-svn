function Render_MakeConeImage(currentConditions)
% Render_MakeConeImage(currentConditions)
%
% Generate a cone image from the hyperspectral S image, created by
% Render_MakeSImage. Looks for the S image in image_data/ and saves the
% cone image in cone_image_data.
%
% 1/26/06 dpl wrote it. based on bx's RenMakeConeImage

%get stuff from conditions
imageDirectory=currentConditions.imageDirectory;
coneImageDirectory=currentConditions.coneImageDirectory;
imagePrefix=currentConditions.sceneName;
conesSuffix=currentConditions.humanCones;

%load human cones
coneName=['T_cones_' conesSuffix];
load(coneName);
eval(['T_cones=T_cones_' conesSuffix ';']);
eval(['S_cones=S_cones_' conesSuffix ';']);

%make sure we have the cone directory
if (~exist(coneImageDirectory,'dir') )
    mkdir(coneImageDirectory);
end

%set some parameters
%**(put into conditions files sometime?)
cameraDistance = 10;
exposureDuration = 2;
fStop = 5.6;
theCamera = SimMakeConesCamera(T_cones,S_cones);
theImageName = fullfile(imageDirectory,imagePrefix); 
inputImageFile = [theImageName '.Simg'];

% Make cone image.
coneImage  = SimSimulateCamera(inputImageFile,theCamera,cameraDistance,exposureDuration,fStop);

%save
eval([imagePrefix 'LMSImage = coneImage.images;']);
eval(['save ' fullfile(coneImageDirectory,[imagePrefix 'coneImage']) ' ' 'coneImage' '' ' -v6']);
