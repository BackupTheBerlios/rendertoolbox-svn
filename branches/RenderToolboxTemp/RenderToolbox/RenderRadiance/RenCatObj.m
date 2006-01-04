function RenCatObj(objDir)
% function RenCatObj(objDir)
% Cat .rad file in the object directory into one single .rad file 
% for the simplicity of the usage in .rif file
%
% 5/12/04 bx wrote it

cd(objDir)
filename = 'masterObj';
[a,b] = unix('rm masterObj.rad');
out_name = [filename,'.rad'];
            fid = fopen(out_name,'w');
            [a,b] = unix(['cat *','.rad',char(10)]);
            new_output = b;
            count = fprintf(fid,'%s\n',new_output);
            fclose(fid);
            cd ..