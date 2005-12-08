% new batchRender file
% 11/27/05 dpl wrote it. based on bx's batchRender

%assumptions about conditions and object files:
% *first field in each condition is sceneName
% *in objectProperties, if a c_ preceeds the value it's value is looked up
%in conditions. the script searches for a field name corresponding to the
%value it finds in objectProperties, not including the preceeding 'c_'
% *if a value is not a string, it assumes its a number, and converts it into
%a string

clear all;
display(['running at ' datestr(now)]);

%set which experiment we're doing
experimentName='singleSphere_new';

%read from object file
cd(experimentName);
objectProperties=ReadStructsFromText('objectProperties.txt');

%read from lights file
lightProperties=ReadStructsFromText('lightProperties.txt');
   
%read from conditions file
conditions=ReadStructsFromText('conditions.txt');
numConditions=length(conditions);

%render the scene
for currentCondition=1:numConditions
    success=0;
    RenderRoom(currentCondition,conditions(currentCondition),objectProperties, lightProperties);
    success=1;
end
