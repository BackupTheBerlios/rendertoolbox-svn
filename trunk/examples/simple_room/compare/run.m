

%add render toolbox
addpath('/home1/brainard/dpl/trunk/RenderToolbox_2.0/DataHandling');
addpath('/home1/brainard/dpl/trunk/RenderToolbox_2.0/ImageProcessing');
addpath('/home1/brainard/dpl/trunk/RenderToolbox_2.0/PBRTRendering');
addpath('/home1/brainard/dpl/trunk/RenderToolbox_2.0/ParameterProcessing');
addpath('/home1/brainard/dpl/trunk/RenderToolbox_2.0/RadianceRendering');
addpath('/home1/brainard/dpl/trunk/RenderToolbox_2.0/RenderDataFiles');
addpath('/home1/brainard/dpl/trunk/RenderToolbox_2.0/RenderToolboxPathHandling');
addpath('/home1/brainard/dpl/trunk/RenderToolbox_2.0/ToplevelFunctions');
addpath('/home1/brainard/dpl/trunk/RenderToolbox_2.0/ClusterComputing');

%add sim toolbox ON TOP of the one bei uses. when matlab exists, it will no
%longer be on the path and bei's code will use it's own version
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/HypTools');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimColorBalancing');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimConfig');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimCameras');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimCameras/Old');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimCmfs');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimColorPriors');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimIlluminants');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimImages');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimImages/BFGB_128');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimImages/BFGG_128');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimImages/Cacaphony290');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimImages/DCS200Test');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimImages/DCS200TestIR');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimData/SimMonitors');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimDeMosaic');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimEstimateIlluminant');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimEstimateIlluminant/SimGrayWorld');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimEstimateIlluminant/SimSubspace');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimExamples');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimExamples/TestReadWriteFiles');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimExternal');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimExternal/scielab1-1-1');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimExternal/utility');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimImageMetric');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimInternalTools');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimInternalTools/NeedToBeUpdated');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimNoiseFunctions');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimReSample');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimReadWrite');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimReadWrite/SimFastReadRawImage');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimSimulation');
addpath('/home1/brainard/dpl/repos/simtoolbox/trunk/SimToolbox/SimToneMapping');

%call batchrender script
Render_BatchRender_cluster;
