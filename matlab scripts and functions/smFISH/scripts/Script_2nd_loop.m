%% Looping all the functions I made to analyze all images and save data

rootfolder = pwd;
numimg = length(dir(strcat(rootfolder, '\cell masks'))) - 2;

cy3_spotStats_files = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SpotStats\cy3'), 'cy3_Pos*_spotStats.mat'));
cy5_spotStats_files = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SpotStats\cy5'), 'cy5_Pos*_spotStats.mat'));
%dapimasktiff = dir(fullfile('C:\Users\Juliana\Documents\Lab Stuff 2015\Images\DeltaVision microscope\September 25 2015\posvRNA\rootCell\nuclei masks', 'dapi_Pos*.tif'));
dapisegstack = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SegStacks\dapi'), 'dapi_Pos*_SegStacks.mat'));
cellsegmask = dir(fullfile(strcat(rootfolder,'\SegmentationMasks'), 'segmenttrans_Pos*.mat'));

cy3countstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});
cy5countstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});
cy3midcountstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});
cy5midcountstt = struct('nuclear',{}, 'cyto',{}, 'total',{}, 'per100nuc',{}, 'Pos', {});

cellarea = struct('cellareaguess',{}, 'Pos', {});

for i = 1:numimg
    
    segmenttrans_maskfile = cellsegmask(i).name;
    cell_area_guess = guestimatecellarea(segmenttrans_maskfile, segmenttrans_maskfile(14:18)); % if more than 99 images will get processed, change to (14:19).
    cellarea = [cellarea, cell_area_guess];
    
    cy3_spotStats_file = cy3_spotStats_files(i).name;
    cy5_spotStats_file = cy5_spotStats_files(i).name;
    [ locs3 ] = goodspots( cy3_spotStats_file );
    [ locs5 ] = goodspots( cy5_spotStats_file );
    [ colocalizedcy3, colocalizedcy5 ] = colocalized( locs3, locs5, 10 );
    
    if not(isempty(colocalizedcy3)) && not(isempty(colocalizedcy5))

        dapisegstackfile = dapisegstack(i).name;
        [ dapiiso, Vnorm ] = DAPIisosurface( dapisegstackfile );
        
        [ coloccy3dapi ] = Spot2NEdist( dapiiso, colocalizedcy3 );
        [ coloccy5dapi ] = Spot2NEdist( dapiiso, colocalizedcy5 );

        [ cy3counts, cy5counts ] = countsummary( coloccy3dapi, coloccy5dapi, cy3_spotStats_file(5:10) );
        cy3countstt = [cy3countstt, cy3counts];
        cy5countstt = [cy5countstt, cy5counts];

        [ cy3midcoloc, cy5midcoloc ] = stacksubset( coloccy3dapi, coloccy5dapi, 10, 20 );
        [ cy3countsmid, cy5countsmid ] = countsummary( cy3midcoloc, cy5midcoloc, cy3_spotStats_file(5:10) );
        cy3midcountstt = [cy3midcountstt, cy3countsmid];
        cy5midcountstt = [cy5midcountstt, cy5countsmid];

        createfigure1(cy3midcoloc(:,1),cy3midcoloc(:,2), cy5midcoloc(:,1),cy5midcoloc(:,2), cy3midcoloc(:,4), cy5midcoloc(:,4));
        %savefig(strcat('Cell plot images\',cy3_spotStats_file(5:9),'.fig'));

        %clear  cy3_spotStats_file cy5_spotStats_file locs3 locs5 colocalizedcy3 colocalizedcy5 dapimasktiff_filepath coloccy3dapi coloccy5dapi cy3counts cy5counts cy3midcoloc cy5midcoloc cy3countsmid cy5countsmid cell_area_guess
    end;
end;

%clear cy3_spotStats_files cy5_spotStats_files dapimasktiff segmenttrans_maskfile
%save('AnalysisSummary.mat')

%% If you want you can also export the files to csv.

struct2csv(cy3countstt, 'cy3countstt.csv')
struct2csv(cy3midcountstt, 'cy3midcountstt.csv')
struct2csv(cy5midcountstt, 'cy5midcountstt.csv')
struct2csv(cy5countstt, 'cy5countstt.csv')
struct2csv(cellarea, 'cellareaguess.csv')