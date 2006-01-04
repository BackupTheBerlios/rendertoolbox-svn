function [monitor, theCamera,T_camera,S_camera] = RenCalMonitor(coneImage,calFileSpec,T_cones,S_cones) 
% function [monitorImage] = RenCalMonitor(coneImage,calFileSpec,T_cones,S_cones) 
%
% Load the calibration file in calFileSpec, and initialize according
% to sensors specified in coneImage.  This uses the SimToolbox image
% conventions to get us a Psychtoolbox calibration structure ready
% for action.  Also returns camera description appropriate for rendering
% coneImage.
%
% coneImage: The image to be rendered.
% calFileSpec: Calibration information.
% T_cones: Cone spectral sensitivities.
% S_cones: Wavelength sampling for T_cones.
%
% 7/01/04   bx      Wrote it from RenMakeMonitorImage.m
%           bx, dhb Change interface and fix up comments.  Remove redundant
%                       junk.


% Grab monitor calibration file
monitor = SimCalToMonitor(calFileSpec);

% Load color matching functions.  Make a camera
% from passed cone sensors.
theCamera = SimMakeConesCamera(T_cones,S_cones);

% Scale sensors to match specified image file (exposure
% duration, etc.)
T_camera = SimAdjustSensors(coneImage,theCamera);
S_camera = [theCamera.wavelengthSampling.start ...
		    theCamera.wavelengthSampling.step ...
            theCamera.wavelengthSampling.numberSamples];
        
% Initialize calibration file for cones and gamma method.
monitor = SetSensorColorSpace(monitor,T_camera,S_camera);
monitor = SetGammaMethod(monitor,1);