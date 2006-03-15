function Render_RadMaterialFiles(objectMaterialParams,lightMaterialParams,currentConditions)
% Render_RadMaterialFiles(objectMaterialParams,lightMaterialParams, ...
%           currentConditions)
%
% Creates material .rad files based on parameters passed from
% RenderRadiance and stores them in
% [temporary_directory]/materials_[condition#].
%
% 12/25/05 dpl wrote it. based on bx's RenStructToMaterial and RenCatRad
% 1/19/06  dpl changed to use temporaryDirectory

%get some stuff from conditions
currentConditionNumber=currentConditions.currentConditionNumber;
objectDirectory=currentConditions.objectDirectory;
temporaryDirectory=currentConditions.temporaryDirectory;

%some stats
numObjects=length(objectMaterialParams);
numLights=length(lightMaterialParams);


%see if materials folder exists, if not, make it.
dirName = [temporaryDirectory '/' 'materials_' num2str(currentConditionNumber)];
if (~exist(dirName,'dir') )
    mkdir(dirName);
end

%do objects
for currentObject=1:numObjects
    switch objectMaterialParams(currentObject).type
        case 'ward'
            Render_WriteRadMaterial_Ward(objectMaterialParams(currentObject),dirName);
        otherwise
            error('unsupported object type. only supports ward right now.');
    end
end

%do lights
for currentLight=1:numLights
    switch(lightMaterialParams(currentLight).lighttype)
        case 'area'
            Render_WriteRadMaterial_Area(lightMaterialParams(currentLight),dirName);
        case 'spot'
            Render_WriteRadMaterial_Spot(lightMaterialParams(currentLight),dirName);
        otherwise
            error('unsupported light type. only support area and spot for right now.');
    end
end


%cat files together
%**(taken directly from bx's RenCatRad)
%**(now modified to use temp directory)
numWavelengths=length(currentConditions.wls);
for i = 1:numWavelengths;
        currentWavelength = int2str(currentConditions.wls(i));
        filename = 'obj_material';
        out_name = [dirName '/' filename,'_',currentWavelength,'.rad']; %dpl: modified this line to include temp dir
        fid = fopen(out_name,'w');
        [a,b] = unix(['cat ' dirName '/' '*_',currentWavelength,'.rad']);
        new_output = b;
        count = fprintf(fid,'%s',new_output);
        fclose(fid);
end

