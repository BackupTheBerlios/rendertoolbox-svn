function RenWrite_rifs(wavelengths,rif_struct,whichCondition,catObjFlag);
% 
% Writes a .rif for each wavelength based on the rad files in the materials,
% objects, and lights directory.  Values are read in from the rif_struct.
%
% Currently hard coded for a specific form of the rif_struct.  Will need to
% be modified if the definition of rif_struct is changed.  In particular,
% if fields are added to the rif_struct, then you need to add lines here
% to write the correct output.
%
% Builds output in part from contents of the materials, objects, and lights
% directorires.
%
% See also RenMake_rif_struct, RenRender_rifs
%
% 2/12/04   pk, bx  wrote it.
% 2/19/04   bx      modified it.
% 3/9/04    bx      modified and changed name 
% Need to be fixed to take !cat .rad into a big rad file
% 5/12/04   bx      modified it and make it able to read in  one big .rad
%                   file
% 8/01/05   bx      modified to move .rif into subfolder.
% 9/14/05   bx      modified and made the choice of wheter to use one big
% .rad file or individual .rad files of all the objects.

[a,b] = unix(['ls lights','_',int2str(whichCondition),'/*']);
light_rad = regexprep(b,char(10),' ');
if( catObjFlag == 0)
 [c,d] = unix(['ls objects','_',int2str(whichCondition),'/*.rad']);
else
 [c,d] = unix(['ls objects','_',int2str(whichCondition),'/masterObj.rad']);
end

obj_rad = regexprep(d,char(10),' ');
scenes = [light_rad,obj_rad];
lim = length(wavelengths);

% define material folder
materialFolder = sprintf('%s_%d','materials',whichCondition);

for i = 1:lim
    
    S = '';
    S = [S,'OCTREE = ',rif_struct.octree,'_',int2str(wavelengths(i)),'.oct',char(10)];
    S = [S,'ZONE = ',rif_struct.zone,char(10)];
    S = [S,'EXPOSURE = ',rif_struct.exposure,char(10)];
    [a,b] = unix(['ls materials','_',int2str(whichCondition),'/obj_material','_',int2str(wavelengths(i)),'.rad']);
    b = regexprep(b,char(10),' ');    
    S = [S,'materials = ',b,char(10)];
    S = [S,'scene = ',scenes,char(10)];
    S = [S,'UP = ',rif_struct.z,char(10)];
    S = [S,'view = ',rif_struct.view,char(10)];
    S = [S,'RESOLUTION = ', rif_struct.resolution,char(10)];
    S = [S,'QUALITY = ',rif_struct.quality,char(10)];
    S = [S,'PENUMBRAS = ',rif_struct.penumbras,char(10)];
    S = [S,'PICTURE = ',rif_struct.picture,'_',int2str(wavelengths(i)),char(10)];
    S = [S,'VARIABILITY = ',rif_struct.variability,char(10)];
    S = [S,'INDIRECT = ',rif_struct.indirect,char(10)];
    S = [S,'DETAIL = ',rif_struct.detail,char(10)];
    S = [S,'REPORT = ',rif_struct.report,char(10)];
    S = [S,'render = ',rif_struct.render,char(10)]; 
    fid = fopen([rif_struct.rif_name,'_',int2str(wavelengths(i)),'.rif'],'w');  
    count = fprintf(fid,'%s',S);
    fclose(fid);
    
end