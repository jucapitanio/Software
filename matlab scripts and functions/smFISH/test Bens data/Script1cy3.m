%% Create all necessary folders to run the analysis and add them to path.
% Go into the images directory where you want to store your analysis and
% then run the section below to create all folders.

AnalysisDate = '20160222';
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
mkdir('gfp');
cd ..\..\;

addpath(genpath('C:\Users\Juliana\Documents\MATLAB'));
addpath(genpath('C:\Users\Juliana\Documents\Lab Stuff 2015\Software\matlab scripts and functions'));
%addpath(genpath(strcat('D:\Lab Stuff 2016\Experiments\pathtodatahere\', AnalysisDate)));

clear AnalysisDate;

% Add the Aro_parameter.m file to the rootCell folder and modify it
% accordingly.

%% Rename the files according to the script requirements
raw_files = dir(fullfile(strcat(pwd,'\ImagesOriginal')));
raw_files = raw_files(3:end);
rename_files = cell(length(raw_files),2);
for i = 1:length(raw_files)
    rename_files(i,1) = cellstr(raw_files(i).name);
    rename_files(i,2) = cellstr(strcat('Pos', num2str(i)));
end;
rename_files

%% Double check the correct name structure was printed in the command window before actually changing the names.
% The name conversion is saved in the renaming_table.mat file.
save('renaming_table.mat','rename_files');
cd('ImagesOriginal');
for i = 1:length(rename_files)
    movefile(char(rename_files(i,1)),char(rename_files(i,2)));
end;

clear all
%% From here go to ImageJ and run the script that prepared the tiff files as
% required. Then move the tiff files into the correct folders in Image
% Data. Check the image masks look correct. If not, remake the bad one by
% hand and replace them (Pos5 and 6 showed issues). Usually these problems can be solved by removing
% one of the channels from mask creation (GFP in this case) or by adjusting the threshold for
% each channel manually before making the masks. You can also dilate the
% masks in case they are missing areas of interest.
% This is also the step where you can remove background areas detected by
% mistake (dust, strings, etc) or exclude cells that should not be part of
% the analysis. DANGER: Avoid excluding any cells if possible. Make sure to 
% only exclude cells that show real technical problems, avoid biasing your 
% data through cell selection.

%% Start with ImageData folder with subfolder for each channel containing
% images for analysis. The maks files go into the SegmentationMasks and
% Cell masks folders.
% Create the position identifier Mask files with the function below. You
% must be in the rootCell directory and the mask files in the SegmentationMasks
% folder.
rootfolder = pwd;
numimg = length(dir(strcat(rootfolder, '\cell masks'))) - 2;
date = '20160222';

parfor i = 1:numimg
    createSegmenttrans(strcat('Pos',num2str(i))); %Careful, they added a _*.tif in this function that should be *.tif only.
end;
%% For this use dyesUsed={'cy5','cy3'};isdapi='dapi'; in Aro_parameters.
% This will create the segstacks for all the necessary channels
createSegImages('tif');

addpath(genpath(pwd));
%% Before running this, which starts the spot detection, change the Aro_parameters.m to use only cy3
% dyesUsed={'cy3'};
% isdapi='dapi';
doEvalFISHStacksForAll
%% To create this training set repeat the command below for at least one
% image from each experimental condition. Always append the data to the
% existing trainingset. Collect at least 600 points, 1/2 good, 1/2 bad.
createSpotTrainingSet('cy3_Pos7','GFA1_mRNA')

%% 
load trainingSet_cy3_GFA1_mRNA.mat
trainingSet=trainRFClassifier(trainingSet);
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
rootfolder = pwd;
cy3Spotstats = strcat(rootfolder, '\AnalysisJu\SpotStats\cy3');

cd(cy3Spotstats);
spotStatsDataAligning([date 'cy3'], 0); %For this function, also make sure there is a case that matches your dye used.

cd(rootfolder);

movefile(strcat(rootfolder, '\AnalysisJu\SpotStats\cy3\wormData_', date, 'cy3.mat'), strcat(rootfolder, '\AnalysisJu\Plots\wormData_', date, 'cy3.mat'));
movefile(strcat(rootfolder, '\AnalysisJu\SpotStats\cy3\ErrorPercentagePlot_', date, 'cy3.fig'), strcat(rootfolder, '\AnalysisJu\Plots\ErrorPercentagePlot_', date, 'cy3.fig'));

%% FROM HERE ON, USE THE Script_wmyfunctions_loop.m to process everything.
% I left the example code below in case I need to do part of the analysis
% on a single image.

