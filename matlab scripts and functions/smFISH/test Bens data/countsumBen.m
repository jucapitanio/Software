function [ counts ] = countsumBen( colocdapi, Pos )
%countsummary This will collect the number of spots in each cell location
%and and create a summary in a structure for cy3 and cy5. The input files
%come from the cellLocspot function. The Pos input refers to the name of
%the file evaluated eg. Pos_59

% nucleolar = size(colocdapi(colocdapi(:,5) > 0,:),1);

nuclear = size(colocdapi(colocdapi(:,4) > 0,:),1); % here change to reflect distance of NE to dapi

total = size(colocdapi,1);

counts = struct('nucleolar',nucleolar, 'nuclear',nuclear, 'total',total, 'Pos', Pos); %fix here

end