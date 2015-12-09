%% Create all necessary folders to run the analysis and add them to path.
% Go into the images directory where you want to store your analysis and
% then run the section below to create all folders.

AnalysisDate = 'add date here';
%AnalysisDate = '20150716';
mkdir(AnalysisDate);
cd (AnalysisDate);
mkdir('ImagesOriginal');
mkdir('rootCell');
cd('rootCell');
mkdir('ImageData');
mkdir('SegmentationMasks');
mkdir('AnalysisJu');
mkdir('cell masks');
mkdir('Cell plot images');
mkdir('SpotsData');
cd('ImageData');
mkdir('dapi');
mkdir('cy3');
mkdir('cy5');
cd ..\..\;

addpath(genpath('C:\Users\Juliana\Documents\MATLAB'));
addpath(genpath('C:\Users\Juliana\Documents\Lab Stuff 2015\Software\matlab scripts and functions'));
addpath(genpath(strcat('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\somestufftogettofolder\', AnalysisDate)));
%addpath(genpath(strcat('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\Jul16_15\vRNA FISH\deconv for RF\test with new script dec2015\', AnalysisDate)));

clear AnalysisDate;
%% Start with ImageData folder with subfolder for each channel containing
% images for analysis.
% Create the position identifier Mask files with the function below. You
% must be in the rootCell directory and the mask files in the SegmentationMasks
% folder.
rootfolder = pwd;
numimg = size(dir(strcat(rootfolder, '\cell masks')),1) - 2;
date = '20150716';

parfor i = 1:numimg
    createSegmenttrans(strcat('Pos',num2str(i)));
end;
%% 
createSegImages('tif');
%% 
doEvalFISHStacksForAll
%% To create this training set I used the images Pos10, 20, 30, 40, 49, 59. Repeating the command below.
% This includes all the different experimental conditions (drugs).
createSpotTrainingSet('cy3_Pos11','Core-NS2')
%% To create this training set I used the images Pos10, 20, 30, 40, 49, 59. Repeating the command below.
% This includes all the different experimental conditions (drugs).
createSpotTrainingSet('cy5_Pos11','NS3-3UTR')
%% 
load trainingSet_cy3_Core-NS2.mat
trainingSet=trainRFClassifier(trainingSet);
load trainingSet_cy5_NS3-3UTR.mat
trainingSet=trainRFClassifier(trainingSet);
%% 
load trainingSet_cy3_Core-NS2.mat
classifySpotsOnDirectory(1,trainingSet,'cy3')
load trainingSet_cy5_NS3-3UTR.mat
classifySpotsOnDirectory(1,trainingSet,'cy5')
%% run the function reviewFISHClassification('dye_PosX') in the 2012a version of MATLAB. 
% Use an image different from the one used to create the training set and repeat the process for all channels.
% I used images Pos1, 11, 21, 31, 41 and 50 to cover all experimental
% conditions (drugs).
% Don't forget to change line 168 of this function with the full path to
% the Aro_parameters file. In this case it will be C:\Users\Juliana\Documents\Lab Stuff 2015 2nd sem\Images\Jul16_15\vRNA FISH\deconv for RF\rootCell
% Don't forget to add the new points to the training set. After each round
% of correction save and repeat the following commands:
load trainingSet_cy3_Core-NS2.mat
trainingSet=trainRFClassifier(trainingSet);
classifySpotsOnDirectory(1,trainingSet,'cy3')
load trainingSet_cy5_NS3-3UTR.mat
trainingSet=trainRFClassifier(trainingSet);
classifySpotsOnDirectory(1,trainingSet,'cy5')
% You'll have to do it manually and in the 2015 version of MATLAB. After
% retraining and detecting the spots repeat the reviewFISHClassification
% for new images (choose a different experimental condition). Repeat at
% least 3 or 4 times until you don't see much error in the classifications.

%% You can collect the data on all spots using the following function. 
% This is not that useful, but it's good to check classification error.
% It all ends saved in the Plots folder under AnalysisJu.

cy3Spotstats = strcat(rootfolder, '\AnalysisJu\SpotStats\cy3');
cy5Spotstats = strcat(rootfolder, '\AnalysisJu\SpotStats\cy5');

cd(cy3Spotstats);
spotStatsDataAligning([date 'cy3'], 0);

cd(cy5Spotstats);
spotStatsDataAligning([date 'cy5'], 0);

cd(rootfolder);

movefile(strcat(rootfolder, '\AnalysisJu\SpotStats\cy3\wormData_', date, 'cy3.mat'), strcat(rootfolder, '\AnalysisJu\Plots\wormData_', date, 'cy3.mat'));
movefile(strcat(rootfolder, '\AnalysisJu\SpotStats\cy5\wormData_', date, 'cy5.mat'), strcat(rootfolder, '\AnalysisJu\Plots\wormData_', date, 'cy5.mat'));
movefile(strcat(rootfolder, '\AnalysisJu\SpotStats\cy3\ErrorPercentagePlot_', date, 'cy3.fig'), strcat(rootfolder, '\AnalysisJu\Plots\ErrorPercentagePlot_', date, 'cy3.fig'));
movefile(strcat(rootfolder, '\AnalysisJu\SpotStats\cy5\ErrorPercentagePlot_', date, 'cy5.fig'), strcat(rootfolder, '\AnalysisJu\Plots\ErrorPercentagePlot_', date, 'cy5.fig'));

%% FROM HERE ON, USE THE Script_wmyfunctions_loop.m to process everything.
