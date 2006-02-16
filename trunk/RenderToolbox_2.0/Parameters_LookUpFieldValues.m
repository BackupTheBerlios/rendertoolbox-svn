function materialParam=Parameters_LookUpFieldValues(S,materialParam,currentObject,objectProperties,name,value)
% Parameters_LookUpFieldValues
%
% 12/4/05 dpl wrote it.
% 2/14/06 dpl changed it to work with RenderDataFiles changed name from
% Parameters_MapObjNameToField to Parameters_LookUpFieldValues

switch(name)
    case 'glossiness'
        materialParam.rho=value;
    case 'roughness'
        materialParam.alpha=value;
    case 'objectName'
        materialParam.name=value;    
    case 'objectType'
        materialParam.type=value;
    case 'spectrumType'
        %do nothing because this is used only to look up
        %spectrum number
    otherwise
        %see if it's a spectrum number
        if ~isempty(strfind(name,'spectrumNumber'))
            %check to see if this field exists
            if ~isfield(objectProperties(currentObject),'spectrumType');
                error(['Current object ' materialParam.name ' specified a spectrumNumber but does not specify spectrumType.']);
                return;
            end
            %get spd for this spectrum
            materialParam.spectrum= ... 
                Parameters_GetSrfValue(S,objectProperties(currentObject).spectrumType,value);
        else
            %we have encountered a property other than spectrum,
            %glossiness or roughness. issue a warning, but assume 
            %that the user knows
            %what radiance expects, and that s/he has supplied an
            %appropriate name for the property.
            display('WARNING. current object specifies an unexpected property. This could cause errors.');
            materialParam.(name)=value;
        end %end if spectrum number
end %end mapping switch