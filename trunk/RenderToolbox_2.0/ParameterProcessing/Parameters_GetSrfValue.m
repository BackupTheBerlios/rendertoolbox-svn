function spectrum=Parameters_GetSrfValue(S,spectrumType,spectrumNumber)
% spectrum=Parameters_GetSrfValue(S,spectrumType,spectrumNumber)
%
% GetSrfValue looks up the SRF or SPD in the lookup table specified by
% spectrumType whose number corresponds to spectrumNumber. It returns it
% splined into the wavelength sampling specified by S. Files containing the
% SPD and SRF data reside in the 'RenderDataFiles' in the RenderToolbox
% path. For SRFs, the files must be called sur_[spectrumType] and must
% contain two data elements, sur_[spectrumType], a matrix with all of the
% spectrumd data, and S_[spectrumType], an array specifying the wavelength
% samplilng in which the SRF is stored. This dataformat exactly matches the
% format in which the PsychToolbox stores SRFs and SPDs.
%
% 2/14/06 dpl wrote it.

directoryLocation=Data_FindDirectoryOnPath('RenderDataFiles');

%load the right table of spd values
load([directoryLocation '/sur_' spectrumType]);
eval(['srf=sur_' spectrumType ';']);
eval(['S_srf=S_' spectrumType ';']);

%make sure the spectrum number is in range for this spectrum
%type
if (spectrumNumber>size(srf,2))|(spectrumNumber<=0)
    error([spectrumType ' spectrum number out of range.']);
end

%now get the spectrum and spline it
spectrum=SplineSrf(S_srf,srf(:,spectrumNumber),S);