function Render_ProcessImageSeparate()

currentConditions.sceneName='con_pbrt';
currentConditions.wls=400;
currentConditions.imageDirectory=pwd;


%make S image and cone images
Render_MakeSimg(currentConditions);

%convert into cone image
Render_MakeConeImage(currentConditions);

%convert into monitor image
Render_MakeMonitorImage(currentConditions);
