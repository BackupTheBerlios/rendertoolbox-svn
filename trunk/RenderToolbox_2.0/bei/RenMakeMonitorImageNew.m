function [monitorImage] = RenMakeMonitorImageNew(coneImage, imageDir,imagePrefix,calFileSpec,T_cones,S_cones,TONEMAP,SRGB,clipLevelFactor,clipLumFactor)
% [monitorImage,coneImage] =
% RenMakeMonitorImageNew(coneImage, imageDir,imagePrefix,calFileSpec,T_cones,S_cones,...
%    [TONEMAP],[SRGB],[clipLevelFactor],[clipLumFactor])
% coneImage: LMS image generated from the hyperspcetral images and sensors.
% imageDir: Directory that contains the hyperspectral images.
% imagePrefix: Root name for image.
% calFileSpec: Calibration information.
% T_cones: Cone spectral sensitivities.
% S_cones: Wavelength sampling for T_cones.
% TONEMAP: Tone mape the image? (Default = 1)
% SRGB: Render into SRGB space? (Default = 0)
% clipLevelFactor: clipping factor for tone mapping (default = 10)
% clupLumFactor: adjustment factor for tone mapping max lum (default = 0.5)
%
% Reduce a hyperspectral image first to an LMS cone image, then render for
% monitor display.
%
% Refer to SimBasicToneMap for tone mapping algorithm.
%
% This code will replace RenMakeConeImage in the RenderToolBox.
%
% 
% This code will render a monitor image based on the LMS image generated
% from hyperspectral images and apply tonemapping algorithms
% 6/29/04  bx splitted the RenMakeMonitorImage.m and wrote it

if (nargin < 7 | isempty(TONEMAP))
    TONEMAP = 1;
end
if (nargin < 8 | isempty(SRGB))
    SRGB = 0;
end
if (nargin < 9 | isempty(clipLevelFactor))
    clipLevelFactor = 10;
end
if (nargin < 8 | isempty(clipLumFactor))
    clipLumFactor = 0.5;
end

% Change to correct directory
currentDir = pwd;
if (strcmp(imageDir,'pwd'))
  imageDir = pwd;
end

% Grab monitor calibration file
theMonitorFile = SimCalToMonitor(calFileSpec);

% Load color matching functions.  We need XYZ for both
% tone mapping and SRGB.
whichXYZ = '1931';
eval(['load(''T_xyz' whichXYZ ''')';]);
eval(['T_xyzRaw = T_xyz' whichXYZ ';']);
eval(['S_xyzRaw = S_xyz' whichXYZ ';']);

cameraDistance = 10;
exposureDuration = 2;
fStop = 5.6;
theCamera = SimMakeConesCamera(T_cones,S_cones);
theImageName = fullfile(imageDir,imagePrefix); 
inputImageFile = [theImageName '.Simg'];

if (~isstruct(theMonitorFile))
    monitor = SimReadMonitor(theMonitorFile);
else
    monitor = theMonitorFile;
end
T_camera = SimAdjustSensors(coneImage,theCamera);
S_camera = [theCamera.wavelengthSampling.start ...
		    theCamera.wavelengthSampling.step ...
            theCamera.wavelengthSampling.numberSamples];
monitor = SetSensorColorSpace(monitor,T_camera,S_camera);
monitor = SetGammaMethod(monitor,1);

% Load information to convert LMS to XYZ
T_xyz = SplineCmf(S_xyzRaw,683*T_xyzRaw,theCamera.wavelengthSampling);
M_ConesToXYZ = (T_cones'\T_xyz')';
M_XYZToCones = inv(M_ConesToXYZ);

% Tone map if desired.
if (TONEMAP)
    XYZImage = SimApplyColorTransform(M_ConesToXYZ,coneImage.images);
    if (SRGB)
        [nil,M_XYZToSRGB] = XYZToSRGBPrimary([]);
        maxXYZ = inv(M_XYZToSRGB)*[1 1 1]';
        maxMonitorLum = maxXYZ(2);
    else
        maxXYZ = M_ConesToXYZ*PrimaryToSensor(monitor,[1 1 1]');
        maxMonitorLum = maxXYZ(2);
    end
    XYZImage = SimBasicToneMap(XYZImage,maxMonitorLum*clipLumFactor,clipLevelFactor);
    coneImage.images = SimApplyColorTransform(M_XYZToCones,XYZImage);
end

% Go from LMS to monitor primaries
if (SRGB)
    [nil,M_XYZToSRGB] = XYZToSRGBPrimary([]);
    monitorImage.primaryImages = SimApplyColorTransform(M_XYZToSRGB*M_ConesToXYZ,coneImage.images);
else
	fprintf('\tRender and display image, extract RGB\n');
	monitorImage = SimRenderOnMonitor(coneImage,theMonitorFile,1,0,0,1);
end

% Gamma correct
if (SRGB) 
    monitorImage.images = SRGBGammaCorrect(monitorImage.primaryImages);
else
	monitorImage = SimRenderOnMonitor(monitorImage,theMonitorFile,1,0,0,2);
end

 %figure; clf;
 %imshow(uint8(monitorImage.images));
 %drawnow;

 eval([imagePrefix 'MonitorImage = monitorImage.images;']);
 eval(['save ' fullfile(imageDir,[imagePrefix 'MonitorImage']) ' ' imagePrefix 'MonitorImage' '']);
 minMonitorVal = min(monitorImage.images(:));
 maxMonitorVal = max(monitorImage.images(:));
%fprintf('Monitor image min/max: %g, %g\n',minMonitorVal,maxMonitorVal);
%  
% %     
%  cd(imageDir);   
% % 
% % save the .tif file of the monitor images
%  imwrite(uint8(monitorImage.images), 'sphere1.tiff','tif');
%  unix(['mv *.tiff ../FinalImages/']);
%  unix(['mv *MonitorImage.mat ../FinalImages/']);
% cd ..;
