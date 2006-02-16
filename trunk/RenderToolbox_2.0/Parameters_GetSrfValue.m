function spectrum=Parameters_GetSrfValue(S,spectrumType,spectrumNumber)
%
%
% 2/14/06 dpl wrote it.


%now find the RenderDataFiles directory in the current matlab
%path (this code is taken from Parameters_MapObjNameToField)

%first get a cell of each item in the matlab path
fullMatlabPath=matlabpath;
currentPosition=1;
separator=pathsep;
pathCell={};
for k=1:inf
   token=strtok(fullMatlabPath(currentPosition:end), separator);
   pathCell{k}=token;
   currentPosition=currentPosition+length(token)+1;
   if isempty(strfind(fullMatlabPath(currentPosition:end),separator)) break, end;
end

%now search through the matlab path for 'RenderDataFiles'
location='';
for k=1:length(pathCell)
    if(strfind(pathCell{k},'RenderDataFiles'))
        if(~isempty(location))
            error(['RenderDataFiles found more than once in current ' ... 
                'matlab path. The Render toolbox was probably added to ' ...
                'the path incorrectly. See Render_PathChange.']);
        end
        location=pathCell{k};
    end
end

%load the right table of spd values
load([location '/sur_' spectrumType]);
eval(['surSpd=sur_' spectrumType ';']);
eval(['S_sur=S_' spectrumType ';']);

%make sure the spectrum number is in range for this spectrum
%type
if (spectrumNumber>size(surSpd,2))|(spectrumNumber<=0)
    error([spectrumType ' spectrum number out of range.']);
end

%now get the spectrum and spline it
spectrum=SplineSrf(S_sur,surSpd(:,spectrumNumber),S);