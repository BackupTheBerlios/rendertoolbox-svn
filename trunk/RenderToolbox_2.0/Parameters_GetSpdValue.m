function spectrum=Parameters_GetSpdValue(S,spectrumType,spectrumNumber)
% spectrum=Parameters_GetSpdValue(S,spectrumType,spectrumNumber)
%
% 2/14/06 dpl wrote it.

wls=MakeItWls(S);
lightPower=7;

%load spd_D65 for light spectrum. (do this up hear because we need these
%variables to calculate spectrums from UV values.)
load spd_D65
illumspectrum = SplineSrf(S_D65,spd_D65,S);
% e=illumspectrum;

%get illumination spectrum for D65
lightPower=lightPower;
for i = 1:length(wls)
    illuminantionWatts(i) = illumspectrum(i)*lightPower;
    %(not sure what's up with this line, it's from bei's code)
    noLights(i)  = illumspectrum(i)*0; 
end


spectrum=illuminantionWatts;