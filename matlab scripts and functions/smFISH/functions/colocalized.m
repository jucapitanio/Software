function [ colocalizedcy3, colocalizedcy5 ] = colocalized( locs3, locs5, distmax )
%colocalized Finding cy3 and cy5 points withing given distance of oposite
%dye points. 
%   I'll use [idx, dist] = rangesearch(X,Y,r), which returns the distances 
%   between each row of Y and the rows of X that are r or less distant.
%   For this the Z scale must be corrected to pixel distance not stack
%   number. locs3 and locs5 come from the goodspots function and the
%   distmax is the maximun distance in pixels between detected spots to 
%   consider them colocalized.

idx =  rangesearch(locs3, locs5, distmax);
idx = idx(~cellfun('isempty',idx)); %remove empty cells
idx = [idx{:}]; % merge all values into single row
idx = unique(idx); %remove duplicate values
colocalizedcy3 = locs3(idx, :);

idx =  rangesearch(locs5, locs3, distmax);
idx = idx(~cellfun('isempty',idx)); %remove empty cells
idx = [idx{:}]; % merge all values into single row
idx = unique(idx); %remove duplicate values
colocalizedcy5 = locs5(idx, :);


end

