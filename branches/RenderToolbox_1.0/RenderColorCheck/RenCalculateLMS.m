%Script RenCalculateLMS
% Calculate LMS cone coordinates for each surface in the scene
% using illumination and surface spectrum power distribution
% T_cones*diag(illum)*surface_i
%  Save the LMS data in a file
%
% 3/28/04  bx wrote it

clear; 
% get currrent dir
predir = pwd;

% Define hyperspectral wavelength sampling that we are going to use.
S = [400 10 31];
wls = SToWls(S);

% Load in human cones

load T_cones_ss2;
T_cones = SplineCmf(S_cones_ss2,T_cones_ss2,S);
S_cones = S;

objNames = textread('obj_list.txt','%s','delimiter',' ','whitespace','');
objCount = length(objNames);
for i = 1:objCount
    objNames{i} = objNames{i}(1:end-4);
end


objDir = 'obj_04';

ConeCoord = cell(1,objCount-1);
for j = 1: length(objNames)
        eval(['load',' ',objDir,'/',objNames{j},'.mat']);
        switch (materialParam.type)
        case 'light',
		illumSpectrum = materialParam.spectrum;	
        case 'ward',
        surfaceSpectrum = materialParam.spectrum;
        ConeCoord {j-1}  = T_cones*diag(illumSpectrum)*surfaceSpectrum;   
        otherwise
       error(sprintf('Unsupported material type %s entered\n',materialStructures(i).type));
        end
end

save Conecoords  ConeCoord