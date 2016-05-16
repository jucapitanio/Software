function [ spotdapi ] = Spot2NEdistBen( dapiiso, spots )
%Spot2NEdist Calculate the distance between smFISH spots and the NE
%delimited by a DAPI isosurface.

spotdapi = spots;
distances = point2trimesh('Faces',dapiiso.faces, 'Vertices', dapiiso.vertices, 'QueryPoints', spots, 'Algorithm', 'parallel'); 
spotdapi(:,4) = distances;

end

