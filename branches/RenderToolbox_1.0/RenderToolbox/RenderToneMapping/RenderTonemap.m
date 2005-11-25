function output_im = RenderTonemap(input_im, L_wa, x_min, x_max, C, display_gamma, dither_amp);
% TONEMAP: Tone-map a high dynamic range RGB image INPUT_IM according
% to the sigmoidal compression specified by Tumblin et al. (1999) to create
% a low-dynamic range RGB image OUTPUT_IM for display 
% on monitor with gamma DISPLAY_GAMMA.  Adds dither specified by DITHER_AMP
% to avoid banding artifacts in dark regions.
% 
% This function was modified by Roland W. Fleming from code by Ron O. Dror.
% Please acknowledge R.O.D. if you use this code, and don't forget to cite
% Tunblin, Hodgins and Guenter (1999).  Two methods for display of high contrast images.
% ACM Transactions on Graphics. Vol. 18(1). pp. 56-94.
%
% Recommended settings for tone mapping my example image
% L_wa = .3             %RF% Controls the degree of non-linearity (NB -- should be between X_MIN and X_MAX)
% x_min = .1            %RF% Minimum input range in log-units
% x_max =  5            %RF% Maximum input range in log-units
% C =  28               %RF% Output dynamic range (be realistic about how different neighbouring pixels can be on your monitor)
% display_gamma = 1.8   %RF% Display monitor gamma
% dither_amp < 20e-6    %RF% Amount of high-frequency dither to add after tone-mapping 


% 4/22/04   bx added comments. 

%RF% Settings for tone-mapping
% Refer to equation (11) in the paper. pp 25
% x is the input scene in log units
% g is a gamma setting gamma(gamma) parameter
% gamma is the slope of the  sig curve when x = 1. 

g = .5:.001:2.5;

A = 2*L_wa.^g.*(x_max.^g-x_min.^g);                  
B_p = ((x_max*x_min).^g + L_wa.^(2*g))*(C-1);
B_n = ((x_max*x_min).^g - L_wa.^(2*g))*(C-1);
k = 1./(2*L_wa.^g.*(x_max.^g - C*x_min.^g)).*(B_p+sqrt(B_n.^2+C*A.^2));  % equation (11)
gamma = g.*(k-1)./(k+1); 
g_final = g(min(find(gamma > 1)));
k_final = k(min(find(gamma > 1)));
D = ((x_max/L_wa)^g_final + k_final)./((x_max/L_wa)^g_final + 1/k_final);

%RF% Separate RGB images:
red_image = input_im(:, :, 1);
green_image = input_im(:, :, 2);
blue_image = input_im(:, :, 3);

%RF% Combine to get CIE Y value, using multipliers specified in Radiance 
%RF% Source files: Radiance/ray/src/common/color.h
L_image = (.330*red_image + .710*green_image + .08*blue_image)/(.33 + .71 + .08);

%L_image = RenderLMStoY(red_image, green_image, blue_image);

%RF% take the display_gamma-root of correct luminance
%RF% values to display image on a monitor with gamma = display_gamma
L_image_gamma = L_image.^(1/display_gamma);  

x_image = L_image_gamma/L_wa;

% apply sigmoid mapping to luminance, then use to modify each color
% channel.  scale so that sigmoid output fills range (0,1).
I = find(x_image > 0);  % set negative values to 0 output
L_mod = zeros(size(x_image));
L_mod(I) = (D*(x_image(I).^g_final + 1/k_final)./(x_image(I).^g_final ...
    + k_final) - 1.0/C)/(1.0 ...
    - 1.0/C);
L_ratio = zeros(size(x_image));
L_ratio(I) = L_mod(I)./L_image(I);

% note:  we could end up with some negative values here, if L_image is
% positive but some of the component colors are negative.  I believe
% those will be clipped to 0, but just to be safe i've added the max
% statements below
red_mod = red_image.*L_ratio;
green_mod = green_image.*L_ratio;
blue_mod = blue_image.*L_ratio;

% add a small amount of dither, specified by dither_amp
dither_filt = [-1 -2 -1; -2 12 -2; -1 -2 -1];  % suggested by Ted Adelson
dither_noise = dither_amp*conv2(conv2(randn(size(red_image)), dither_filt, 'same'), ...
    dither_filt, 'same');
red_mod = red_mod+dither_noise;
dither_noise = dither_amp * conv2(conv2(randn(size(red_image)), dither_filt, 'same'), ...
    dither_filt, 'same');
green_mod = green_mod+dither_noise;
dither_noise = dither_amp * conv2(conv2(randn(size(red_image)), dither_filt, 'same'), ...
    dither_filt, 'same');
blue_mod = blue_mod+dither_noise;

% normalise image
red_mod = max(red_mod,0);
green_mod = max(green_mod,0);
blue_mod = max(blue_mod,0);

red_mod = min(red_mod,1);
green_mod = min(green_mod,1);
blue_mod = min(blue_mod,1);

%plot input-output relations
%figure;
%plot(log(green_image(:,1)),log(green_mod(:,1)),'ro');

output_im = cat(3,red_mod,green_mod,blue_mod);
