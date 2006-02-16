% Script RenderRoom 
% Master script for the split_roomB project.
%
% 
%
% This script encapsulates the project specific assignment of material
% properties to Maya generated objects.
%
% 6/09/04 bx wrote it.
% 7/29/05 bx modified it and added comments. make the routine dependent on
% condition number
% 8/01/05 bx modified it.
% 8/19/-5 bx modified it.

% Clear out variables
%clear all; close all;

function  RenderRoom(whichCondition, scene_name,uvPatch, patchLocation,calfile, whichImage,rho_s_left, alpha_left,coneImageDir,lightpower,tableColor, flPattern,imageRes,rifDir)

patchLocation
succeed = 0;
% Get currrent dir
predir = pwd;

imageRes = '800';
% Define hyperspectral wavelength sampling that we are going to use.
S = [400 10 31];
wls = SToWls(S);

% Load in human cones
load T_cones_ss2;
T_cones = T_cones_ss2;
S_cones = S_cones_ss2;


 
% Load in MCC spectra.  We're going to assign these to
% various objects in the room.
load sur_macbethPeter
surfaceList = sur_macbethPeter;


% For dark objects, create spectrum with 0 weights.
darkPixels = zeros(31,1);

% Load in light for rendering.  The factor of 20 puts numbers
% into a reasonable range.  This scale factor is irrelevant in
% the end because the actual displayed luminances are the result
% of tone mapping into the monitor gamut.
load spd_D65
illumspectrum = SplineSrf(S_D65,spd_D65,S);
e = illumspectrum; 
for i = 1:length(wls)
    illuminantWatts(i) = illumspectrum(i)*lightpower;
    noLights(i)  = illumspectrum(i)*0; 
end

% calculate surface spectrum for the specific UV value for the test sphere.

% Load in Standard surface linear model
load B_nickerson
Bs = SplineSrf(S_nickerson,B_nickerson(:,1:3),S);
clear S_nickerson B_nickerson

% assign a chromaticity
fraction = 0.5;
% get the spectrum data from inverse calculations
%sphereSpectrum = RenSpectrumfromChrom(uvSphere,e,Bs,S,fraction);
patchSpectrum = RenSpectrumfromChrom(uvPatch,e,Bs,S,fraction);
    
% Create a list of each obj to be converted and then
% get these names into MATLAB.  Done through a temporary
% file called obj_list.txt.
[a,b] = unix('rm obj_list.txt');
%objDir = prompt_value('obj_03','\nSpecify obj directory [%s]: ');

fprintf('which obj folder \n');
% specify which obj dir to use.  Different obj dirs contains different
% locations of the test patches
switch (patchLocation)
    case 'center'
      objDir = 'obj_01';
    case 'top'
      objDir = 'obj_02';
    case 'bottom'
      objDir = 'obj_03';
    case 'side'
      objDir=  'obj_04';
end        

objDir

cd(objDir);
cmd = ['ls *.obj *.rad > obj_list.txt'];
unix(cmd);

% Get object names from object list
objNames = textread('obj_list.txt','%s','delimiter',' ','whitespace','');
objCount = length(objNames);
for i = 1:objCount
    objNames{i} = objNames{i}(1:end-4);
