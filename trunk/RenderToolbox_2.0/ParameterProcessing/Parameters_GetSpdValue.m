function spectrum=Parameters_GetSpdValue(S,spectrumType,spectrumNumber)
% spectrum=Parameters_GetSpdValue(S,spectrumType,spectrumNumber)
%
% 2/14/06 dpl wrote it.

%load the spd_D65 variables stored in the RenderToolbox data folder
directoryLocation=Data_FindDirectoryOnPath('RenderDataFiles');

load([directoryLocation '/spd_' spectrumType]);

eval(['spd=spd_' spectrumType ';']);
eval(['S_spd=S_' spectrumType ';']);

%make sure the spectrum number is in range for this spectrum
%type
if (spectrumNumber>size(spd,2))|(spectrumNumber<=0)
    error([spectrumType ' spectrum number out of range.']);
end

%now get the spectrum and spline it
spectrum=SplineSpd(S_spd,spd(:,spectrumNumber),S);


% wls=MakeItWls(S);
% lightPower=7;
% 
% 
% %load spd_D65 for light spectrum. (do this up hear because we need these
% %variables to calculate spectrums from UV values.)
% 
% illumspectrum = SplineSrf(S_D65,spd_D65,S);
% % e=illumspectrum;
% 
% %get illumination spectrum for D65
% lightPower=lightPower;
% for i = 1:length(wls)
%     illuminantionWatts(i) = illumspectrum(i)*lightPower;
%     %(not sure what's up with this line, it's from bei's code)
%     noLights(i)  = illumspectrum(i)*0; 
% end
% 
% 
% spectrum=illuminantionWatts;