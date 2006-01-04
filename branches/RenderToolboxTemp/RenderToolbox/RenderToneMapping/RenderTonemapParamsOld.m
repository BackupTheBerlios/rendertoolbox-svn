function [Lwa,xmin,xmax  ] = RenderTonemapParams(rgbImage)
% [Lwa,xmin,xmax ] = RenderTonemapParams(rgbImage)
%
% Lwa:      Lwa is mean log10 image values that are > 0.
% xmin:     minimum of image values that are > 0.
% xmax      maximum of image values that are > 0.
% 
%
% Analyze image to extract appropriate parameters
% for applying RenderTonemap.
%
% 5/20/04   dhb, bx     Wrote it.

% Find non-zero pixels
index = find(rgbImage > 0);

% Get Lwa
logImage = log10(rgbImage(index));
Lwa = mean(logImage(:));

% Get log min and max
xmin = log10(min(rgbImage(index)));
xmax = log10(max(rgbImage(index)));
