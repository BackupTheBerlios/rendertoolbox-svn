% makeConFiles generate a spreadsheet of descriptions of conditions in the experiment
% THis include the scene name, the 

clear all; close all;
% Read in condition files
conditionFileName = 'soccerExpt2.txt';
conditionStruct = ReadStructsFromText(conditionFileName);
nConditions = length(conditionStruct);

nCOnditions = 26;
coneImageDir = 'coneImages';


cd(coneImageDir)
surfaceColorNames = {'yel';'red';'blue'};
m = 1;
for i = 1:2:nConditions 
 %for i = 1;  
    % Read in the information from the structure
     % Read in the information from the structure
        surfaceName = conditionStruct(i).surfaceName

        
        patchColor = conditionStruct(i).patchColor;
        patchColorName = conditionStruct(i).patchColorName
        
        patchLocation = conditionStruct(i).patchLocation
        
        tableColor = conditionStruct(i).tableColor;
        tableColorName = conditionStruct(i).tableColorName;
        glossiness = conditionStruct(i).glossiness
        roughness = conditionStruct(i).roughness
        floorName = conditionStruct(i).floorName;
        floorPattern = conditionStruct(i).floorPattern;
        whichImage = conditionStruct(i).whichImage;
        lightPower = conditionStruct(i).lightPower;
        coneImageDir = conditionStruct(i).coneImageDir;
        imageRes = conditionStruct(i).imageRes;  
   
    if (whichImage == 0)
         coneImageStruct(m).Name = [surfaceName,'_',patchColorName,'_','l'];
    else
         coneImageStruct(m).Name = [surfaceName,'_',patchColorName,'_','r'];
    end
    coneImageStruct(m).Directory = [surfaceName,'_',patchColorName];
    
    coneImageStruct(m).ImageSize = imageRes;
    coneImageName = [surfaceName,'_',patchColorName];
    outputconeImagename = [coneImageName,'.txt'];
   
        
    conditionSumStruct(m).coneImageFolder = coneImageStruct(m).Directory;
    conditionSumStruct(m).surfaceColor = patchColorName;
    conditionSumStruct(m).patchLocation = patchLocation;
    conditionSumStruct(m).glossiness = glossiness;
    conditionSumStruct(m).roughness = roughness;
    
    % make a directory for the images of the current conditions
    conditionImageDir = coneImageStruct(m).Directory;
    if (~exist(conditionImageDir,'dir') )
        mkdir(conditionImageDir);
    end
    
   cmd = char(strcat('mv',{' '},coneImageStruct(m).Directory,'_*coneImage.mat', {' '},conditionImageDir,'/'));
   unix(cmd);
   %cd(conditionImageDir) 
   WriteStructsToText(outputconeImagename,coneImageStruct(m));            
   %cd ..
   m = m+1;
end
% save the struct to .txt file
outputName = 'conditionSum';
outputFileName = [outputName,'.txt'];
WriteStructsToText(outputFileName,conditionSumStruct);

cd ..