function Data_GenerateSpd_D65
% function Data_GenerateSpd_D65
%
% Generates the spd_D65 file and saves it in the current working directory.
% It is loaded from the spd_D65 file in the Psychtoolbox and multiplied by
% a constant lightPower (which is coded as 7 for now). The file contains
% spd_D65, an array with the D65 SPD and S_D65, specifying the wavelength
% sampling in which it is stored. This is the same format in which SPDs are
% stored in the Psychtoolbox.
% 
% 3/7/06 dpl wrote it.

%define constants
S=[400 10 31];
lightPower=7;

%delete existing file if it exists so that when we load the spectrum below,
%it loads from the Psychtoolbox, not what we've already saved
if exist('./spd_D65.mat','file');
    unix('rm spd_D65.mat');
end

wls=MakeItWls(S);

%load spd_D65 for light spectrum.
load spd_D65
illumspectrum = SplineSpd(S_D65,spd_D65,S);

%get illumination spectrum for D65
lightPower=lightPower;
for i = 1:length(wls)
    illuminantionWatts(i) = illumspectrum(i)*lightPower;
end

%create variabels to save (make spd_D65 a column vector)
spd_D65=illuminantionWatts';
S_D65=S;

%save
save spd_D65 spd_D65 S_D65;