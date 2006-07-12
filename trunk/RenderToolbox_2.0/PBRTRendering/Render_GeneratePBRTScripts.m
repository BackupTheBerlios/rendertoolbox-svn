function fileNames=Render_GeneratePBRTScripts(currentConditions,objectMaterialParams,lightMaterialParams,pbrtScript)

%get stuff from conditions, some for use in bei's code below
wavelengths=currentConditions.wls;
sceneName=currentConditions.sceneName;
currentConditionNumber=currentConditions.currentConditionNumber;

%get spectrum for each object
numWavelengths=length(wavelengths);
numObjects=length(objectMaterialParams);
objectNames={objectMaterialParams.name};
objectSpectrum={objectMaterialParams.spectrum};


%temp
%tokens to for
objectNames={'tex1','tex2'};
objectSpectrum={objectMaterialParams([1 4]).spectrum};
numObjects=2;

%initialize fileNames cell
fileNames='';

%step through each wavelength and make a new version of the pbrt file
display('   generating pbrt scripts...');
for currentWavelength=1:numWavelengths
    newOutput=sprintf('%s',char(pbrtScript));
    %%
    %%add real processing code
    %%

    %temp test code
    for currentObject=1:numObjects
        token=objectNames{currentObject};
        replacementSpectrum=num2str(objectSpectrum{currentObject}(currentWavelength));
        exp=['("color\s' token '"\s+)\[(.*?)\]'];
        replaceStr=['$1[' replacementSpectrum ']'];
        newOutput=regexprep(newOutput,exp,replaceStr);
    end



    %%
    %%end real processing code
    %%

    fileName=[sceneName '_' num2str(currentConditionNumber) '_' ...
        num2str(wavelengths(currentWavelength))];
    fileNames{currentWavelength}=fileName;
    f=fopen([fileName '.pbrt'],'wt');
    fwrite(f,newOutput);
    fclose(f);
end