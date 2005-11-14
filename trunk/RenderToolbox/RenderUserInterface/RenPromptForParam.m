% Script that define the material properties of each object 
% Run this script before running RenRenderMaster
%
% Ask User input surface reflectance parameters for each objects
% identify if it is a light or an object
% save the parameters into a file that could be used later.
%
% 3/17/04   bx wrote it.
clear; 
% get currrent dir
predir = pwd;

% Define hyperspectral wavelength sampling that we are going to use.
S = [400 10 31];
wls = SToWls(S);

% Load in human cones
load T_cones_ss2;
T_cones = T_cones_ss2;
S_cones = S_cones_ss2;

% load in spectrum
load sur_nickerson
surfaceList = SplineSrf(S_nickerson,sur_nickerson,S);

% Define a light spectrum.  Here we use equal energy white.
for i = 1:length(wls)
    illuminantWatts(i) = 5000;
end
objNames = textread('obj_list.txt','%s','delimiter',' ','whitespace','');
objCount = length(objNames);
for i = 1:objCount
    objNames{i} = objNames{i}(1:end-4);
end
objDir = prompt_value('obj_03','\nSpecify obj directory [%s]: ');
cd(objDir);

cmd = ['ls *.obj *.rad > obj_list.txt'];
unix(cmd);
cmd = ['mv obj_list.txt ..'];
unix(cmd);
cd ..;
objNames = textread('obj_list.txt','%s','delimiter',' ','whitespace','');
objCount = length(objNames);
for i = 1: objCount
    materialParam.name = objNames{i};
	objType = prompt_value('ward',[char(objNames(i)),'\nSpecify type [%s]:']);
	materialParam.type =objType; 
    
    switch (objType)
        case 'ward',
            rho_s = str2num(prompt_value(0.5,'\nSpecify specular reflectance [%s]:'));
			materialParam.rho = rho_s; 
			alpha = str2num(prompt_value(0.3,'\nSpecify roughness [%s]:'));
			materialParam.alpha =alpha; 
%             index = rem(i*100,size(surfaceList,2)-1)+1;
%            if (i==1)
%             materialParam.spectrum = surfaceList(:,210); 
%            else 
%             materialParam.spectrum  = surfaceList(:,index); 
%            end  
             index = str2num(prompt_value(200,'\nSpecify Surface Spectrum Index [%s]:'));
             materialParam.spectrum  = surfaceList(:,index); 
             materialParam.wavelength = wls; 
        case 'light',
	        materialParam.spectrum = illuminantWatts;
            materialParam.wavelength = wls; 
        otherwise
            error(sprintf('Unsupported material type %s entered\n',materialStructures(i).type));
    end 
        a = objNames{i};
        save(a, 'materialParam');
   end      
   cd(predir); 
   
   