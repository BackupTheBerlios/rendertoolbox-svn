function s = RenSpectrumfromChrom(uv,e,Bs,S,fraction)

% 08/19/05 bx wrote it


%Load in color matching function
%and calculate luminance.
%Load color matching functions

load T_xyz1931
T = T_xyz1931;
T = SplineCmf(S_xyz1931,683*T,S);
theXYZ = T*e; theLuminance = theXYZ(2);

%get the surface Y value from taking the fraction from the illuminant
surfaceY = fraction*theLuminance;

XYZ = uvYToXYZ([uv ; fraction]);
% calculate the surface reflectacne spectrum given illumination and uvY and
% basis function

%s1 = SpectrumFromChrom(uv,T*diag(e),Bs,surfaceY);

s = Bs*inv(T*diag(e)*Bs)*XYZ;
s = s/max(s);

