function [picMat] = RenPicToMat(wavelengths, rif_struct) 
% function [picMat] = RenPicToMat(wavelengths, rifStruct) 
% 
% Open .pic files and use Radiance commend pvalue to get
% pixel values of each .pic file and save each .pic file into a matrix.
% This rountine is to replace RenMake_tiff to solve the problem of 
% losing information when we are converting .pic to .tiff files.
%
% The purpose is to use the data matrix to directly generate hyperspectral
% images.
%
% 3/15/04   bx  Wrote it.
% 4/14/04   bx  debugged it. now the image is in the right spatial layout.
% it used to be rotated 90.

% Get the length of the wavelengths
lim = length(wavelengths);
% wavelengths = wls;
% rif_struct =rs;
% lim =1 ;
% Loop over all wavelengths.
picMat = cell(1,lim);
for i = 1:lim
     % Define file name and create a text version of the data in the pic
     % file.
     S = ['pvalue -h ',rif_struct.rif_name,'_',int2str(wavelengths(i)),'_1.pic' '>' rif_struct.rif_name,'_',int2str(wavelengths(i)),'_1.txt'];
     unix(S);
     
     % Open the text file and extract the spatial resolution.
     % fprintf('processing the image (%s)\n');
     fid = fopen([rif_struct.rif_name,'_',int2str(wavelengths(i)),'_1.txt'],'r');
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


