function [LMScoords] = fromSpectoLMS(index)

% function [targetLab, LMScoords] = fromSpectoLMS(index)

% Load in illumination spectrum
% Define hyperspectral wavelength sampling that we are going to use.
S = [400 10 31];
wls = SToWls(S);


lightpower = 1;

% Load in human cones
load T_cones_ss2;
T_cones = T_cones_ss2;
T_cones = SplineCmf(S_cones_ss2,T_cones_ss2,S);
S_cones = S_cones_ss2;

uvTable = [0.185 0.419;0.226 0.508;0.242 0.450;0.153 0.489;0.192 0.445; 0.212 0.489;0.221 0.460;0.174 0.479]';
uv  =  uvTable(:,index);

% load in illumination spectrum
load spd_D65
illumspectrum = SplineSrf(S_D65,spd_D65,S);
e = illumspectrum;
for i = 1:length(wls)
    illuminantWatts(i) = illumspectrum(i)*lightpower; 
end

% Load in Standard surface linear model
load B_nickerson
Bs = SplineSrf(S_nickerson,B_nickerson(:,1:3),S);
clear S_nickerson B_nickerson

% assign a chromaticity
fraction = 0.5;
% get the spectrum data from inverse calculations
testSpectrum = RenSpectrumfromChrom(uv,e,Bs,S,fraction);

LMScoords = T_cones*diag(illuminantWatts)*testSpectrum; 