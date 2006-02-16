function Render_GenerateMaterialSpectrums
% function Render_GenerateMaterialSpectrums
%
% make sure to be in the right directory when you runt his function
%
% 2/12/06 dpl wrote it. UVTable part based on bx's RenSpectrumfromChrom

%define constants
S=[400 10 31];

%uv constants
uvTable = [0.185 0.419;0.226 0.508;0.242 0.450;0.153 0.489;0.192 0.445; 0.212 0.489;0.221 0.460;0.174 0.479]';
fraction = 0.5;

%load some stuff
load spd_D65
illumspectrum = SplineSrf(S_D65,spd_D65,S);
e=illumspectrum;
load B_nickerson;
Bs = SplineSrf(S_nickerson,B_nickerson(:,1:3),S);
clear S_nickerson B_nickerson
load T_xyz1931
T = T_xyz1931;
T = SplineCmf(S_xyz1931,683*T,S);
theXYZ = T*e; theLuminance = theXYZ(2);

%**(most of this taken from bx's code)
for uvValue=1:length(uvTable)
    %get uvValue
    uv=uvTable(:,uvValue);

    %get the surface Y value from taking the fraction from the illuminant
    surfaceY = fraction*theLuminance;

    XYZ = uvYToXYZ([uv ; fraction]);
    
    % calculate the surface reflectacne spectrum given illumination and uvY and
    % basis function
    s = Bs*inv(T*diag(e)*Bs)*XYZ;
    s = s/max(s);
    
    %put into table
    sur_uvTable(:,uvValue)=s;                                       
end

%save uvTable stuff
S_uvTable=S;
save uvTable sur_uvTable S_uvTable;

%do macbeth stuff
load sur_macbethPeter;
save sur_macbethPeter sur_macbethPeter S_macbethPeter;



%now do lights. for now, only the D65 powerspectrum

%modify code below to do this and save it for each value
% %load spd_D65 for light spectrum. (do this up hear because we need these
% %variables to calculate spectrums from UV values.)
% load spd_D65
% illumspectrum = SplineSrf(S_D65,spd_D65,S);
% % e=illumspectrum;
% 
% %get illumination spectrum for D65
% lightPower=lightPower;
% for i = 1:length(wls)
%     illuminantWatts(i) = illumspectrum(i)*lightPower;
%     %(not sure what's up with this line, it's from bei's code)
%     noLights(i)  = illumspectrum(i)*0; 
% end
% 
% 
% spectrum=illuminationWatts;
