function [name value]=Parameters_LinkParamsConditions(currentObjectProperty,currentObject,objectProperties,currentConditions)
% [name value]=Parameters_LinkParamsConditions(currentObjectProperty, ...
%             currentObject,objectProperties,currentConditions)
%
% LinkParamsConditions looks up the value of a light or object property in
% currentConditions if the property is condition dependent. It does not,
% however, look up specific SPDs or SRFs, only the values stored directly
% in currentConditions. Use LookUpFieldValues or MapLightPropertyToField to
% do this function. Refer to the documentation in this distribution for a
% full description of parameter and conditions files.
%
% 12/4/05 dpl wrote it.


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