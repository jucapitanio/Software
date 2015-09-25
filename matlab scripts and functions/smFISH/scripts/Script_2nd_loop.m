%% Looping all the functions I made to analyze all images and save data

cy3_spotStats_files = dir(fullfile('C:\Users\Juliana\Documents\Lab Stuff 2015 2nd sem\Images\Jul16_15\vRNA FISH\deconv for RF\rootCell\AnalysisJu\SpotStats\cy3', 'cy3_Pos*_spotStats.mat'));
cy5_spotStats_files = dir(fullfile('C:\Users\Juliana\Documents\Lab Stuff 2015 2nd sem\Images\Jul16_15\vRNA FISH\deconv for RF\rootCell\AnalysisJu\SpotStats\cy5', 'cy5_Pos*_spotStats.mat'));
dapimasktiff = dir(fullfile('C:\Users\Juliana\Documents\Lab Stuff 2015 2nd sem\Images\Jul16_15\vRNA FISH\deconv for RF\rootCell\nuclei masks', 'dapi_Pos*.tif'));

cy3countstt = struct('nuclearcy3',{}, 'cytocy3',{}, 'totalcy3',{}, 'cy3per100nuc',{}, 'Pos', {});
cy5countstt = struct('nuclearcy5',{}, 'cytocy5',{}, 'totalcy5',{}, 'cy5per100nuc',{}, 'Pos', {});
cy3midcountstt = struct('nuclearcy3',{}, 'cytocy3',{}, 'totalcy3',{}, 'cy3per100nuc',{}, 'Pos', {});
cy5midcountstt = struct('nuclearcy5',{}, 'cytocy5',{}, 'totalcy5',{}, 'cy5per100nuc',{}, 'Pos', {});


for i = 1:59
    
    cy3_spotStats_file = cy3_spotStats_files(i).name;
    cy5_spotStats_file = cy5_spotStats_files(i).name;
    [ locs3, locs5 ] = goodspots( cy3_spotStats_file, cy5_spotStats_file );
    [ colocalizedcy3, colocalizedcy5 ] = colocalized( locs3, locs5, 10 );

    dapimasktiff_filepath = strcat('nuclei masks\', dapimasktiff(i).name);
    [ coloccy3dapi, coloccy5dapi ] = cellLocspot( colocalizedcy3, colocalizedcy5, dapimasktiff_filepath );

    [ cy3counts, cy5counts ] = countsummary( coloccy3dapi, coloccy5dapi, cy3_spotStats_file(5:9) );
    cy3countstt = [cy3countstt, cy3counts];
    cy5countstt = [cy5countstt, cy5counts];
    
    [ cy3midcoloc, cy5midcoloc ] = stacksubset( coloccy3dapi, coloccy5dapi, 14, 26 );
    [ cy3countsmid, cy5countsmid ] = countsummary( cy3midcoloc, cy5midcoloc, cy3_spotStats_file(5:9) );
    cy3midcountstt = [cy3midcountstt, cy3countsmid];
    cy5midcountstt = [cy5midcountstt, cy5countsmid];
    
    createfigure1(cy3midcoloc(:,1),cy3midcoloc(:,2), cy5midcoloc(:,1),cy5midcoloc(:,2), cy3midcoloc(:,4), cy5midcoloc(:,4));
    savefig(strcat('Cell plot images\',cy3_spotStats_file(5:9),'.fig'));

    clear  cy3_spotStats_file cy5_spotStats_file locs3 locs5 colocalizedcy3 colocalizedcy5 dapimasktiff_filepath coloccy3dapi coloccy5dapi cy3counts cy5counts cy3midcoloc cy5midcoloc cy3countsmid cy5countsmid
end;

clear cy3_spotStats_files cy5_spotStats_files dapimasktiff
save('AnalysisSummary.mat')

%% If you want you can also export the files to csv.

struct2csv(cy3countstt, 'cy3countstt.csv')
struct2csv(cy3midcountstt, 'cy3midcountstt.csv')
struct2csv(cy5midcountstt, 'cy5midcountstt.csv')
struct2csv(cy5countstt, 'cy5countstt.csv')