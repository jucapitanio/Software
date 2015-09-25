function [ locs3, locs5 ] = goodspots( cy3_spotStats_file, cy5_spotStats_file )

%goodspots Collecting the location of only selected spots to plot. 
%   I collect the X Y Z coordenates for only the spots classified as true.
%   I have to transform the Z axis from stack number, to micron to pixels so
%   the values match the X and Y. I know that for these images the Z stacks 
%   are 0.24um apart and that 1um is 9.2239 pixels. 
%   So I'll use Z number * 0.24 * 9.2239.

load(cy3_spotStats_file)
locs3=spotStats{1}.locAndClass(spotStats{1}.locAndClass(:,4)==1,1:3);
locs3(:,3) = locs3(:,3) * 0.24 * 9.2239;

load(cy5_spotStats_file)
locs5=spotStats{1}.locAndClass(spotStats{1}.locAndClass(:,4)==1,1:3);
locs5(:,3) = locs5(:,3) * 0.24 * 9.2239;

end

