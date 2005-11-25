function [monitorImage,coneImage] = RenMakeMonitorImage(imageDir,imagePrefix,calFileSpec,T_cones,S_cones,TONEMAP,SRGB,clipLevelFactor,clipLumFactor)
% [monitorImage,coneImage] =
% RenMakeMonitorImage(imageDir,imagePrefix,calFileSpec,T_cones,S_cones,...
%    [TONEMAP],[SRGB],[clipLevelFactor],[clipLumFactor])
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
% 5/22/04   bx          Wrote it from example in SelectSpecificPoints.m 
% 5/27/04   dhb, bx     Clean up a little.
% 6/28/04   dhb, bx     Add tone mapping factor parameters

% Set default values
if (nargin < 6 | isempty(TONEMAP))
    TONEMAP = 1;
end
if (nargin < 7 | isempty(SRGB))
    SRGB = 0;
end
if (nargin < 8 | isempty(clipLevelFactor))
    clipLevelFactor = 10;
end
if (nargin < 7 | isempty(clipLumFactor))
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

% Make cone image.
coneImage  = SimSimulateCamera(inputImageFile,theCamera,cameraDistance,exposureDuration,fStop);

% Load monitor calibration information.  This code matches what is also
% done SimRenderOnMonitor, but we need the calibration structure at
% this level too.
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

 eval([imagePrefix 'LMSImage = coneImage.images;'])
% %size('LMSImage')
% a = fullfile(imageDir,[imagePrefix 'LMSImage'])
% b = [imagePrefix 'LMSImage']
% %save fullfile(imageDir,[imagePrefix 'LMSImage']) [imagePrefix 'LMSImage'] ; 


figure; clf;
imshow(uint8(monitorImage.images));
drawnow;

eval([imagePrefix 'MonitorImage = monitorImage.images;']);
eval(['save ' fullfile(imageDir,[imagePrefix 'MonitorImage']) ' ' imagePrefix 'MonitorImage' '']);
minMonitorVal = min(monitorImage.images(:));
maxMonitorVal = max(monitorImage.images(:));
fprintf('Monitor image min/max: %g, %g\n',minMonitorVal,maxMonitorVal);
 
    
cd(imageDir);   
%save the .tif file of the monitor images
%imwrite(uint8(monitorImage.images), 'split_roomBleft.tiff','tif');
%unix(['mv *.tiff ../FinalImages/']);
%unix(['mv *LMSImage.mat ../FinalImages/']);
unix(['mv *MonitorImage.mat ../FinalImages/']);
cd ..;



