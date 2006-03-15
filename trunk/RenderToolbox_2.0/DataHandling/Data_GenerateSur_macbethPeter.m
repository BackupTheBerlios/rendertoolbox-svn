function Data_GenerateSur_macbethPeter
% function Data_GenerateSur_macbethPeter
%
% Generates the sur_macbethPeter.mat file and saves it in the current
% working directory. This is generated directly from loading the
% sur_macbethPeter lookup table in the PsychToolbox. The file contains the
% matrix sur_macbethPeter which lists the SRF for each value of the lookup
% table. It also contains the variable S_macbethPeter specifying the
% wavelength sampling in which sur_macbethPeter is stored. The format of
% this file matches that used by SRF lookup tables in David Brainard's
% PsychToolbox.
% 
% 3/7/06 dpl wrote it.

%delete existing file if it exists so that when we load the spectrum below,
%it loads from the Psychtoolbox, not what we've already saved
if exist('./sur_macbethPeter.mat','file');
    unix('rm sur_macbethPeter.mat');
end

%do macbeth stuff
load sur_macbethPeter;
save sur_macbethPeter sur_macbethPeter S_macbethPeter;