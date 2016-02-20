%% Create all necessary folders to run the analysis and add them to path.
% Go into the images directory where you want to store your analysis and
% then run the section below to create all folders.

AnalysisDate = '20160217';
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
cd ..\..\;

addpath(genpath('C:\Users\Juliana\Documents\MATLAB'));
addpath(genpath('C:\Users\Juliana\Documents\Lab Stuff 2015\Software\matlab scripts and functions'));
addpath(genpath(strcat('D:\Lab Stuff 2016\Experiments\test DAPI-NPCspots distance\', AnalysisDate)));
%addpath(genpath(strcat('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\Jul16_15\vRNA FISH\deconv for RF\test with new script dec2015\', AnalysisDate)));

clear AnalysisDate;
%% Start with ImageData folder with subfolder for each channel containing
% images for analysis.
% Create the position identifier Mask files with the function below. You
% must be in the root directory and the mask files in the SegmentationMasks
% folder.
rootfolder = pwd;
numimg = length(dir(strcat(rootfolder, '\cell masks'))) - 2;
date = '20160217';

parfor i = 1:numimg
    createSegmenttrans(strcat('Pos',num2str(i))); %Careful, they added a _*.tif in this function that should be *.tif only.
end;
%% 
createSegImages('tif');
%% 
doEvalFISHStacksForAll
%% To create this training set I used the images Pos10, 20, 30, 40, 49, 59. Repeating the command below.
% This includes all the different experimental conditions (drugs).
createSpotTrainingSet('cy3_Pos','Nup98')

%% 
load trainingSet_cy3_Nup98.mat
trainingSet=trainRFClassifier(trainingSet);

%% 
load trainingSet_cy3_Nup98.mat
classifySpotsOnDirectory(1,trainingSet,'cy3') % make sure this function has a case with your dye to get assigned to dyeToDo, somehow it can't read from the Aro_paramenters.

%% run the function reviewFISHClassification('dye_PosX') in the 2012a version of MATLAB. 
% Use an image different from the one used to create the training set and repeat the process for all channels.
% I used images Pos1, 11, 21, 31, 41 and 50 to cover all experimental
% conditions (drugs).
% Don't forget to change line 168 of this function with the full path to
% the Aro_parameters file. In this case it will be C:\Users\Juliana\Documents\Lab Stuff 2015 2nd sem\Images\Jul16_15\vRNA FISH\deconv for RF\rootCell
% Don't forget to add the new points to the training set. After each round
% of correction save and repeat the following commands:
load trainingSet_cy3_Nup98.mat
trainingSet=trainRFClassifier(trainingSet);
classifySpotsOnDirectory(1,trainingSet,'cy3')
% You'll have to do it manually and in the 2015 version of MATLAB. After
% retraining and detecting the spots repeat the reviewFISHClassification
% for new images (choose a different experimental condition). Repeat at
% least 3 or 4 times until you don't see much error in the classifications.

%% You can collect the data on all spots using the following function. 
% This is not that useful, but it's good to check classification error.
% It all ends saved in the Plots folder under AnalysisJu.

cy3Spotstats = strcat(rootfolder, '\AnalysisJu\SpotStats\cy3');

cd(cy3Spotstats);
spotStatsDataAligning([date 'cy3'], 0); %For this function, also make sure there is a case that matches your dye used.

cd(rootfolder);

movefile(strcat(rootfolder, '\AnalysisJu\SpotStats\cy3\wormData_', date, 'cy3.mat'), strcat(rootfolder, '\AnalysisJu\Plots\wormData_', date, 'cy3.mat'));
movefile(strcat(rootfolder, '\AnalysisJu\SpotStats\cy3\ErrorPercentagePlot_', date, 'cy3.fig'), strcat(rootfolder, '\AnalysisJu\Plots\ErrorPercentagePlot_', date, 'cy3.fig'));

%% FROM HERE ON, USE THE Script_wmyfunctions_loop.m to process everything.
% I left the example code below in case I need to do part of the analysis
% on a single image.

