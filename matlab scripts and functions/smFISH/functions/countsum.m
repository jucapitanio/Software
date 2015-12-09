function [ counts ] = countsum( colocdapi, Pos )
%countsummary This will collect the number of spots in each cell location
%and and create a summary in a structure for cy3 and cy5. The input files
%come from the cellLocspot function. The Pos input refers to the name of
%the file evaluated eg. Pos_59

nuclear = size(colocdapi(colocdapi(:,4) > 0,:),1);

cyto = size(colocdapi(colocdapi(:,4) < 0,:),1);

total = nuclear + cyto;

per100nuc = nuclear / total * 100;

counts = struct('nuclear',nuclear, 'cyto',cyto, 'total',total, 'per100nuc',per100nuc, 'Pos', Pos);

end