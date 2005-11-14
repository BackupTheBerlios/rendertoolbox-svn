function RenStructToMaterial(mat,object_name,dirName)
% RenStructToMaterial(mat,object_name,dirName)
%
% Takes our RenderToolbox material structure and writes out the information
% into a set of rif files, one for each wavelength.  The filename is taken
% from the object_name arg and provides a unique identifier.  
% 
% 2/2/04    bx, pk      Wrote it.
% 3/5/04    bx, dhb     Change name, add comments, etc.

% Get number of wavelengths
wavelength_count = length(mat.wavelength);

% Handle different material types.  Note that a material
% can be a light source.
switch (mat.type)
    case 'ward',
		rho = num2str(mat.rho);
		alpha = num2str(mat.alpha);
		
		output = ['void plastic ',object_name];
		output = [output,char(10),'0',char(10),'0',char(10),'5 '];
            
		for i = 1:wavelength_count;
            cd(dirName);
            wavelength = int2str(mat.wavelength(i));
            spectrum = num2str(mat.spectrum(i));
            out_name = [object_name,'_',mat.type,'_',wavelength,'.rad'];
            fid = fopen(out_name,'w');
            
            new_output = [output,spectrum,' ',spectrum,' ',spectrum,' ',rho,' ',alpha,char(10)];
            count = fprintf(fid,'%s',new_output);
            fclose(fid);
            
            cd ..
		end
    case 'light',
        output = ['void light ',object_name];
        output = [output,char(10),'0',char(10),'0',char(10),'3 '];
        wavelength_count = length( mat.wavelength );
        
        for i = 1:wavelength_count; 
            cd(dirName);
            wavelength = int2str(mat.wavelength(i));
            spectrum = num2str(mat.spectrum(i));
            out_name = [object_name,'_',mat.type,'_',wavelength,'.rad'];
            fid = fopen(out_name,'w');
            
            new_output = [output,spectrum,' ',spectrum,' ',spectrum,char(10)];
            count = fprintf(fid,'%s',new_output);
            fclose(fid);
            cd ..
        end
    otherwise,
        error(sprintf('Unsupported material type %s entered\n',mat.type));
end