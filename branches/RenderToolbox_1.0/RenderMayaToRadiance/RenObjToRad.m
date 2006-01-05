function RenObjToRad(objDir,whichCondition)
% RenObjToRad(objDir)
%
% Converts all the obj's in a given directory to rad files, and sorts these
% into lights and objects files.  Creates ./projDir/lights and ./projDir/objects directors and put lights.rad (which is already generated in Maya) and 
% and objects.rad(which is converted here) in the corresponding dirs. 
% An example of the result after running this function will be:
% ./proj_03/lights/point_light.rad .....
% ./proj_03/objects/globe.obj.rad  table.obj.rad room.obj.rad .....
% 
%Basic purpose is to get Maya output ready for Radiance.
%
% 1/26/04   pk          Wrote
% 2/2/04    pk, bx      Modified
% 3/5/04    dhb, bx     Change "geometry" -> "objects", don't make "materials" here.              
% 3/9/04    bx          Added comments
% 9/27/05   dhb, bx     Remove hard path coding.
% 7/29/05   bx          Modified. Append condition number to the objects
%                       directory in order to avoid overwriting in  parrallel computing


% Make sure there is no file named obj_list.txt.
[a,b] = unix('rm obj_list.txt');

% Create a list of each obj to be converted.
cd(objDir);
cmd = ['ls *.obj *.rad > obj_list.txt'];
unix(cmd);
cmd = ['mv obj_list.txt ..'];
unix(cmd);
cd ..;

% Get the names of each obj into a cell array of strings.
obj_names = textread('obj_list.txt','%s','delimiter',' ','whitespace','');

% For each obj, use obj2rad to convert it to a rad file
obj_count = length(obj_names);
% Specify output ojects direcotry
outputObjDir = sprintf('%s_%d','objects',whichCondition);
outputLightDir = sprintf('%s_%d','lights',whichCondition);

% Create a new directory for the light geometry
if (~exist(outputObjDir,'dir') )
    mkdir(outputObjDir);
end

% Create a new directory for the object geometry
if (~exist(outputLightDir,'dir') )
    mkdir(outputLightDir);
end


for i = 1:obj_count;
    % Find if the obj file is a light or an object
    [d,e] = regexp(char(obj_names(i)),'light');
    not_light = isempty(d);
    
    % find if it is radiance polygones, sphere, plane....box
    [d,e] = regexp(char(obj_names(i)),'sphere');
    sphere = ~(isempty(d));
    
    [d,e] = regexp(char(obj_names(i)),'plane');
    plane = ~(isempty(d));
    
    % If it is an object, use obj2rad to convert .obj to a .rad file and save it into the dir "objects"   
    if (not_light == 1)     
      if(sphere == 1)
         cmd = char(strcat('obj2rad',{' '},objDir,'/',obj_names(i),strcat({' '},'> ',{' '},outputObjDir,'/'),obj_names(i),'.rad')); 
        %cmd = char(strcat('cp',{' '},objDir,'/',obj_names(i),{' '},outputObjDir,'/', obj_names(i)));
         %cmd = char(strcat('cp',{' '},objDir,'/',obj_names(i),' objects','_',int2str(whichCondition), '/',obj_names(i)));
      %elseif (plane == 1)
        %cmd = char(strcat('cp',{' '},objDir,'/',obj_names(i),{' '},outputObjDir,'/', obj_names(i))); 
        %cmd = char(strcat('cp',{' '},objDir,'/',obj_names(i),' objects','_',int2str(whichCondition), '/',obj_names(i)));
      else  
        cmd = char(strcat('obj2rad',{' '},objDir,'/',obj_names(i),strcat({' '},'> ',{' '},outputObjDir,'/'),obj_names(i),'.rad'));  
        %cmd = char(strcat('obj2rad',{' '},objDir,'/',obj_names(i),{' > objects/'},obj_names(i),'.rad'));  
      end    
      
    % If it is a light, directly copy it into the dir "lights". 
    else
      %cmd = char(strcat('cp',{' '},objDir,'/',obj_names(i),{' '},outputLightDir,'/',obj_names(i)));
      cmd = char(strcat('cp',{' '},objDir,'/',obj_names(i),' lights','_',int2str(whichCondition), '/',obj_names(i)));
    end
    
    unix(cmd);
end