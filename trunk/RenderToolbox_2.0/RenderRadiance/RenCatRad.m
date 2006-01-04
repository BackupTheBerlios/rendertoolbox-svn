function RenCatRad(wls, dirName)
% function that cat individual .rad files for each object into one file that
% contanins all the material information for the use in .rif file
%
% 05/12/04 bx wrote it.

wavelength_count = length(wls);

%unix('rm obj_material*.*');
for i = 1:wavelength_count;
          
            wavelength = int2str(wls(i));
            cd(dirName);
            filename = 'obj_material';
            out_name = [filename,'_',wavelength,'.rad'];
            fid = fopen(out_name,'w');
            [a,b] = unix(['cat *_',wavelength,'.rad']);
            new_output = b;
            count = fprintf(fid,'%s',new_output);
            fclose(fid);
            cd ..
end