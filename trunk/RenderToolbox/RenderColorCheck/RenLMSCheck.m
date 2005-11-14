%Script RenLMScheck
%Find out position coordinates of test patches in photoshop
%Passing in the coordiates and calculate the cooresponding LMS values
%in the LMS image  generated from the rendered hyperspectral image.
% Save the data in a file
%
% 3/28/04  bx, pk wrote it

clear;
predir = pwd;
image_dir = 'image_data';
cd(image_dir)
load flatRoom01LMSImage
LMScenter =  flatRoom01LMSImage(275,275,:);
LMSbg    = flatRoom01LMSImage(307,314,:);
LMStop   = flatRoom01LMSImage(274,196,:);
LMSbot   = flatRoom01LMSImage(274,363,:);
LMSleft  = flatRoom01LMSImage(191,276,:);
LMSright   = flatRoom01LMSImage(356,274,:);

LMSbot = [LMSbot(:,:,1), LMSbot(:,:,2),LMSbot(:,:,3)];
LMScenter = [LMScenter(:,:,1), LMScenter(:,:,2),LMScenter(:,:,3)];
LMSleft = [LMSleft(:,:,1), LMSleft(:,:,2),LMSleft(:,:,3)];
LMSright = [LMSright(:,:,1), LMSright(:,:,2),LMSright(:,:,3)];
LMStop  = [LMStop(:,:,1), LMStop(:,:,2),LMStop(:,:,3)];
LMSbg  = [LMSbg(:,:,1), LMSbg(:,:,2),LMSbg(:,:,3)];

LMScoords = {LMSbot, LMScenter, LMSleft, LMSright, LMStop, LMSbg};

save LMScoords LMScoords

cd(predir);

