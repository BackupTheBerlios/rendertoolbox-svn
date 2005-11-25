function [Y] = RenderLMStoY(L,M,S)
%transfer T_cones to T_xyz
%Obtain vector Y from LMS coordinates

load T_cones_ss2
load T_ss2000_Y2
MM = ((T_cones_ss2')\(T_ss2000_Y2'))';

Y = MM(1).*L+ MM(2).*M + MM(3).*S;