end
[a,b] = unix('rm obj_list.txt');
objCount = length(objNames);
fprintf('assign materials\n');
for i = 1:objCount
    % Here we go through each material.  This scene
    % has one light source, one sphere, a room, and a
    % bunch of chips.
	materialParam.name = objNames{i};
	[d,e] = regexp(char(objNames(i)),'light');
	not_light = isempty(d); 
	
	[d,e] = regexp(char(objNames(i)),'ball');
	ball = ~(isempty(d));
	
	[d,e] = regexp(char(objNames(i)),'room');
	room = ~(isempty(d));
    
	[d,e] = regexp(char(objNames(i)),'checker');
    theFloor = ~(isempty(d));
    
    [d,e] = regexp(char(objNames(i)),'backwall');
    theBackwall = ~(isempty(d));
    
    
    [d,e] = regexp(char(objNames(i)),'face');
	face = ~(isempty(d));
    
    %[d,e] = regexp(char(objNames(i)),'board');
	%board = ~(isempty(d));
    
    
	% Decide whether it is an object or a light source
	if (not_light == 1)  
	    objType = 'ward';
	    materialParam.type = objType;   
	else
	    objType = 'light';
	    materialParam.type = objType;
	end   
  
    switch (objType)
        case 'ward',
            % if the object is a sphere, assign specific BRDF parameters
            if (ball == 1) 
                % Assign material parameters to the target sphere

				materialParam.rho = rho_s_left; 
				materialParam.alpha =alpha_left
                materialParam.spectrum = surfaceList(:,22);
                materialParam.wavelength = wls;
           elseif (face == 1) 
                [d,e] = regexp(char(objNames(i)),'test');
	            centerFace = ~(isempty(d));
                [d,e] = regexp(char(objNames(i)),'black');
	            blackFace = ~(isempty(d));
                if (centerFace ==1)             
                    materialParam.rho = rho_s_left;
                    materialParam.alpha = alpha_left;
                    materialParam.spectrum = patchSpectrum;
                    materialParam.wavelength = wls; 
                    elseif (blackFace ==1)
                    materialParam.rho = rho_s_left;
                    materialParam.alpha = alpha_left;
                    materialParam.spectrum = surfaceList(:,24);
                    materialParam.wavelength = wls; 
                    else
                    materialParam.rho = rho_s_left;
                    materialParam.alpha = alpha_left;
                    materialParam.spectrum = surfaceList(:,19);
                    materialParam.wavelength = wls; 
                end
%             elseif (board ==1)
% 				materialParam.rho = '0.0'; 
% 				materialParam.alpha = '0.0';
%                 materialParam.spectrum = surfaceList(:,23);
%                 materialParam.wavelength = wls;   
%                
%             elseif (tablecloth == 1)
%                 if (length(materialParam.name) <5)
%                    whichMcc = str2num(materialParam.name(4));
%                 else
%                    whichMcc =str2num([materialParam.name(4),materialParam.name(5)]);
%                 end   
%                 materialParam.rho = '0.0';
%                 materialParam.alpha = '0.0';
%                 materialParam.spectrum = surfaceList(:,whichMcc);
%                 materialParam.wavelength = wls;                       
            elseif (room == 1) 
                rho_room = '0.0';
                materialParam.rho = rho_room;
                alpha = '0.0';
                materialParam.alpha = alpha;
                materialParam.spectrum = surfaceList(:,20);
                materialParam.wavelength = wls; 
            % If it is a surface and not the sphere or the room, then it is
            % a table.  (This is specific to this scene.)  In this case we
            % assign it one of the color checker colors.
            elseif (theFloor ==1);
                [d,e] = regexp(char(objNames(i)),'black');
	            whichChecker = ~(isempty(d));
                if (whichChecker ==1);
                    rho_s = '0.05';
					materialParam.rho = rho_s; 
					alpha = '0.05';
					materialParam.alpha =alpha; 
                    if (flPattern == 1)
                    materialParam.spectrum = surfaceList(:,24);
                    else
                    materialParam.spectrum = surfaceList(:,19);
                    end
                    %materialParam.spectrum = darkPixels; 
                    materialParam.wavelength = wls; 
                else
                    rho_s = '0.05';
					materialParam.rho = rho_s; 
					alpha = '0.05';
					materialParam.alpha =alpha; 
                    if (flPattern ==1)
                    materialParam.spectrum = surfaceList(:,19);
                    else
                    materialParam.spectrum = surfaceList(:,24);
                    end
                    %materialParam.spectrum = darkPixels;
                    materialParam.wavelength = wls; 
                end  
            elseif (theBackwall == 1);
                rho_wall = '0.0';
                materialParam.rho = rho_wall;
                alpha = '0.0';
                materialParam.alpha = alpha;
                materialParam.spectrum = surfaceList(:,24);
                %materialParam.spectrum = darkPixels;
                materialParam.wavelength = wls; 
            else
                rho_s = '0.00';
				materialParam.rho = rho_s; 
				alpha = '0.00';
				materialParam.alpha =alpha;  
                materialParam.spectrum  = surfaceList(:,tableColor);
                materialParam.wavelength = wls;       
            end        
        case 'light',
            materialParam.spectrum = illuminantWatts;
            materialParam.wavelength = wls;
            materialParam.lighttype = 'area';
        otherwise
            error(sprintf('Unsupported material type %s entered\n',materialStructures(i).type));
    end 
    
    % Store the material param structure for each material in a separate
    % file.  We use this later to render.
    a = objNames{i};
    save(a,'materialParam');
