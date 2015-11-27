function [ cell_area_guess ] = guestimatecellarea( segmenttrans_maskfile, Pos )
%guestimatecellarea Try to estimate the area of the image covered by cells
%   This will be so we can normalize the number of vRNA to the actual area
%   with cells in the picture, since there is no way to estimate the number
%   of cells present.
load(segmenttrans_maskfile);
cellareaguess = sum(sum(currpolys{1,1}));
cell_area_guess = struct('cellareaguess',cellareaguess, 'Pos', Pos);
end

