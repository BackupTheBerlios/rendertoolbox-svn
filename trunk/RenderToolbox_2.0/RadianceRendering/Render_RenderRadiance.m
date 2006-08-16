function  doImageProcess=Render_RenderRadiance(currentConditions,objectMaterialParams,lightMaterialParams,rendererParams)
% Render_RenderRadiance(currentConditions,objectMaterialParams,lightMaterialParams, ...
%     rendererParams)
%
% Render_RenderRadiance prepares files for the radiance renderer according
% to the properties passed in its parameters and then renders the scene.
% These parameters are prepared by batchRender. The current MATLAB working
% directory must be the experiment directory.
%
% 11/27/05 dpl wrote it. based on bx's RenderRoom
% 12/24/05 dpl modifying later portions to clarfiy the code and make it more
%               general
% 1/11/06 dpl put Render_ProcessMaterialProps into batchRender
% 3/2/06 dpl removed some comments and changed name

%if this is the first thread to do process objects into .rad and .rif files,
%do it now. if not, either skip this step or wait for it to be done
temporaryDirectory=currentConditions.temporaryDirectory;
sceneName=currentConditions.sceneName;
workingLockFileNamePath=[temporaryDirectory '/' sceneName '_matProcessing.loc'];
finishedLockFileNamePath=[temporaryDirectory '/' sceneName '_matProcessingFinished.loc'];

if ~exist(workingLockFileNamePath,'file') && ~exist(finishedLockFileNamePath,'file')
	f=fopen(workingLockFileNamePath,'w');
	fclose(f);
	%do the processing...
	%convert objects and lights into radiance files
	display('convert objects and lights into radiance files...');
	Render_SceneObjectsToRad(objectMaterialParams,lightMaterialParams,currentConditions);
	
	%now save material structures as rad files
	display('save radiance material files...');
	Render_RadMaterialFiles(objectMaterialParams,lightMaterialParams,currentConditions);
	
	%make and write rif files for the whole scene
	display('generating and writing rif files...');
	Render_MakeWriteRifFiles(objectMaterialParams,lightMaterialParams,currentConditions,rendererParams);
	f=fopen(finishedLockFileNamePath,'w');
	fclose(f);
	unix(['rm ' workingLockFileNamePath]);
elseif exist(workingLockFileNamePath,'file')
	fprintf('waiting for another thread to process files... ');
	%wait until the other thread is done processing
	time=clock;
	Render_WaitForFile(finishedLockFileNamePath);
	waited=clock-time;
	fprintf(['waited ' num2str(waited(6)) ' seconds. ']);
	fprintf('done.\n');
	pause(5);
elseif exist(finishedLockFileNamePath,'file')
	%in this case, processing has already been done, so do the rendering
	display('file processing done by another thread.');
else
	%error
	error('file processing lock files');
end

%render the scene
display('render the scene...');
Render_RenderScene(currentConditions);

%turn pic into mat
%first lock image processing to this thread
fileNamePath=[temporaryDirectory '/' sceneName '_image_processing.loc'];
if ~exist(fileNamePath,'file')
	display('passing image matrix back to general image processing...');
	f=fopen(fileNamePath,'w');
	fclose(f);
	Render_RadiancePicToMat(currentConditions);
	doImageProcess=true;
else
	%it's being done by someone else
	display('image processing done by another thread.');
	doImageProcess=false;
end