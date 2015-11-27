% Start with ImageData folder with subfolder for each channel containing
% images for analysis.
% Create the position identifier Mask files with the function below. You
% must be in the root directory and the mask files in the SegmentationMasks
% folder.

for i = 1:67
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

rootfolder = 'C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell'
cy3Spotstats = 'C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\SpotStats\cy3'
cy5Spotstats = 'C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\SpotStats\cy5'

cd(cy3Spotstats);
spotStatsDataAligning('20150925cy3', 0);

cd(cy5Spotstats);
spotStatsDataAligning('20150925cy5', 0);

cd(rootfolder);

movefile('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\SpotStats\cy3\wormData_20150925cy3.mat', 'C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\Plots\wormData_20150925cy3.mat');
movefile('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\SpotStats\cy5\wormData_20150925cy5.mat', 'C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\Plots\wormData_20150925cy5.mat');
movefile('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\SpotStats\cy3\ErrorPercentagePlot_20150925cy3.fig', 'C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\Plots\ErrorPercentagePlot_20150925cy3.fig');
movefile('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\SpotStats\cy5\ErrorPercentagePlot_20150925cy5.fig', 'C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\AnalysisJu\Plots\ErrorPercentagePlot_20150925cy5.fig');

%% FROM HERE ON, USE THE Script_wmyfunctions_loop.m to process everything.
% I left the example code below in case I need to do part of the analysis
% on a single image.

%% Collecting the location of only selected spots to plot. 
% I collect the X Y Z coordenates for only the spots classified as true.
% I have to transform the Z axis from stack number, to micron to pixels so
% the values match the X and Y. I know that the Z stacks are 0.24um apart
% and that 1um is 9.2239 pixels. So I'll use Z number * 0.24 * 9.2239
% I turned this into the function
% [ locs3, locs5 ] = goodspots( cy3_spotStats_file, cy5_spotStats_file )

load('cy3_Pos58_spotStats.mat')
locs3=spotStats{1}.locAndClass(spotStats{1}.locAndClass(:,4)==1,1:3);
locs3(:,3) = locs3(:,3) * 0.24 * 9.2239;

load('cy5_Pos58_spotStats.mat')
locs5=spotStats{1}.locAndClass(spotStats{1}.locAndClass(:,4)==1,1:3);
locs5(:,3) = locs5(:,3) * 0.24 * 9.2239;

%% Finding cy3 and cy5 points withing given distance oposite dye (colocalization)
% [idx, dist] = rangesearch(X,Y,r)  returns the distances between each row 
% of Y and the rows of X that are r or less distant.
% I made this into the function colocalized
% [ colocalizedcy3, colocalizedcy5 ] = colocalized( locs3, locs5, distmax )

idx =  rangesearch(locs3, locs5, 10);
idx = idx(~cellfun('isempty',idx)); %remove empty cells
idx = [idx{:}]; % merge all values into single row
idx = unique(idx); %remove duplicate values
colocalizedcy3 = locs3(idx, :);

[idx, dist] =  rangesearch(locs5, locs3, 10);
idx = idx(~cellfun('isempty',idx)); %remove empty cells
idx = [idx{:}]; % merge all values into single row
idx = unique(idx); %remove duplicate values
colocalizedcy5 = locs5(idx, :);

%% Check if spot in nuclei or cytoplasm
% For this you need the files from the nuclei masks folder, created with
% the 'nuclei mask with Z' imageJ macro. The mask names must be changed 
%with the R script before using!!! If outside nuclei value 0 if
% inside value 255. I turned this into the cellLocspot function.
% [ coloccy3dapi, coloccy5dapi ] = cellLocspot( colocalizedcy3, colocalizedcy5, dapimasktiff_filepath )

coloccy3dapi = colocalizedcy3;
coloccy5dapi = colocalizedcy5;
coloccy3dapi(:,3) = coloccy3dapi(:,3) / 0.24 / 9.2239;
coloccy5dapi(:,3) = coloccy5dapi(:,3) / 0.24 / 9.2239;
stackmask = tiffread2('C:\Users\Juliana\Documents\Lab Stuff 2015 2nd sem\Images\Jul16_15\vRNA FISH\deconv for RF\rootCell\nuclei masks\dapi_Pos58_mask3D.tif');

coloccy3dapi(:,4) = ones(1,length(coloccy3dapi)) * 10;
coloccy5dapi(:,4) = ones(1,length(coloccy5dapi)) * 10;

value = 10;
for i = 1:length(coloccy3dapi)
    value = stackmask(uint8(coloccy3dapi(i,3))).data(coloccy3dapi(i,1), coloccy3dapi(i,2));
    coloccy3dapi(i,4) = value;
end;

value = 10;
for i = 1:length(coloccy5dapi)
    value = stackmask(uint8(coloccy5dapi(i,3))).data(coloccy5dapi(i,1), coloccy5dapi(i,2));
    coloccy5dapi(i,4) = value;
end;

%% I have created a function to summarize the info on spot localization
% [ cy3counts, cy5counts ] = countsummary( coloccy3dapi, coloccy5dapi )
% See that file for the code. Inputs come from the cellLocspot function.

[ cy3counts, cy5counts ] = countsummary( coloccy3dapi, coloccy5dapi );

%% I made a stacksubset function.
% It will take in any point coordinate file and subset only the desired Z
% stacks range non-inclusive. For example for stack 10, start 9, stop 11.
% [ cy3subset, cy5subset ] = stacksubset( cy3pointcoord, cy5pointcoord, start, stop )

[ cy3midcoloc, cy5midcoloc ] = stacksubset( coloccy3dapi, coloccy5dapi, 14, 26 );

% You can then recount just considering central images:
[ cy3countsmid, cy5countsmid ] = countsummary( cy3midcoloc, cy5midcoloc );

%% To plot now use create figure function
% make sure the createfigure.m file is in the same dir
% The 4th column will indicate the color, 3 for cy3 and 5 for cy5
% The locsmid variable select only Zstacks from 9 to 30 non inclusive.

locsmidcy3=locs3(locs3(:,3)>19.923624 & locs3(:,3)<66.41208,:);
locsmidcy3(:,4) = ones(1,length(locsmidcy3)) * 3;

locsmidcy5=locs5(locs5(:,3)>19.923624 & locs5(:,3)<66.41208,:);
locsmidcy5(:,4) = ones(1,length(locsmidcy5)) * 5;

locsmid = [locsmidcy3; locsmidcy5];

%imread('Composite rgb.tif');

createfigure(locsmid(:,1),locsmid(:,2),locsmid(:,3),3,locsmid(:,4))
%hold on
%this part is not working very well.
%imshow(ans); 
