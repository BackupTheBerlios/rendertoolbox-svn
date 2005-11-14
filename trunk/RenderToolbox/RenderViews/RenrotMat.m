function [outputVect] = RenrotateMat(inputVect,rotAxis,theta)
% function [outputVect] = RotateMat(inputVect,rotAxis,theta)
% This function calculate the output vector given the rotating axis and
% input vector and rotating angel(theta). It is useful when we are
% constructing view angles of the stereograms.

% 26/0804 bx wrote it.

switch ( rotAxis )

case 'x'
rotMat = [1 0 0 ; 0 cos(theta) sin(theta);0 -sin(theta) cos(theta)];
case 'y'
rotMat = [cos(theta) 0 -sin(theta); 0 1 0 ; sin(theta) 0 cos(theta)];
case 'z'
rotMat = [cos(theta) sin(theta) 0 ; -sin(theta) cos(theta) 0; 0 0 1];

end
    

outputVect = rotMat*inputVect;
