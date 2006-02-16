function Render_WriteRadMaterial_Ward(currentObjectMaterialParams,dirName)
%Render_Render_WriteRadMaterial_Ward(currentObjectMaterialParams,dirName)
%
%Take a material structure for a ward object generated earlier in 
%RenderRoom and write it into a .rad file that radiance can read.
%
%12/25/05 dpl wrote it. based on bx's RenStructToMaterial



% Get number of wavelengths
numWavelengths=length(currentObjectMaterialParams.wavelength);


rho = num2str(currentObjectMaterialParams.rho);
alpha = num2str(currentObjectMaterialParams.alpha);

output = ['void plastic ',currentObjectMaterialParams.name];
output = [output,char(10),'0',char(10),'0',char(10),'5 '];

for currentWavelength=1:numWavelengths;
    wavelength=num2str(currentObjectMaterialParams.wavelength(currentWavelength));
    spectrum = num2str(currentObjectMaterialParams.spectrum(currentWavelength));
    fileName = [currentObjectMaterialParams.name,'_',currentObjectMaterialParams.type,'_',wavelength,'.rad'];
    dir=[dirName '/' fileName];
    fid = fopen(dir,'w');
    fileOutput = [output,spectrum,' ',spectrum,' ',spectrum,' ',rho,' ',alpha,char(10)];
    count = fprintf(fid,'%s',fileOutput);
    fclose(fid);
end
