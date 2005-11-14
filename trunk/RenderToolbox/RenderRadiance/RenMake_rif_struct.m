function rif_struct = RenMake_rif_struct(render_name, imageRes,whichImage);
% rif_struct = RenMake_rif_struct(render_name);
%
% Generate a template rif_struct.  Sets up default values,
% which can be modified.
%
% See also RenWrite_rifs, RenRender_rifs
%
% 2/12/04   pk      Wrote.
% 8/23/04   bx      make image resolution as variable

rif_struct.octree = render_name;
rif_struct.zone = 'Interior 0 40.1 0 25.5 0 19.4';
rif_struct.exposure = '1.0';
rif_struct.z = 'Z';

if (whichImage == 1)
 rif_struct.view = '-vf  view_left_01.vf';
else 
 rif_struct.view = '-vf view_right_01.vf';
end 
rif_struct.resolution = imageRes;
rif_struct.quality = 'Medium';
rif_struct.penumbras = 'True';
rif_struct.picture = render_name;
rif_struct.variability = 'Medium';
rif_struct.indirect = '2';
rif_struct.detail = 'Medium';
rif_struct.report = '0.2';
rif_struct.render = '-dj 0.6 -dt 0.01 -dr 3 -ds 0.1 -sj 0.7 -st 0.15 -dc 0.5 -lr 1 -aw 0 -av 0.5 0.5 0.5';
rif_struct.rif_name = render_name;
