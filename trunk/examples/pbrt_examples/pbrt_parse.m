colorCodeKeys={'L' 'tex1','tex2'};
colorCodeValues=[123 .0001 .0002];

pbrtFileName='simple.pbrt';
outFileName='image_hyp.dat';
resolution=100;

%read file
f=fopen('simple.pbrt');
fileText=fread(f);

%print original
disp **original
sprintf('%s',char(fileText))

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

%print new one
disp **new
output
