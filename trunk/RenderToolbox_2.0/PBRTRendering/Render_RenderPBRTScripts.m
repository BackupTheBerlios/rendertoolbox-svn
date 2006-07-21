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
    saveFileNamePath=[saveDirectory '/' currentFileName '.dat'];
    
    if ~exist(saveFileNamePath,'file')
        cmd=['pbrt ' saveFileNamePath ' ' loadFileNamePath];
        fprintf(['   wavelength ' num2str(wavelengths(currentWavelength)) '...   ']);
        [status result]=unix(cmd);
        fprintf('done.\n');
    elseif
        fprintf(['   wavelength ' num2str(wavelengths(currentWavelength)) ' already done.']);  	
    end
end