% RenParamGetPropValue
%retrieves the value of the current property of the current object, and
%links this to the current conditions if necessary.
%
%will put this into rendertoolbox soon.
%
%12/4/05 dpl wrote it.
function [name value]=Parameters_GetPropVal(currentObjectProperty,currentObject,objectProperties,currentConditions)

%get stats about objects
%**(unnecessary to do this each time the function is called, but causes
%only a trivial expense in computing time)
objectPropertyNames=fieldnames(objectProperties(1));
numObjectPropertyNames=length(objectPropertyNames);

%get stats about conditions
conditionNames=fieldnames(currentConditions);
numConditionNames=length(conditionNames);

%get the name and value of the property, matching it with a value
%from the condition file if specified
tmp=objectPropertyNames(currentObjectProperty); name=tmp{1};
value=objectProperties(currentObject).(name);
%if value starts with 'c_', look up the corresponding
%value in the current condition
if (length(value)>2)&(value(1:2)=='c_')
    currentConditionName=value(3:end);
    %first check that there is such a condition
    if ~isfield(currentConditions,currentConditionName)
        display('ERROR. object file references non existant field in conditions file.');
        return;
    end
    %now get the value from the current condition
    value=currentConditions.(currentConditionName);
end