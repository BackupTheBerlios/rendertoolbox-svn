fileName='raw_image.dat';
resolution=500;

f=fopen(fileName,'r');
temp=fread(f,'float32');
imageData=reshape(temp,resolution,resolution);
imageData=rot90(imageData,-1);

imagesc(imageData);
colormap('gray');