%% Add all necessary folder paths to functions and data:
% In case the paths were lost from the 1st script.
addpath(genpath('C:\Users\Juliana\Documents\MATLAB'));
addpath(genpath('C:\Users\Juliana\Documents\Lab Stuff 2015\Software\matlab scripts and functions'));
%addpath(genpath('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\new script iso\rootCell'));
%% Looping all the functions I made to analyze all images and save data

rootfolder = pwd;
numimg = size(dir(strcat(rootfolder, '\cell masks')),1) - 2;

cy3_spotStats_files = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SpotStats\cy3'), 'cy3_Pos*_spotStats.mat'));
cy5_spotStats_files = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SpotStats\cy5'), 'cy5_Pos*_spotStats.mat'));
dapisegstack = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SegStacks\dapi'), 'dapi_Pos*_SegStacks.mat'));
cellsegmask = dir(fullfile(strcat(rootfolder,'\SegmentationMasks'), 'segmenttrans_Pos*.mat'));

cy3countstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});
cy5countstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});
cy3midcountstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});
cy5midcountstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});

cellarea = struct('cellareaguess',{}, 'Pos', {});

spotNEdistCy3 = struct('Pos',{}, 'Distance',{});
spotNEdistCy5 = struct('Pos',{}, 'Distance',{});

% I cannot do clear or save inside a parfor loop, so I had to make it a for
% loop again... See if therre is another way to use parallel computing, or
% if you have parfor loops inside all functions possible.

for i = 1:numimg
    
    segmenttrans_maskfile = cellsegmask(i).name;
    cell_area_guess = guestimatecellarea(segmenttrans_maskfile, segmenttrans_maskfile(14:18)); % if more than 99 images will get processed, change to (14:19).
    cellarea = [cellarea, cell_area_guess];
    clear cell_area_guess segmenttrans_maskfile;
    
    cy3_spotStats_file = cy3_spotStats_files(i).name;
    cy5_spotStats_file = cy5_spotStats_files(i).name;
    [ locs3 ] = goodspots( cy3_spotStats_file );
    [ locs5 ] = goodspots( cy5_spotStats_file );
    [ colocalizedcy3, colocalizedcy5 ] = colocalized( locs3, locs5, 10 );
    clear locs3 locs5;
    
    if not(isempty(colocalizedcy3)) && not(isempty(colocalizedcy5))

        dapisegstackfile = dapisegstack(i).name;
        [ dapiiso, Vnorm, stackmid ] = DAPIisosurface2( dapisegstackfile );
        clear dapisegstackfile;
        
        [ coloccy3dapi ] = Spot2NEdist( dapiiso, colocalizedcy3 );
        [ coloccy5dapi ] = Spot2NEdist( dapiiso, colocalizedcy5 );
        clear colocalizedcy3 colocalizedcy5;
        
        dist3 = struct('Pos', cy3_spotStats_file(5:10), 'Distance', coloccy3dapi(:,4));
        dist5 = struct('Pos', cy5_spotStats_file(5:10), 'Distance', coloccy5dapi(:,4));
        
        spotNEdistCy3 = [spotNEdistCy3, dist3];
        spotNEdistCy5 = [spotNEdistCy5, dist5];
        clear dist3 dist5;
        
        [ cy3counts ] = countsum( coloccy3dapi, cy3_spotStats_file(5:10) );
        [ cy5counts ] = countsum( coloccy5dapi, cy5_spotStats_file(5:10) );
        
        cy3countstt = [cy3countstt, cy3counts];
        cy5countstt = [cy5countstt, cy5counts];
        clear cy3counts cy5counts;

        [ cy3midcoloc ] = stacksubset( coloccy3dapi, stackmid - 5, stackmid + 5 );
        [ cy5midcoloc ] = stacksubset( coloccy5dapi, stackmid - 5, stackmid + 5 );
        
        [ cy3countsmid ] = countsum( cy3midcoloc, cy3_spotStats_file(5:10) );
        [ cy5countsmid ] = countsum( cy5midcoloc, cy5_spotStats_file(5:10) );
        
        cy3midcountstt = [cy3midcountstt, cy3countsmid];
        cy5midcountstt = [cy5midcountstt, cy5countsmid];
        clear cy3countsmid cy5countsmid;

        figspanel( dapiiso, Vnorm, coloccy3dapi, coloccy5dapi, cy3midcoloc, cy5midcoloc, cy3_spotStats_file);
        
        clear cy5_spotStats_file cy3midcoloc cy5midcoloc stackmid;
        save(strcat(rootfolder,'\SpotsData\SpotsIsosurf',cy3_spotStats_file(5:10),'.mat'));
        clear  cy3_spotStats_file coloccy3dapi coloccy5dapi Vnorm dapiiso;
         
    end;
end;
figure('Visible', 'on', 'name','toClose'); 
close 'toClose';
clear cy3_spotStats_files cy5_spotStats_files dapisegstack cellsegmask rootfolder numimg;
save('AnalysisSummary.mat');

%% If you want you can also export the files to csv.

struct2csv(cy3countstt, 'cy3countstt.csv')
struct2csv(cy3midcountstt, 'cy3midcountstt.csv')
struct2csv(cy5midcountstt, 'cy5midcountstt.csv')
struct2csv(cy5countstt, 'cy5countstt.csv')
struct2csv(cellarea, 'cellareaguess.csv')
struct2csv(spotNEdistCy3, 'spotNEdistCy3.csv')
struct2csv(spotNEdistCy5, 'spotNEdistCy5.csv')