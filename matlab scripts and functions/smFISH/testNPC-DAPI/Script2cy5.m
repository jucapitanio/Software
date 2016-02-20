%% Add all necessary folder paths to functions and data:
% In case the paths were lost from the 1st script.
%addpath(genpath('C:\Users\Juliana\Documents\MATLAB'));
addpath(genpath('C:\Users\Juliana\Documents\Lab Stuff 2015\Software'));
addpath(genpath(strcat('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\GAPDH\rootCell')));
%% Looping all the functions I made to analyze all images and save data

%parpool;
rootfolder = pwd;
numimg = size(dir(strcat(rootfolder, '\cell masks')),1) - 2;

cy5_spotStats_files = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SpotStats\cy5'), 'cy5_Pos*_spotStats.mat'));
dapisegstack = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SegStacks\dapi'), 'dapi_Pos*_SegStacks.mat'));
cellsegmask = dir(fullfile(strcat(rootfolder,'\SegmentationMasks'), 'segmenttrans_Pos*.mat'));

cy5countstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});
cy5midcountstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});

cellarea = struct('cellareaguess',{}, 'Pos', {});

spotNEdistCy5 = struct('Pos',{}, 'Distance',{});

% I cannot do clear or save inside a parfor loop, so I had to make it a for
% loop again... See if therre is another way to use parallel computing, or
% if you have parfor loops inside all functions possible.

for i = 1:numimg
    
    segmenttrans_maskfile = cellsegmask(i).name;
    cell_area_guess = guestimatecellarea(segmenttrans_maskfile, segmenttrans_maskfile(14:18)); % if more than 99 images will get processed, change to (14:19).
    cellarea = [cellarea, cell_area_guess];
    clear cell_area_guess segmenttrans_maskfile;
    
    cy5_spotStats_file = cy5_spotStats_files(i).name;
    [ locs5 ] = goodspots( cy5_spotStats_file );
    
    disp(strcat('Spots done at i=', num2str(i)));
    
    if not(isempty(locs5))

        dapisegstackfile = dapisegstack(i).name;
        [ dapiiso, Vnorm, stackmid ] = DAPIisosurface2( dapisegstackfile );
        clear dapisegstackfile;
        
        disp(strcat('Isosurface done at i=', num2str(i)));
        
        [ cy5dapi ] = Spot2NEdist( dapiiso, locs5 );
        clear locs5;
        
        dist5 = struct('Pos', cy5_spotStats_file(5:10), 'Distance', cy5dapi(:,4));
        spotNEdistCy5 = [spotNEdistCy5, dist5];
        clear dist5

        [ cy5counts ] = countsum( cy5dapi, cy5_spotStats_file(5:10) );
        cy5countstt = [cy5countstt, cy5counts];
        clear cy5counts;

        [ cy5mid ] = stacksubset( cy5dapi, stackmid - 5, stackmid + 5 );
                
        [ cy5countsmid ] = countsum( cy5mid, cy5_spotStats_file(5:10) );
                
        cy5midcountstt = [cy5midcountstt, cy5countsmid];
        
        clear cy5countsmid;
        
        disp(strcat('Counts done at i=', num2str(i)));

        figspanel1dye( dapiiso, Vnorm, cy5dapi, cy5mid, cy5_spotStats_file);
        
        clear cy5mid stackmid;
        save(strcat(rootfolder,'\SpotsData\SpotsIsosurf',cy5_spotStats_file(5:10),'.mat'));
        clear  cy5_spotStats_file cy5dapi Vnorm dapiiso;
        
        disp(strcat('SpotsData saved for i=', num2str(i)))
         
    end;
end;
figure('Visible', 'on', 'name','toClose'); 
close 'toClose';
clear cy5_spotStats_files dapisegstack cellsegmask rootfolder numimg;
save('AnalysisSummary.mat');

%% If you want you can also export the files to csv.

struct2csv(cy5countstt, 'cy5countstt.csv')
struct2csv(cy5midcountstt, 'cy5midcountstt.csv')
struct2csv(cellarea, 'cellareaguess.csv')
struct2csv(spotNEdistCy5, 'spotNEdistCy5.csv')