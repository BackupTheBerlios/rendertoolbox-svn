% Contents of DataHandling
% 3/16/06 dpl wrote it.
%
% This directory contains the functions used to maintain the material and light % library files, stored in RenderDataFiles.
%
% Data_FindDirectoryOnPath - Returns the full path of the directory on the
% 	current Matlab search path that contains the passed search string. If
% 	the directory is not found or if there is more than one directory on the
% 	path that contains the search string, this function throws an error.
% Data_GenerateSpd_D65 - Generates a .mat file containing spd_D65, a
% 	vector containting the D65 spectral power distribution, and S_D65, a
% 	vector that specifies the wavelength sampling of spd_D65. It saves this
% 	file in the current working directory. 
% Data_GenerateSur_macbethPeter - Same as above but creates the SRF 
% 	sur_macbethPeter and S_macbethePeter. 
% Data_GenerateSur_uvTable - Same as above; generates a set of SRF based
% 	on several uvValues specified in the function.