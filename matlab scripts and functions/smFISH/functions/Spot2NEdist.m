function [ spotdapi ] = Spot2NEdist( dapiiso, spots )
%Spot2NEdist Calculate the distance between smFISH spots and the NE
%delimited by a DAPI isosurface.

spotdapi = spots;
distances = point2trimesh(dapiiso, 'QueryPoints', spots, 'Algorithm', 'parallel'); 
spotdapi(:,4) = distances;

end

