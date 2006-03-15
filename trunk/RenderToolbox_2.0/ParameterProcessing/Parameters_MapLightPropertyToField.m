function materialParam=Parameters_MapLightPropertyToField(S,materialParam,currentLight,lightProperties,lightPower,name,value)
% materialParam=Parameters_MapLightPropertyToField(S, ...
%       materialParam,currentLight,lightProperties,lightPower,name,value)
%
% MapLightProperty maps the name and value of a light property to the
% correct field of the materialParam struct for that light. If it needs to
% lookup an SPD in a table, it calls GetSpdValue to perform the search.
%
% 12/4/05 dpl wrote it.

%**(take S out when this moves into conditions file
wls = SToWls(S);


%now map the name,value combinations from the light properties
%file into fields in the materialParam structure
switch name
    case 'lightName'
        materialParam.name=value;
    case 'spectrumType'
        %see if there is a spectrum number stored. if not, the default
        %value is 1
        if ~isfield(lightProperties(currentLight),'spectrumNumber');
            spectrumNumber=1;
        else
            spectrumNumber=lightProperties(currentLight).spectrumNumber;
        end
        %now look up this particular spectrum
        materialParam.spectrum=Parameters_GetSpdValue(S,value,spectrumNumber);
    case 'lightType'
        %**(note the lower case t in lighttype below. this is to
        %comply with bei's code for now.)
        materialParam.lighttype=value;
    otherwise
        display(['WARNING. unexpected light paramater ''' name ''' encountered. This could cause problems later on.']);
        materialParam.(name)=value;
end