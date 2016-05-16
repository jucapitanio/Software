function [ spotnucleoli ] = Spot2Nucleolidist( cy5iso, spots )
%Spot2NEdist Calculate the distance between smFISH spots and the NE
%delimited by a DAPI isosurface.

spotnucleoli = spots;
distances = point2trimesh(cy5iso, 'QueryPoints', spots(:,1:3), 'Algorithm', 'parallel'); 
spotnucleoli(:,5) = distances;

end

