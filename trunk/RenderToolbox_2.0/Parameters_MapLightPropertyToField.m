%maps light properties to the correct fields of material params.
%**(for now, this is hardcoded into this function. we can make this more
%flexible in the future).
% 12/4/05 dpl wrote it. 

function materialParam=Parameters_MapLightPropertyToField(S,materialParam,currentLight,lightProperties,lightPower,name,value)
%**(take S out when this moves into conditions file
wls = SToWls(S);


%now map the name,value combinations from the light properties
%file into fields in the materialParam structure
switch name
    case 'lightName'
        materialParam.name=value;
    case 'spectrumType'
        %**(fix this function)
        materialParam.spectrum=Parameters_GetSpdValue(S);
    case 'lightType'
        %**(note the lower case t in lighttype below. this is to
        %comply with bei's code for now.)
        materialParam.lighttype=value;
    otherwise
        display(['WARNING. unexpected light paramater ''' name ''' encountered. This could cause problems later on.']);
        materialParam.(name)=value;
end