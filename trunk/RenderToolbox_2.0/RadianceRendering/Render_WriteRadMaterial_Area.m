function Render_WriteRadMaterial_Area(currentLightMaterialParams,dirName)
% Render_Render_WriteRadMaterial_Area(currentLightMaterialParams,dirName)
%
% Write a .rad material file for an area light
%
% 12/25/05 dpl wrote it. based on bx's RenStructToMaterial

numWavelengths=length(currentLightMaterialParams.wavelength);

output = ['void light ',currentLightMaterialParams.name];
output = [output,char(10),'0',char(10),'0',char(10),'3 '];

for currentWavelength=1:numWavelengths; 
   wavelength = int2str(currentLightMaterialParams.wavelength(currentWavelength));
   spectrum = num2str(currentLightMaterialParams.spectrum(currentWavelength));
   fileName = [currentLightMaterialParams.name,'_',currentLightMaterialParams.type,'_',wavelength,'.rad'];
   dir=[dirName '/' fileName];
   fid = fopen(dir,'w');
   fileOutput = [output,spectrum,' ',spectrum,' ',spectrum,char(10)];
   count = fprintf(fid,'%s',fileOutput);
   fclose(fid);
end