end 
cd(predir); 


fprintf('conver all of the objects to Radiance format\n');
% Convert all of the objects to Radiance format.
RenObjToRad(objDir,whichCondition); 

% Now we make materials folder
dirName = sprintf('%s_%d','materials',whichCondition);
if (~exist(dirName,'dir') )
    mkdir(dirName);
end


cd(dirName); unix('rm *.rad'); cd ..;

fprintf('construct material structures\n');
% Construct material structres for each light/surface object for
% Radiance.
for i = 1:objCount
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
            materialStructures(i).lighttype = materialParam.lighttype;
        otherwise
            error(sprintf('Unsupported material type %s entered\n',materialStructures(i).type));
    end
    
    % Make .rad files from the materialStructures
	RenStructToMaterial(materialStructures(i),char(objNames(i)),dirName);
end

fprintf('about to render\n'); 
% Generate hyperspetral images.  This is the rendering step where we
% use Radiance for each wavelength, drawing on the spectral information
% in the materials files we created just above.
RenCatRad(wls,dirName);
%objectDir = 'objects';
%RenCatObj(objectDir);
if(objCount >15)
    catObjFlag = 1;
    objectDir = sprintf('%s_%d','objects',whichCondition);
    RenCatObj(objectDir);
else
    catObjFlag = 0;
end
fprintf('cat files together\n');

% Make and write the rif structure for the whole scene.
rs = RenMake_rif_struct(scene_name,imageRes,whichImage);
fprintf('make and write rif files\n');
RenWrite_rifs(wls,rs,whichCondition,catObjFlag);

% Render the scene at each wavlength
RenRender_rifs(wls,rs);

% get the rif prefix
rifFilePrefix = rs.rif_name;

% Move the current project 's .rif, .pic.,.oct files into a subfolder.
% rifDir = sprintf('%s_%d','rifFiles',whichCondition);
% if (~exist(rifDir,'dir') )
%     mkdir(rifDir);
% end
cmd = char(strcat('mv',{' '},rifFilePrefix,'*.rif',{' '},rifDir,'/'));
unix(cmd);
cmd = char(strcat('mv',{' '},rifFilePrefix,'*.oct',{' '},rifDir,'/'));
unix(cmd);
cmd = char(strcat('mv',{' '},rifFilePrefix,'*_1.pic',{' '},rifDir,'/'));
unix(cmd);

% Pull the floating data out of the Pic file format.
picMat = RenPicToMat(wls,rs,rifDir);

% Use simulator toolbox to render a monitor image.  We may want to split
% out the LMS image as a separate step at some point.
RenHypMakeSimgFromPic('image_data',wls,rs,picMat);
coneImage = RenMakeConeImage('image_data',coneImageDir, rs.rif_name,T_cones,S_cones);

%calfile = 'StereoLeft_8';
%RenMakeMonitorImageNew(coneImage,'image_data',rs.rif_name,calfile,T_cones,S_cones,1,0,8,0.3);    
%RenRenderPurge;
