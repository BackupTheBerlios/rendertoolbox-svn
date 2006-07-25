function Render_RenderPBRTScripts(currentConditions,fileNames)

%get stuff from conditions
temporaryDirectory=currentConditions.temporaryDirectory;
pbrtScriptsDirectory=currentConditions.pbrtScriptsDirectory;
pbrtOutputDirectory=currentConditions.pbrtOutputDirectory;

loadDirectory = [temporaryDirectory '/' pbrtScriptsDirectory];
saveDirectory = [temporaryDirectory '/' pbrtOutputDirectory];

%make the save directory if it doesn't exist
if ~exist(saveDirectory,'dir')
    mkdir(saveDirectory);
end

%get stuff from conditions, some for use in bei's code below
wavelengths=currentConditions.wls;

%get spectrum for each object
numWavelengths=length(wavelengths);

for currentWavelength=1:numWavelengths
    currentFileName=fileNames{currentWavelength};
    loadFileNamePath=[loadDirectory '/' currentFileName '.pbrt'];
    loadLockFileNamePath=[loadDirectory '/' currentFileName '.loc'];
    saveFileNamePath=[saveDirectory '/' currentFileName '.dat'];
    lockFileNamePath=[saveDirectory '/' currentFileName '.loc'];
    
    if ~exist(saveFileNamePath,'file') && ~exist(lockFileNamePath,'file')
    	%make the lock file so other threads don't attempt to process this wavelength
        fprintf(['   wavelength ' num2str(wavelengths(currentWavelength)) '...   ']);
    	f=fopen(lockFileNamePath,'w');
    	fclose(f);
    	%make sure the pbrt script is finished, if not wait until it is
    	if ~exist(loadFileNamePath,'file') && exist(loadLockFileNamePath,'file')
    		fprintf(' ...waiting for file... ');
    		while 1
    			pause(.1);
    			if exist(loadFileNamePath,'file')
    				break;
    			end
    		end
    	end
    	%now carry on    	
        cmd=['pbrt ' saveFileNamePath ' ' loadFileNamePath];
        [status result]=unix(cmd);
        fprintf('done.\n');
        unix(['rm ' lockFileNamePath]);
    else
        fprintf(['   wavelength ' num2str(wavelengths(currentWavelength)) ' already done.\n']);  	
    end
end