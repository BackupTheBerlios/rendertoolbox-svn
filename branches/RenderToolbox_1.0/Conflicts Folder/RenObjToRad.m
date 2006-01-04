function RenObjToRad(objDir)
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

% Create a new directory for the light geometry
cmd = ['rm -rf lights; mkdir lights'];
[a,b] = unix(cmd);

% Create a new directory for the object geometry
cmd = ['rm -rf objects; mkdir objects'];
[a,b] = unix(cmd);

% For each obj, use obj2rad to convert it to a rad file
obj_count = length(obj_names);
for i = 1:obj_count;
    % Find if the obj file is a light or an object
    [d,e] = regexp(char(obj_names(i)),'light');
    not_light = isempty(d);
    
    [d,e] = regexp(char(obj_names(i)),'sphere');
    sphere = ~(isempty(d));
    
    % If it is an object, use obj2rad to convert .obj to a .rad file and save it into the dir "objects"   
    if (not_light == 1)
        
      if(sphere == 0)  
        cmd = char(strcat('/usr/local/radbin_osx/obj2rad',{' '},objDir,'/',obj_names(i),{' > objects/'},obj_names(i),'.rad'));
      else
        cmd = char(strcat('cp',{' '},objDir,'/',obj_names(i),' objects/', obj_names(i)));   
      end    
      
    % If it is a light, directly copy it into the dir "lights". 
    else
       cmd = char(strcat('cp',{' '},objDir,'/',obj_names(i),' lights/', obj_names(i)));
    end
    
    unix(cmd);
end
