% genSpectrumsFromCrhom
clear all; Close all;

%08/19/05 bx wrote it

% Load in illumination spectrum
% Define hyperspectral wavelength sampling that we are going to use.
S = [400 10 31];
wls = SToWls(S);

load spd_D65
illumspectrum = SplineSrf(S_D65,spd_D65,S);
e = illumspectrum;

% Load in Standard surface linear model
load B_nickerson
Bs = SplineSrf(S_nickerson,B_nickerson(:,1:3),S);
clear S_nickerson B_nickerson

% assign uv values
uvTable = [0.185 0.419;0.226 0.508;0.242 0.450;0.153 0.489;0.192 0.445; 0.212 0.489;0.221 0.460;0.174 0.479]';
fraction = 0.5;

% get the spectrum data from inverse calculations
surSpectrum = RenSpectrumfromChrom(uv,e,Bs,S,fraction);
