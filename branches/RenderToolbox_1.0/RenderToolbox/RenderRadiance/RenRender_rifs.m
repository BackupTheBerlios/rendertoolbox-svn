function RenRender_rifs(wavelengths,rif_struct)
% RenRender_rifs(wavelengths,rif_struct)
%
% Render a hyperspectral image using a 
% rif_struct as input.  The struct specifies
% the name of the .rif files, which should already
% have been created for each wavelength.  Each .rif
% file is rendered by calling Radiance with function 'rad'.
% Generates .pic files as output.
%
% 3/11/04  dhb, bx  Added comments.

lim = length(wavelengths);
for i = 1:lim
    S = ['rad ',rif_struct.rif_name,'_',int2str(wavelengths(i)),'.rif'];
    unix(S);
end