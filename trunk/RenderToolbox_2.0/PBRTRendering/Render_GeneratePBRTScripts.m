function fileNames=Render_GeneratePBRTScripts(currentConditions,objectMaterialParams,lightMaterialParams,pbrtScript)

%get stuff from conditions
temporaryDirectory=currentConditions.temporaryDirectory;
pbrtScriptsDirectory=currentConditions.pbrtScriptsDirectory;
wavelengths=currentConditions.wls;
sceneName=currentConditions.sceneName;
currentConditionNumber=currentConditions.currentConditionNumber;
resolution=currentConditions.imageRes;

%get spectrum for each object and lights
numWavelengths=length(wavelengths);

numObjects=length(objectMaterialParams);
objectNames={objectMaterialParams.name};
objectSpectrum={objectMaterialParams.spectrum};

numLights=length(lightMaterialParams);
lightNames={lightMaterialParams.name};
lightSpectrum={lightMaterialParams.spectrum};

%replace scripts directory
saveDirectory = [temporaryDirectory '/' pbrtScriptsDirectory];
unix(['rm -rf ' saveDirectory]);
unix(['mkdir ' saveDirectory]);


%initialize fileNames cell
fileNames='';

%step through each wavelength and make a new version of the pbrt file
for currentWavelength=1:numWavelengths
    fileName=[sceneName '_' num2str(currentConditionNumber) '_' ...
        num2str(wavelengths(currentWavelength))];
    fileNames{currentWavelength}=fileName;
    fprintf(['   ' fileName '.pbrt...  ']);
    
    
    newOutput=sprintf('%s',char(pbrtScript));
    
    %set the resolution
    resolutionStr=num2str(resolution);
    exp='(xresolution"\s+)\[(.*?)\]';
    replaceStr=['$1[' resolutionStr ']'];
    newOutput=regexprep(newOutput,exp,replaceStr);
    exp='(yresolution"\s+)\[(.*?)\]';
    newOutput=regexprep(newOutput,exp,replaceStr);
    
    %do objects
    for currentObject=1:numObjects
        objectName=objectNames{currentObject};
        replacementSpectrum=num2str(objectSpectrum{currentObject}(currentWavelength));
        exp=['(#ShapeName:' objectName '_objectShape\nAttributeBegin.*?value"\s+)\[(.*?)\]'];
        replaceStr=['$1[' replacementSpectrum ']'];
        newOutput=regexprep(newOutput,exp,replaceStr);
    end
    
    %do lights
    for currentLight=1:numLights
        lightName=lightNames{currentLight};
        replacementSpectrum=num2str(lightSpectrum{currentLight}(currentWavelength));
        exp=['(#PointLightName:' lightName '\nTransformBegin.*?color I"\s+)\[(.*?)\]'];
        replaceStr=['$1[' replacementSpectrum ']'];
        newOutput=regexprep(newOutput,exp,replaceStr);
    end

    %save it
    f=fopen([saveDirectory '/' fileName '.pbrt'],'wt');
    fwrite(f,newOutput);
    fclose(f);
    
    fprintf('done.\n');
end