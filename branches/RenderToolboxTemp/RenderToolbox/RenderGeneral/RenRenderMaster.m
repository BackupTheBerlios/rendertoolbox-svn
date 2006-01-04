% RenderMaster
% 
% Script to take Maya output and create a rendered image.
%   Converts .obj to .rad
%   Runs Radiance in hyperspectral fashion
%   Uses calibration information to render down to RGB
%
% 2/3/04  bx            Wrote it.
% 3/4/04  dhb, bx       CHange name, begin to add comments.
% 3/9/04  bx            Debugged and added more comments
% 3/17/04 bx            Added the .pic file value routine
%                       Modified RenMakeSimgFromTiff to RenMakeSimgFromPic
%                       Put the user input script into RenPromptForParam
%                       THis program will only take care of the rendering
%                       process
% Make sure we don't confuse ourselves with variables lying around.
% 5/22/04  bx           Added some newly-written functions and deleted old
%                       ones.


clear; 

ToneMap = 1; 
% Get the working directory name.
working_dir = prompt_value('proj_03','\nSpecify working directory [%s]:');
cd(working_dir);

% Get the name of the obj directory and convert to rad.  Stuff in
% this directory was created by Maya beforehand.
objDir = prompt_value('obj_01','\nSpecify obj directory [%s]: ');
RenObjToRad(objDir);

% Construct vector of object names.  This gives us the list of stuff
% with which we need to associate material properites.
objNames = textread('obj_list.txt','%s','delimiter',' ','whitespace','');
objCount = length(objNames);
for i = 1:objCount
    objNames{i} = objNames{i}(1:end-4);
end

% Define hyperspectral wavelength sampling that we are going to use.
S = [400 10 31];
wls = SToWls(S);

% Load in human cones
load T_cones_ss2;
T_cones = SplineCmf(S_cones_ss2,T_cones_ss2,S);
S_cones = S;

% Load in some surface data.  These spectra will get
% associated with objects.  Eventually, we need to develop
% a system for conveniently specifying the reflectance spectra
% of objects in the scene, and passing that information here.
load sur_nickerson
surfaceList = SplineSrf(S_nickerson,sur_nickerson,S);

% % Define a light spectrum.  Here we use equal energy white.
% for i = 1:length(wls)
%     illuminantWatts(i) = 5000;
% end

% Make sure material output directory exists and create it if not.
dirName = 'materials';
if (~exist(dirName,'dir') )
    mkdir(dirName);
end
cd(dirName); unix('rm -rf *'); cd ..;

% Construct material structres for each light/surface object.
% At the moment we do this in a hand-drive manner, as we're just
% getting going.
for i = 1: objCount
    eval(['load',' ',objDir,'/',objNames{i},'.mat']);
	materialStructures(i).name = objNames(i);
    materialStructures(i).type = materialParam.type;
    switch (materialStructures(i).type)
        case 'ward',
			materialStructures(i).rho = materialParam.rho;
			materialStructures(i).alpha = materialParam.alpha;
	        materialStructures(i).spectrum  = materialParam.spectrum;
            materialStructures(i).wavelength = materialParam.wavelength; 
        case 'light',
            materialStructures(i).spectrum = materialParam.spectrum;
            materialStructures(i).wavelength = materialParam.wavelength; 
        otherwise
            error(sprintf('Unsupported material type %s entered\n',materialStructures(i).type));
    end
    % Make .rif files from the materialStructures
	RenStructToMaterial(materialStructures(i),char(objNames(i)),dirName);
end

% Input scene name from user
scene_name = prompt_value('SPItest01',['\nSpecify scene name[%s]:']);

% Generate hyperspeçtral images
%unix(['rm -rf *.rif']);
RenCatRad(wls,dirName);
objectDir = 'objects';
RenCatObj(objectDir);
rs = RenMake_rif_struct(scene_name);
RenWrite_rifs(wls,rs);
RenRender_rifs(wls,rs);
%Replace make_tiff with Radiance pvalue commend to store .pic file into
%Matlab matrix. 
picMat = RenPicToMat(wls,rs);
%RenMake_tiffs(wls,rs);
RenHypMakeSimgFromPic('image_data',wls,rs,picMat);
%Render the LMS image and display on the monitor 
RenMakeMonitorImage('image_data',rs,0,T_cones,S_cones,ToneMap);    
% Clean up rifs that we no longer need
%RenRenderPurge;

    
    
