clear all;
cd '/work_august2005/hyperspectral_src_1.02';
disp ' ';
disp '*';
disp ' ';


%rgb stuff
fid=fopen('test_rgb.dat','r');
dan=fread(fid,'float32');
rgb(:,:,1)=reshape(dan(1:3:120000),[200 200])'; %get R components
rgb(:,:,2)=reshape(dan(2:3:120000),[200 200])'; %G
rgb(:,:,3)=reshape(dan(3:3:120000),[200 200])'; % B

max=max(dan);
image(rgb/max);
title('rgb image');
axis off;
axis square;

%xyz stuff
fid=fopen('test_xyz.dat','r');
dan2=fread(fid,'float32');
xyz(:,:,1)=reshape(dan2(1:3:120000),[200 200])'; % get X components 
xyz(:,:,2)=reshape(dan2(2:3:120000),[200 200])'; % Y
xyz(:,:,3)=reshape(dan2(3:3:120000),[200 200])'; % Z
figure;
imagesc(xyz(:,:,2));
colormap(gray);
title('Y values of xyz image');
axis off;
axis square;

%convert xyz image to LMS image

%get XYZtoLMS conversion matrix (bei)
load T_xyzJuddVos ; 
S=S_xyzJuddVos;
T_xyz = 683*T_xyzJuddVos;
load T_cones_ss2;
T_cones = SplineCmf(S_cones_ss2,T_cones_ss2,S);
M_LMSToXYZ = ((T_cones')\(T_xyz'))';
M_XYZToLMS = inv(M_LMSToXYZ);
lms=SimApplyColorTransform(M_XYZToLMS,xyz);



%test xyz
disp 'converting'
rgbNew=zeros(size(xyz));
[rows cols layers]=size(xyz);
for r=1:rows
    for c=1:cols
        input=reshape(xyz(r,c,:),[3 1]);
        output=XYZToSRGBPrimary(input);
        rgbNew(r,c,:)=reshape(output,[1 3]);
    end
end
rgbNew=abs(rgbNew); %returns non-allowed numbers (?)
t=reshape(rgbNew,[1 200*200*3 1]);
s=sort(t,'descend');
maximum=s(1);
figure;
image(rgbNew/maximum);
title('test: xyz to rgb');
axis off;
axis square;

% test lms