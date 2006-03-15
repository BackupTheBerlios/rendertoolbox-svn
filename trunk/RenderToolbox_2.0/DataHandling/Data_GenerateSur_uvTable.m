function Data_GenerateSur_uvTable
% function Data_GenerateSur_uvTable
%
% Generates the sur_uvTable.mat file and saves it in the current working
% directory. The file contains the matrix sur_uvTable which lists the SRF
% for each value of the UV lookup table. It also contains the variable
% S=[400 10 31] specifying the wavelength sampling in which sur_uvTable is
% stored. The format of this file matches that used by SRF lookup tables 
% in David Brainard's PsychToolbox.
% 
%
% 2/12/06 dpl wrote it. UVTable part based on bx's RenSpectrumfromChrom
% 3/7/06 dpl made this function only for the UV lookup table

%define constants
S=[400 10 31];

%uv constants
uvTable = [0.185 0.419;0.226 0.508;0.242 0.450;0.153 0.489;0.192 0.445; 0.212 0.489;0.221 0.460;0.174 0.479]';
fraction = 0.5;

%delete existing file if it exists so that when we load the spectrum below,
%it loads from the Psychtoolbox, not what we've already saved
if exist('./sur_uvTable.mat','file');
    unix('rm sur_uvTable.mat');
end

%load some stuff
load spd_D65
illumspectrum = SplineSrf(S_D65,spd_D65,S);
e=illumspectrum;
load B_nickerson;
Bs = SplineSrf(S_nickerson,B_nickerson(:,1:3),S);
clear S_nickerson B_nickerson
load T_xyz1931
T = T_xyz1931;
T = SplineCmf(S_xyz1931,683*T,S);
theXYZ = T*e; theLuminance = theXYZ(2);

%**(most of this taken from bx's code)
for uvValue=1:length(uvTable)
    %get uvValue
    uv=uvTable(:,uvValue);

    %get the surface Y value from taking the fraction from the illuminant
    surfaceY = fraction*theLuminance;

    XYZ = uvYToXYZ([uv ; fraction]);
    
    % calculate the surface reflectacne spectrum given illumination and uvY and
    % basis function
    s = Bs*inv(T*diag(e)*Bs)*XYZ;
    s = s/max(s);
    
    %put into table
    sur_uvTable(:,uvValue)=s;                                       
end

%save uvTable stuff
S_uvTable=S;
save sur_uvTable sur_uvTable S_uvTable;