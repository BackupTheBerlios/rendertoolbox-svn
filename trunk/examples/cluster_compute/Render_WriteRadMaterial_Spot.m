function Render_WriteRadMaterial_Spot(currentLightMaterialParams,dirName)
%Render_Render_WriteRadMaterial_Spot(currentLightMaterialParams,dirName)
%
%Take a material structure for a spot type  generated earlier in 
%RenderRoom and write it into a .rad file that radiance can read.
%
%12/25/05 dpl wrote it. based on bx's RenStructToMaterial

numWavelengths=length(currentLightMaterialParams.wavelength);

output = ['void light ',currentLightMaterialParams.name];
output = [output,char(10),'0',char(10),'0',char(10),'3 '];

for currentWavelength=1:numWavelengths; 
   wavelength = int2str(currentLightMaterialParams.wavelength(currentWavelength));
   spectrum = num2str(currentLightMaterialParams.spectrum(currentWavelength));
   width = num2str(currentLightMaterialParams.conewidth(currentWavelength));
   xv = num2str(currentLightMaterialParams.xdirection(currentWavelength));
   yv = num2str(currentLightMaterialParams.ydirection(currentWavelength));
   zv = num2str(currentLightMaterialParams.zdirection(currentWavelength));
   fileName = [currentLightMaterialParams.name,'_',currentLightMaterialParams.type,'_',wavelength,'.rad'];
   cd(dirName);
   fid = fopen(fileName,'w');
   fileOutput = [output,spectrum,' ',spectrum,' ',spectrum,' ',width,' ',xv, ' ' ,yv, ' ', zv, ' ' ,char(10)];
   count = fprintf(fid,'%s',fileOutput);
   fclose(fid);
   cd ..
end
