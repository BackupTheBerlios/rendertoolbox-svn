%maps light properties to the correct fields of material params.
%**(for now, this is hardcoded into this function. we can make this more
%flexible in the future).
% 12/4/05 dpl wrote it. 

function materialParam=Parameters_MapLightPropertyToField(S,materialParam,currentLight,lightProperties,lightPower,name,value)
%**(take S out when this moves into conditions file
wls = SToWls(S);

%load spd_D65 for light spectrum. (do this up hear because we need these
%variables to calculate spectrums from UV values.)
load spd_D65
illumspectrum = SplineSrf(S_D65,spd_D65,S);
% e=illumspectrum;

%get illumination spectrum for D65
lightPower=lightPower;
for i = 1:length(wls)
    illuminantWatts(i) = illumspectrum(i)*lightPower;
    %(not sure what's up with this line, it's from bei's code)
    noLights(i)  = illumspectrum(i)*0; 
end


%now map the name,value combinations from the light properties
%file into fields in the materialParam structure
switch name
    case 'lightName'
        materialParam.name=value;
    case 'spectrumType'
              
        if strcmp(value,'D65')
            materialParam.spectrum=illuminantWatts;
        else
            display('ERROR. for now, spectrumType must be D65.');
            return;
        end
    case 'lightType'
        %**(note the lower case t in lighttype below. this is to
        %comply with bei's code for now.)
        materialParam.lighttype=value;
    otherwise
        display(['WARNING. unexpected light paramater ''' name ''' encountered. This could cause problems later on.']);
        materialParam.(name)=value;
end