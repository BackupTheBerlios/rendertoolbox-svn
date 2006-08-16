function Render_WriteRadMaterial_Point(currentLightMaterialParams,dirName)
%Render_Render_WriteRadMaterial_Point(currentLightMaterialParams,dirName)

lightPower=1e8;

numWavelengths=length(currentLightMaterialParams.wavelength);

output = ['void light ',currentLightMaterialParams.name];
output = [output,char(10),'0',char(10),'0',char(10),'3 '];

for currentWavelength=1:numWavelengths; 
   wavelength = int2str(currentLightMaterialParams.wavelength(currentWavelength));
   spectrum = num2str(lightPower*currentLightMaterialParams.spectrum(currentWavelength));

   fileName = [currentLightMaterialParams.name,'_',currentLightMaterialParams.type,'_',wavelength,'.rad'];
   dir=[dirName '/' fileName];
   fid = fopen(dir,'w');
   fileOutput = [output,spectrum,' ',spectrum,' ',spectrum,char(10)];
   count = fprintf(fid,'%s',fileOutput);
   fclose(fid);
end
