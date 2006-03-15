function Render_MakeSimg(currentConditions)
% Render_MakeSimg(currentConditions)
%
% Turn hyperspectral picture matrix into hyperspectral S image and save to
% the image_data directory.
%
% 1/26/06 dpl wrote it. based on bx's RenMakeHypSimg



%get some stuff from conditions
sceneName=currentConditions.sceneName;
wls=currentConditions.wls;
imageDirectory=currentConditions.imageDirectory;

%load and the delete picture matrix
load([imageDirectory '/picMat.mat']);
unix(['rm ' imageDirectory '/picMat.mat']);

% Define camera and read it.
camera.manufacturer = 'n/a';
camera.name =  'RadianceCamera';
camera.numberSensors = 1;
camera.wavelengthSampling = MakeItS(wls);
camera.spectralSensitivity = zeros(1,camera.wavelengthSampling(3));
camera.unit = 'None';
camera.lens = 135;
camera.angularResolution.x = 113.4;
camera.angularResolution.y = 113.4;
camera.comments = 'Radiance Virtual Camera';

% Change to correct directory
prevDir = pwd;
cd(imageDirectory);


% Read in one picMat matrix
[height,width] = size(picMat{1});
S_images = camera.wavelengthSampling;
camera.height = height;
camera.width = width;
imageData = zeros(height,width);

% Create the hyperspectral image
outputImage.imageType = 'hyperspectral';
outputImage.imageRoot = sceneName;
outputImage.fileType = 'mat';
outputImage.cameraFile = camera;
outputImage.exposureTime = 2;
outputImage.height = height;
outputImage.width = width;
outputImage.wavelengthSampling.start = S_images(1);
outputImage.wavelengthSampling.step = S_images(2);
outputImage.wavelengthSampling.numberSamples = S_images(3);
outputImage.imageRoot = sceneName;
outputImage.imageFactors = ones(S_images(3),1);
outputImage.inputCameraDistance = 1;
outputImage.comments = 'Created by RenHypMakeSimgFromTiff';
% Write the .Simg file.
outputName = [sceneName '.Simg']; 
name = [pwd '/' outputName];
SimWriteImage(outputName,outputImage);

% Save picMat to .mat files
for i = 1:S_images(3)
    postfix = num2str(wls(i));
    imageData = picMat{i};
    eval(['save(''' sceneName postfix ''',''imageData'');']);
end

% Return to previous directory.
cd(prevDir);





