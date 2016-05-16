function [ locsf ] = goodspotsBen( spotStats_file )

%goodspots Collecting the location of only selected spots to plot. 
%   I collect the X Y Z coordenates for only the spots classified as true.
%   I need to move the points by 5 in all directions to mach the dapi
%   isosurface I'll create later. I also need to reverse the X,Y
%   coordinates to match the dapi isosurface.
%   I have to transform the Z axis from stack number, to micron to pixels so
%   the values match the X and Y. I know that for these images the Z stacks 
%   are 0.24um apart and that 1um is 9.2239 pixels. I'm also setting the Z
%   axis to 0 instead of 1.

load(spotStats_file)
locs=spotStats{1}.locAndClass(spotStats{1}.locAndClass(:,4)==1,1:3);
locs = locs + 5; % adjust dims to compare to dapi isosurface later
locsf = [];
locsf(:,1) = locs(:,2); %Reverse x,y coords to match dapi.
locsf(:,2) = locs(:,1);
locsf(:,3) = (locs(:,3) * 1.84478) - 1.84478;

end

