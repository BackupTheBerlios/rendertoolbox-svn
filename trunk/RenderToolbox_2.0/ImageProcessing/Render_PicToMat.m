    function [picMat] = Render_PicToMat(currentConditions) 
%  [picMat] = Render_PicToMat(currentConditions) 
% 
% Change the rendered image into an image matrix.
%
% 1/25/06 dpl wrote it. based on bx's RenPicToMat

%get stuff from conditions, some for use in bei's code below
temporaryDirectory=currentConditions.temporaryDirectory;
imageDirectory=currentConditions.imageDirectory;
wavelengths=currentConditions.wls;
rif_name=currentConditions.sceneName;
currentConditionNumber=currentConditions.currentConditionNumber;

%check to make sure there is the image directory
if (~exist(imageDirectory,'dir') )
    mkdir(imageDirectory);
end

%directory names
radianceOutDirName=['radOutput_' int2str(currentConditionNumber)];
radianceOutDirPath=[temporaryDirectory '/' radianceOutDirName];


%most of the rest is bei's code:

% Get the length of the wavelengths
lim = length(wavelengths);
picMat = cell(1,lim);
for i = 1:lim
     % Define file name and create a text version of the data in the pic
     % file.
     S = ['pvalue -h ',radianceOutDirPath,'/',rif_name,'_',int2str(wavelengths(i)),'_1.pic' '>' radianceOutDirPath,'/',rif_name,'_',int2str(wavelengths(i)),'_1.txt'];
     unix(S);
     
     % Open the text file and extract the spatial resolution.
     % fprintf('processing the image (%s)\n');
     fid = fopen([radianceOutDirPath '/' rif_name,'_',int2str(wavelengths(i)),'_1.txt'],'r');
     [imageSize] = fscanf(fid,'-Y %d +X %d\n'); 
     nRows = imageSize(1); nCols = imageSize(2);
     
     % Allocate the matrix for the image data
     imageData = zeros(nRows,nCols);
     
     % Read in the whole file
     tempData = fscanf(fid, '%i %i %g %g %g',[5,nRows*nCols])';
     unix(['rm -rf *_1.txt']);
     fclose(fid);
     
     % Pack the data into a matrix
     for l = 1:nRows*nCols
         %imageData(nRows-tempData(l,1),tempData(l,2)+1) = tempData(l,3);
         imageData(nCols-tempData(l,2),tempData(l,1)+1) = tempData(l,3);
         if (tempData(l,3) ~= tempData(l,4) | tempData(l,3) ~= tempData(l,5))
             error('Unexpected failure of R=G=B in supposedly monochromatic image')
         end
     end
     
     % Stuff the matrix into the returned cell array
     picMat{i} = imageData;
end

%save picMat
eval(['save ' imageDirectory '/picMat.mat picMat']); 
