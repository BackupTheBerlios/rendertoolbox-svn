function Render_ProcessImage(currentConditions)

%make S image and cone images
Render_MakeSimg(currentConditions);

%convert into cone image
Render_MakeConeImage(currentConditions);

%convert into monitor image
Render_MakeMonitorImage(currentConditions);
