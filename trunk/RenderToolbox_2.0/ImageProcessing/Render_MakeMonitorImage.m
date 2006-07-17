function Render_MakeMonitorImage(currentConditions)
% Render_MakeMonitorImage(currentConditions)
%
% Create a monitor image based on the the cone image. Looks in
% cone_image_data/ for the cone image and saves the monitor image data in
% monitor_image_data/
%
% 2/2/2006 dpl wrote it. based on bx's RenMakeMonitorImageNew

%get stuff from currentConditions
calibrationFile=currentConditions.calibrationFile;
imageDirectory=currentConditions.imageDirectory;
monitorImageDirectory=currentConditions.monitorImageDirectory;
coneImageDirectory=currentConditions.coneImageDirectory;
sceneName=currentConditions.sceneName;
conesSuffix=currentConditions.humanCones;
TONEMAP=currentConditions.tonemap;

%load human cones
coneName=['T_cones_' conesSuffix];
load(coneName);
eval(['T_cones=T_cones_' conesSuffix ';']);
eval(['S_cones=S_cones_' conesSuffix ';']);

%if monitor image directory doesn't exist yet, make it
if (~exist(monitorImageDirectory,'dir') )
    mkdir(monitorImageDirectory);
end

%see if we're doing srgb
if strcmp(calibrationFile,'srgb')
    SRGB=1;
else
    SRGB=0;
end

%get cone image
coneImageName=[sceneName 'coneImage.mat'];
load([coneImageDirectory '/' coneImageName]);

%set defaults
%**(these settings should be moved somewhere so they're flexible)
clipLevelFactor = 10;
clipLumFactor = 0.5;

%prepare the camera
% cameraDistance = 10;
% exposureDuration = 2;
% fStop = 5.6;
theCamera = SimMakeConesCamera(T_cones,S_cones);
theImageName = fullfile(imageDirectory,sceneName); 
inputImageFile = [theImageName '.Simg'];
T_camera = SimAdjustSensors(coneImage,theCamera);
S_camera = [theCamera.wavelengthSampling.start ...
            theCamera.wavelengthSampling.step ...
            theCamera.wavelengthSampling.numberSamples];


%prepare the monitor file if we're not using SRGB
if ~SRGB
    % Grab monitor calibration file
    %*********
    %**(NOTE:SimCalToMonitor needs to know where to find the proper calibration
    %files for the mapping (StereoRight_8.mat,StereoLeft_8.mat) which I found
    %to be in MATLAB701/toolbox/PsychCalLocalData. without specifying
    %otherwise, SimCalToMonitor looks in
    %MATLAB701/toolbox/Psychtoolbox/PsychCalDemoData. as a temporary fix to
    %this, I put these files into the latter file. this WILL cause problems
    %when the script is run on another machine.)
    theMonitorFile = SimCalToMonitor(calibrationFile);
    if (~isstruct(theMonitorFile))
        monitor = SimReadMonitor(theMonitorFile);
    else
        monitor = theMonitorFile;
    end
    monitor = SetSensorColorSpace(monitor,T_camera,S_camera);
    monitor = SetGammaMethod(monitor,1);
end

% Load color matching functions.  We need XYZ for both
% tone mapping and SRGB.
whichXYZ = '1931';
eval(['load(''T_xyz' whichXYZ ''')';]);
eval(['T_xyzRaw = T_xyz' whichXYZ ';']);
eval(['S_xyzRaw = S_xyz' whichXYZ ';']);

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
	monitorImage = SimRenderOnMonitor(coneImage,theMonitorFile,1,0,0,1);
end

% Gamma correct
if (SRGB) 
    monitorImage.images = SRGBGammaCorrect(monitorImage.primaryImages);
else
	monitorImage = SimRenderOnMonitor(monitorImage,theMonitorFile,1,0,0,2);
end

%save it
eval([sceneName 'MonitorImage = monitorImage.images;']);
eval(['save ' fullfile(monitorImageDirectory,[sceneName '_MonitorImage']) ' ' sceneName 'MonitorImage' '']);

