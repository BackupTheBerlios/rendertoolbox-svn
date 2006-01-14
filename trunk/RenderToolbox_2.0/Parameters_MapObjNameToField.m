% Parameters_MapObjNameToField
%
%will put this into rendertoolbox
%
% 12/4/05 dpl wrote it.

function materialParam=Parameters_MapObjNameToField(S,materialParam,currentObject,objectProperties,name,value)


%process UV spectrum table
%**(for now, uvTable and fraction are hardcoded)
load B_nickerson;
Bs = SplineSrf(S_nickerson,B_nickerson(:,1:3),S);
clear S_nickerson B_nickerson
uvTable = [0.185 0.419;0.226 0.508;0.242 0.450;0.153 0.489;0.192 0.445; 0.212 0.489;0.221 0.460;0.174 0.479]';
fraction = 0.5;

%load MCC surface list
load sur_macbethPeter;
surfaceList = sur_macbethPeter;

%load spd_D65 for light spectrum. (do this up hear because we need these
%variables to calculate spectrums from UV values.)
load spd_D65
illumspectrum = SplineSrf(S_D65,spd_D65,S);
e=illumspectrum;




%**(this conversion is hardcoded for now in order
%to shield the user from extra complication. if we want, we can
%require the user to supply another file that maps the names of object
%properties to the names expected in this program and by radiance)

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
        %if spectrumNumber is in the name of the field, we must look for
        %the spectrumType for this object so that we can lookup the
        %spectrum in the correct reference table
        if ~isempty(strfind(name,'spectrumNumber'))
            %check to see if this field exists
            if ~isfield(objectProperties(currentObject),'spectrumType');
                display('ERROR. current object specified a spectrumNumber but does not specify spectrumType.');
                return;
            end
            switch objectProperties(currentObject).spectrumType
                case 'uvTable'
                    
                    
                    materialParam.spectrum=RenSpectrumfromChrom(uvTable(:,value),e,Bs,S,fraction);
                case 'surfaceList'
                    %(not sure why we don't have to spline this into
                    %the right wavelengths. must happen later.)
                    materialParam.spectrum=surfaceList(:,value);
                otherwise
                    display('ERROR. spectrumType must be either uvTable or surfaceList');
                    return;
            end
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