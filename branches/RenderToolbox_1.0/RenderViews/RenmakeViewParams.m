function viewParams = RenMakeViewParams(imageRes,eyeSep,dMonitor,nMonitorcmPerPixel,viewhight)
% function viewParams =
% RenMakeViewParams(imageRes,eyeSep,dMonitor,nMonitorcmPerPixel)
% This function calculate the view parameters needed for Radiance to render
% a scene for monitor display. 
%
% It calculates the projection angle degreePerPixel for the
% a certian monitor from the image resolution, distance from eye to a
% Monitor and how many centimers per pixel of that monitor. 
% It also calculate the vectors of left and right eye with certain eye
% seperation. 
% It saves these parameters as a file that could be used to render
% stereograms. 
% imageRes = 800;               % Image resolution in pixels
% eyeSep = 6.3;                 % eye seperation in cm
% nMonitorcmPerPixel = 0.035;   % cm/pixel for Screen 1
% dMonitor = 76.4;              % distance from eye to the monitors
%
%
%
% 08/26/04  bx wrote it
% 09/01/04  bx fixed a few bugs. 

% Theses info is related to the scene;
% The convention is that the image is in the x-y plane; 
%viewhight = 17.45; 
inputNormalVect = [ 0 0 -1]';
rotateAxis = 'y'; 

% Calculate the degreePerPixel of the view angle
projectionLength = nMonitorcmPerPixel*imageRes; 
degreePerPixel = (atan(projectionLength/2/dMonitor)*180)/pi;

% theta should always NOT in deg.
theta = atan(eyeSep/2/dMonitor);


leftEye  = RotateMat(inputNormalVect,rotateAxis,theta);
rightEye = RotateMat(inputNormalVect,rotateAxis,-theta);

% define view positions for the two eyes; suppose the center of fixation is
% [ 0 0 0]'

viewParamsLeft.vpx = num2str(-eyeSep/2);  % the x position is half of the eye seperation 
viewParamsLeft.vpy = num2str(viewhight);  % the y position is the height of the camera; 
viewParamsLeft.vpz = num2str(dMonitor);   % the z position is the distance from eyes to the Monotir
viewParamsRight.vpx = num2str(eyeSep/2);  % the x position is half of the eye seperation 
viewParamsRight.vpy = num2str(viewhight); % the y position is the height of the camera; 
viewParamsRight.vpz = num2str(dMonitor);  % the z position is the distance from eyes to the Monotir

% define view direction;
viewParamsLeft.vdx =  num2str(leftEye(1));
viewParamsLeft.vdy =  num2str(leftEye(2));
viewParamsLeft.vdz =  num2str(leftEye(3));
viewParamsRight.vdx = num2str(rightEye(1));
viewParamsRight.vdy = num2str(rightEye(2));
viewParamsRight.vdz = num2str(rightEye(3));

% define view up
viewParams.vux = num2str(0);
viewParams.vuy = num2str(1);
viewParams.vuz = num2str(0);


% define and save viewfile parameters
viewParams.vv = num2str(degreePerPixel*2);
viewParams.vh = num2str(degreePerPixel*2);


% Write the calculated view parameters into files
% write the left view file for the left eye (camera)
fid = fopen( 'view_left_01.vf', 'w');
S = '';
S = [S,'rview ',' ', '-vtv',' ','-vp',' ', viewParamsLeft.vpx, ' ', viewParamsLeft.vpy,' ',viewParamsLeft.vpz,' '];
S = [S, '-vd',' ',viewParamsLeft.vdx,' ',viewParamsLeft.vdy, ' ', viewParamsLeft.vdz, ' '];
S = [S, '-vu',' ',viewParams.vux, ' ', viewParams.vuy, ' ', viewParams.vuz, ' '];
S = [S, '-vh',' ',viewParams.vh, ' ', '-vv', ' ', viewParams.vv, ' ']; 
count = fprintf(fid,'%s',S);
fclose(fid);


clear S;
clear count; 

fid = fopen( 'view_right_01.vf', 'wb');
S = '';
S = [S,'rview ',' ', '-vtv',' ','-vp', ' ', viewParamsRight.vpx, ' ', viewParamsRight.vpy,' ',viewParamsRight.vpz,' '];
S = [S, '-vd',' ',viewParamsRight.vdx,' ',viewParamsRight.vdy, ' ', viewParamsRight.vdz, ' '];
S = [S, '-vu',' ',viewParams.vux, ' ', viewParams.vuy, ' ', viewParams.vuz, ' '];
S = [S, '-vh',' ',viewParams.vh, ' ', '-vv',' ',viewParams.vv, ' ']; 
count = fprintf(fid,'%s',S);
fclose(fid);



