function doImageProcess=Render_RenderPBRT(currentConditions,objectMaterialParams,lightMaterialParams)
% 8 junly 2006 dpl wrote it.

% assume we're in the experiment directory
% assume pbrt file is in this directory and called [sceneName].pbrt

sceneName=currentConditions.sceneName;

%read original pbrt script generated by mayapbrt
%(this must be located in the experiment directory
pbrtScript=Render_ReadInPBRTScript(currentConditions);

%create a new pbrt script for each wavelength of this condition
display('generating pbrt scripts (takes a moment)...');
fileNames=Render_GeneratePBRTScripts(currentConditions,objectMaterialParams,lightMaterialParams,pbrtScript);

%render these new pbrt scripts
display('rendering image with pbrt...');
Render_RenderPBRTScripts(currentConditions,fileNames);

%place the image processing lock so that only
%one thread does it
temporaryDirectory=currentConditions.temporaryDirectory;
fileNamePath=[temporaryDirectory '/' sceneName '_image_processing.loc'];
if ~exist(fileNamePath,'file')
	f=fopen(fileNamePath,'w');
	fclose(f);
	doImageProcess=true;
	%generate picture matrix from raw pbrt output
	display('passing image matrix back to general image processing...');
	Render_PBRTToMat(currentConditions,fileNames);
else
	doImageProcess=false;
	display('image processing done by another thread');
end