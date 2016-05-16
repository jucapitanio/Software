%% Add all necessary folder paths to functions and data:
% In case the paths were lost from the 1st script.
%addpath(genpath('C:\Users\Juliana\Documents\MATLAB'));
addpath(genpath('C:\Users\Juliana\Documents\Lab Stuff 2015\Software'));
addpath(genpath(strcat('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\GAPDH\rootCell')));
%% Looping all the functions I made to analyze all images and save data

%parpool;
rootfolder = pwd;
numimg = size(dir(strcat(rootfolder, '\cell masks')),1) - 2;

cy3_spotStats_files = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SpotStats\cy3'), 'cy3_Pos*_spotStats.mat'));
dapisegstack = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SegStacks\dapi'), 'dapi_Pos*_SegStacks.mat'));
cellsegmask = dir(fullfile(strcat(rootfolder,'\SegmentationMasks'), 'segmenttrans_Pos*.mat'));

cy3countstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});
cy3midcountstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});

cellarea = struct('cellareaguess',{}, 'Pos', {});

% I cannot do clear or save inside a parfor loop, so I had to make it a for
% loop again... See if therre is another way to use parallel computing, or
% if you have parfor loops inside all functions possible.

for i = 1:numimg
    
    segmenttrans_maskfile = cellsegmask(i).name;
    cell_area_guess = guestimatecellarea(segmenttrans_maskfile, segmenttrans_maskfile(14:18)); % if more than 99 images will get processed, change to (14:19).
    cellarea = [cellarea, cell_area_guess];
    clear cell_area_guess segmenttrans_maskfile;
    
    cy3_spotStats_file = cy3_spotStats_files(i).name;
    [ locs3 ] = goodspots( cy3_spotStats_file );

    
    if not(isempty(locs3))

        dapisegstackfile = dapisegstack(i).name;
        [ dapiiso, Vnorm, stackmid ] = DAPIisosurface2( dapisegstackfile );
        clear dapisegstackfile;
        
        [ cy3dapi ] = Spot2NEdist( dapiiso, locs3 );
        clear locs3;
        
        dist3 = struct('Pos', cy3_spotStats_file(5:10), 'Distance', coloccy3dapi(:,4));
        spotNEdistCy3 = [spotNEdistCy3, dist3];
        clear dist3

        [ cy3counts ] = countsum( cy3dapi, cy3_spotStats_file(5:10) );
        cy3countstt = [cy3countstt, cy3counts];
        clear cy3counts;

        [ cy3mid ] = stacksubset( cy3dapi, stackmid - 5, stackmid + 5 );
                
        [ cy3countsmid ] = countsum( cy3mid, cy3_spotStats_file(5:10) );
                
        cy3midcountstt = [cy3midcountstt, cy3countsmid];
        
        clear cy3countsmid;

        figspanel1dye( dapiiso, Vnorm, cy3dapi, cy3mid, cy3_spotStats_file);
        
        clear cy3mid stackmid;
        save(strcat(rootfolder,'\SpotsData\SpotsIsosurf',cy3_spotStats_file(5:10),'.mat'));
        clear  cy3_spotStats_file cy3dapi Vnorm dapiiso;
         
    end;
end;
figure('Visible', 'on', 'name','toClose'); 
close 'toClose';
clear cy3_spotStats_files dapisegstack cellsegmask rootfolder numimg;
save('AnalysisSummary.mat');

%% If you want you can also export the files to csv.

struct2csv(cy3countstt, 'cy3countstt.csv')
struct2csv(cy3midcountstt, 'cy3midcountstt.csv')
struct2csv(cellarea, 'cellareaguess.csv')