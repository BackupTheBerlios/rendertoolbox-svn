function Render_RawPBRTToPicMatrix(currentConditions,fileNames)

%get stuff from conditions, some for use in bei's code below
wavelengths=currentConditions.wls;
resolution=currentConditions.imageRes;
numWavelengths=length(wavelengths);
imageDirectory=currentConditions.imageDirectory;

temporaryDirectory=currentConditions.temporaryDirectory;
pbrtOutputDirectory=currentConditions.pbrtOutputDirectory;
loadDirectory = [temporaryDirectory '/' pbrtOutputDirectory];

%make image directory if there isn't one
if ~exist(imageDirectory,'dir')
    mkdir(imageDirectory);
end

fileNamePath=[imageDirectory '/picMat.mat'];
if ~exist(fileNamePath,'file')
    %get files and put into a format for the rest of the rendering toolbox to
    %turn into a monitor image
    for currentWavelength=1:numWavelengths
        currentFileName=fileNames{currentWavelength};
        f=fopen([loadDirectory '/' currentFileName '.dat'],'r');
        temp=fread(f,'float32');
        imageData=reshape(temp,resolution,resolution);
        imageData=rot90(imageData,-1);
        fclose(f);
        picMat{currentWavelength}=imageData;
    end

    cmd=['save ' imageDirectory '/picMat.mat picMat'];
    eval(cmd);
end