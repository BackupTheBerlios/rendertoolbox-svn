%RenRenderPurge
%Script that clean up the working directory
%
%3/31/04   bx wrote it

clear;
dir = pwd
tempDir = 'tempFiles';
cd(tempDir)
unix(['rm *.* ']);
cd(dir);

