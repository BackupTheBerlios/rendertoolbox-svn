%start with pbrt file
pbrtScript='simple.pbrt'

%set color values
colorCodeKeys={'tex1','tex2'};
colorCodeValues=[1 2];

pbrtFileName='simple.pbrt';
outFileName='image_hyp.dat';

%read file
f=fopen('simple.pbrt');
fileText=fread(f);

%scan for each pattern and relace as we go along
output=sprintf('%s',char(fileText));
[nil numKeys]=size(colorCodeKeys);
for i=1:numKeys
    tokenName=colorCodeKeys{i};
    exp=['("color\s' tokenName '"\s+)\[(.*?)\]'];
    %find, to verify
    [match tokens]=regexp(output,exp,'match','tokens');
    %replace
    replaceStr=['$1[' num2str(colorCodeValues(i)) ']'];
    output=regexprep(output,exp,replaceStr);
end

%save temp file
fTemp=fopen('temp.pbrt','w');
fprintf(fTemp,'%s',output);
fclose(fTemp);

%render it
cmd=['pbrt temp.pbrt'];
unix(cmd);

%read in image
resolution=200;

f=fopen('image_hyp.dat');
in=fread(f,inf,'float32');
image=reshape(in,resolution,resolution);

% imageRGB(:,:,1)=image;
% imageRGB(:,:,2)=image;
% imageRGB(:,:,3)=image;

imageRGB=ones(resolution,resolution,3);

image(imageRGB);