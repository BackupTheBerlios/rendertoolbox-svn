function [coneImage] = RenMakeConeImage(imageDir,coneImageDir, imagePrefix,T_cones,S_cones);
% function [coneImage] = RenMakeConeImage(imageDir,imagePrefix,,T_cones,S_cones);
% imageDir: Directory that contains the hyperspectral images.
% imagePrefix: Root name for image.
% calFileSpec: Calibration information.
% T_cones: Cone spectral sensitivities.
% S_cones: Wavelength sampling for T_cones.
% 
%
%
% Reduce hyperspectral images to cone image

% 6/29/04 bx split the old RenMakeMonitorImage.m and made this one. 

currentDir = pwd;
if (strcmp(imageDir,'pwd'))
  imageDir = pwd;
end

cameraDistance = 10;
exposureDuration = 2;
fStop = 5.6;
theCamera = SimMakeConesCamera(T_cones,S_cones);
theImageName = fullfile(imageDir,imagePrefix); 
inputImageFile = [theImageName '.Simg'];
% Make cone image.
coneImage  = SimSimulateCamera(inputImageFile,theCamera,cameraDistance,exposureDuration,fStop);

fprintf('******save cone images \n');
eval([imagePrefix 'LMSImage = coneImage.images;']);
%eval(['save ' fullfile(coneImageDir,[imagePrefix 'LMSImage']) ' ' imagePrefix 'LMSImage' '' ' -v6']);
eval(['save ' fullfile(coneImageDir,[imagePrefix 'coneImage']) ' ' 'coneImage' '' ' -v6']);

% 
% cd(imageDir); 
% unix(['mv *LMSImage.mat ../BasisConeImages/']);
% unix(['mv *coneImage.mat ../BasisConeImages/']);
% cd ..