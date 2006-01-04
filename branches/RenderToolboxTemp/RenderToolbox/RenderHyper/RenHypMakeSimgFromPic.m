function RenHypMakeSimgFromPic(imageDir,wls,rif_struct,picMat)
% function RenHypMakeSimgFromPic(imageDir,wls,rif_struct,picMat)
%
% Create a simulator file from hyperspectral data created by Radiance.
% 31 .mat files are supposed to be accessible and be radiometric images of the scene.
% Thus the factors are all set to 1.0 in the hyperimage file.
% 
% Data files are named prefixnumber.mat, and output file will be prefix.Simg
%
% 5/23/00   pxl     Wrote it.
% 9/15/00   dhb     Simplified to remove unused information.
% 2/24/04   bx,pk   Modified it.
% 3/17/04   bx      Modified it. Change it from converting Tiff to directly
%                   using .pic matrix from RenPicToMat.m 
% 3/21/04   dhb, bx Get rid of read of camera structure.


% Get the important information
imagePrefix = rif_struct.rif_name;

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
unix(['rm -rf ' imageDir]);
unix(['mkdir ' imageDir]);
cd(imageDir);


% Read in one picMat matrix
[height,width] = size(picMat{1});
S_images = camera.wavelengthSampling;
camera.height = height;
camera.width = width;
imageData = zeros(height,width);

% Create the hyperspectral image
outputImage.imageType = 'hyperspectral';
outputImage.imageRoot = imagePrefix;
outputImage.fileType = 'mat';
outputImage.cameraFile = camera;
outputImage.exposureTime = 2;
outputImage.height = height;
outputImage.width = width;
outputImage.wavelengthSampling.start = S_images(1);
outputImage.wavelengthSampling.step = S_images(2);
outputImage.wavelengthSampling.numberSamples = S_images(3);
outputImage.imageRoot = imagePrefix;
outputImage.imageFactors = ones(S_images(3),1);
outputImage.inputCameraDistance = 1;
outputImage.comments = 'Created by RenHypMakeSimgFromTiff';
% Write the .Simg file.
outputName = [imagePrefix '.Simg']; 
name = [pwd '/' outputName];
fprintf('Writing the image (%s)\n',name);
SimWriteImage(outputName,outputImage);

% Save picMat to .mat files
for i = 1:S_images(3)
    postfix = num2str(wls(i));
    %fprintf('\tReading file %s\n',[imagePrefix '_' postfix '.tif']);
    %foo = double(imread([imagePrefix '_' postfix '.tif'],'tiff'));
    %fprintf('\tWriting file %s\n',[imagePrefix postfix]);
    %max(max(abs(foo(:,:,1)-foo(:,:,2))))
    %max(max(abs(foo(:,:,1)-foo(:,:,3)))) 
    %foo = foo(:,:,1);
    %eval(['save(''' imagePrefix postfix ''',''foo'');']);
    imageData = picMat{i};
    fprintf('\tSave pic matrix %s\n',[imagePrefix '_' postfix ]);
    eval(['save(''' imagePrefix postfix ''',''imageData'');']);
end

% Return to previous directory.
cd(prevDir);





