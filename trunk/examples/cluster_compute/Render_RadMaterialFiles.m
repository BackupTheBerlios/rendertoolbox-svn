function dirName=Render_RadMaterialFiles(objectMaterialParams,lightMaterialParams,currentConditions,currentConditionNumber)
%makes material files for radiance based on parameters that were read above
%in RenderRoom. saves them in materials_[condition#] in the experiment
%directory.
%
%12/25/05 dpl wrote it. based on bx's RenStructToMaterial and RenCatRad

%some stats
numObjects=length(objectMaterialParams);
numLights=length(lightMaterialParams);


%see if materials folder exists, if not, make it.
dirName = sprintf('%s_%d','materials',currentConditionNumber);
if (~exist(dirName,'dir') )
    mkdir(dirName);
end
cd(dirName); unix('rm *.rad'); cd ..;

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
            %**(not tested because I don't have an experiment with a spot
            %light source.)
            name=lightMaterialParams(currentLight).name;
            RenStructToMaterial(lightMaterialParams(currentLight),name,dirName);
        otherwise
            error('unsupported light type. only support area and spot for right now.');
    end
end


%cat files together
%**(taken directly from bx's RenCatRad)
numWavelengths=length(currentConditions.wls);
for i = 1:numWavelengths;
        currentWavelength = int2str(currentConditions.wls(i));
        cd(dirName);
        filename = 'obj_material';
        out_name = [filename,'_',currentWavelength,'.rad'];
        fid = fopen(out_name,'w');
        [a,b] = unix(['cat *_',currentWavelength,'.rad']);
        new_output = b;
        count = fprintf(fid,'%s',new_output);
        fclose(fid);
        cd ..
end

