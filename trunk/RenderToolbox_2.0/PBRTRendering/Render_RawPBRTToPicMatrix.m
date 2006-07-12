function Render_RawPBRTToPicMatrix(currentConditions,fileNames)

%get stuff from conditions, some for use in bei's code below
wavelengths=currentConditions.wls;
resolution=currentConditions.imageRes;
numWavelengths=length(wavelengths);
imageDirectory=currentConditions.imageDirectory;

%get files and put into a format for the rest of the rendering toolbox to
%turn into a monitor image
for currentWavelength=1:numWavelengths
    currentFileName=fileNames{currentWavelength};
    display(['   getting image for ' currentFileName]);
    f=fopen([currentFileName '.dat'],'r');
    temp=fread(f,'float32');
    imageData=reshape(temp,resolution,resolution);
    fclose(f);
    picMat{currentWavelength}=imageData;
end

cmd=['save ' imageDirectory '/picMat.mat picMat'];
eval(cmd);     