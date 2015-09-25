function [ cy3counts, cy5counts ] = countsummary( coloccy3dapi, coloccy5dapi, Pos )
%countsummary This will collect the number of spots in each cell location
%and and create a summary in a structure for cy3 and cy5. The input files
%come from the cellLocspot function. The Pos input refers to the name of
%the file evaluated eg. Pos_59

nuclearcy3 = length(coloccy3dapi(coloccy3dapi(:,4)==255,1));
nuclearcy5 = length(coloccy5dapi(coloccy5dapi(:,4)==255,1));

cytocy3 = length(coloccy3dapi(coloccy3dapi(:,4)==0,1));
cytocy5 = length(coloccy5dapi(coloccy5dapi(:,4)==0,1));

totalcy3 = nuclearcy3 + cytocy3;
totalcy5 = nuclearcy5 + cytocy5;

cy3per100nuc = nuclearcy3 / totalcy3 * 100;
cy5per100nuc = nuclearcy5 / totalcy5 * 100;

cy3counts = struct('nuclearcy3',nuclearcy3, 'cytocy3',cytocy3, 'totalcy3',totalcy3, 'cy3per100nuc',cy3per100nuc, 'Pos', Pos);
cy5counts = struct('nuclearcy5',nuclearcy5, 'cytocy5',cytocy5, 'totalcy5',totalcy5, 'cy5per100nuc',cy5per100nuc, 'Pos', Pos);

end

