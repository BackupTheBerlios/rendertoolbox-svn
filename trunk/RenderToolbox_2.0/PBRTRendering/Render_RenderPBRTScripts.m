function Render_RenderPBRTScripts(currentConditions,fileNames)

%get stuff from conditions, some for use in bei's code below
wavelengths=currentConditions.wls;

%get spectrum for each object
numWavelengths=length(wavelengths);


%now render files
%%debug
rerender=true;
if rerender
    display('   rendering with pbrt...');
    for currentWavelength=1:numWavelengths
        currentFileName=fileNames{currentWavelength};
        cmd=['pbrt ' currentFileName '.dat ' currentFileName '.pbrt' ];
        unix(cmd);
    end
end %rerender