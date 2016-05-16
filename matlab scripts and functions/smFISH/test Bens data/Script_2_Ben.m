%% Add all necessary folder paths to functions and data:
% In case the paths were lost from the 1st script.
addpath(genpath('C:\Users\Juliana\Documents\MATLAB'));
addpath(genpath('C:\Users\Juliana\Documents\Lab Stuff 2015\Software\matlab scripts and functions'));
%addpath(genpath('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\new script iso\rootCell'));
%% Looping all the functions I made to analyze all images and save data

rootfolder = pwd;
numimg = size(dir(strcat(rootfolder, '\cell masks')),1) - 2;

cy3_spotStats_files = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SpotStats\cy3'), 'cy3_Pos*_spotStats.mat'));
cy5segstack = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SegStacks\cy5'), 'cy5_Pos*_SegStacks.mat'));
dapisegstack = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SegStacks\dapi'), 'dapi_Pos*_SegStacks.mat'));
cellsegmask = dir(fullfile(strcat(rootfolder,'\SegmentationMasks'), 'segmenttrans_Pos*.mat'));

cy3countstt = struct('nucleolar',{}, 'nuclear',{}, 'total',{}, 'Pos', {}); %fix it
cy3midcountstt = struct('nucleolar',{}, 'nuclear',{}, 'total',{}, 'Pos', {}); %fix it

cellarea = struct('cellareaguess',{}, 'Pos', {});

% I cannot do clear or save inside a parfor loop, so I had to make it a for
% loop again... See if therre is another way to use parallel computing, or
% if you have parfor loops inside all functions possible.

for i = 1:numimg
    
    segmenttrans_maskfile = cellsegmask(i).name;
    cell_area_guess = guestimatecellarea(segmenttrans_maskfile, segmenttrans_maskfile(14:18)); % if more than 99 images will get processed, change to (14:19).
    cellarea = [cellarea, cell_area_guess]; %delete if you don't care about cell areas
    clear cell_area_guess segmenttrans_maskfile;
    
    cy3_spotStats_file = cy3_spotStats_files(i).name;
    [ locs3 ] = goodspotsBen( cy3_spotStats_file ); %add the same for cy5 channel
    
    if not(isempty(locs3))

        dapisegstackfile = dapisegstack(i).name;
        [ dapiiso, Vnormdapi, stackmid ] = DAPIisosurfaceBen( dapisegstackfile ); % change parameters for this one to work with yeast nuclei
        clear dapisegstackfile;
        
%         cy5segstackfile = cy5segstack(i).name;
%         [ cy5iso, Vnormcy5, stackmid ] = NucleoliIsosurfaceBen( cy5segstackfile );
%         clear cy5segstackfile;
%         
         [ cy3dapi ] = Spot2NEdist( dapiiso, locs3 );
%         [ cy3dapinucleoli ] = Spot2Nucleolidist( cy5iso, cy3dapi );
         clear locs3 cy3dapi;
        
         [ cy3counts ] = countsumBen( cy3dapinucleoli, cy3_spotStats_file(5:10) );
        
        cy3countstt = [cy3countstt, cy3counts];
        
        clear cy3counts;

        [ cy3mid ] = stacksubsetBen( cy3dapinucleoli, stackmid - 3, stackmid + 3 );
        
        [ cy3countsmid ] = countsumBen( cy3mid, cy3_spotStats_file(5:10) );
        
        cy3midcountstt = [cy3midcountstt, cy3countsmid];
        
        clear cy3countsmid;
        
        createfigureBen(dapiiso, Vnormdapi, cy5iso, Vnormcy5, cy3dapinucleoli, cy3_spotStats_file);
        
        clear cy3mid stackmid;
        save(strcat(rootfolder,'\SpotsData\SpotsIsosurf',cy3_spotStats_file(5:10),'.mat'));
        clear  cy3_spotStats_file cy3dapinucleoli Vnormdapi dapiiso Vnormcy5 cy5iso;
         
    end;
end;
figure('Visible', 'on', 'name','toClose'); 
close 'toClose';
clear cy3_spotStats_files dapisegstack cy5segstack cellsegmask rootfolder numimg;
save('AnalysisSummary.mat');

%% If you want you can also export the files to csv.

struct2csv(cy3countstt, 'cy3countstt.csv')
struct2csv(cy3midcountstt, 'cy3midcountstt.csv')
struct2csv(cy5midcountstt, 'cy5midcountstt.csv')
struct2csv(cy5countstt, 'cy5countstt.csv')
struct2csv(cellarea, 'cellareaguess.csv')
struct2csv(spotNEdistCy3, 'spotNEdistCy3.csv')
struct2csv(spotNEdistCy5, 'spotNEdistCy5.csv')