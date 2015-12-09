
[ locs3 ] = goodspots( 'cy3_Pos1_spotStats.mat' );
[ dapiiso, Vnorm, stackmid ] = DAPIisosurface2( 'dapi_Pos1_SegStacks.mat' );
spots = locs3(1:10,:);
distances = point2trimesh(dapiiso, 'QueryPoints', spots, 'Algorithm', 'parallel_vectorized_subfunctions'); 

%'parallel_vectorized_subfunctions' 0.629 s 1.647 s 12.506 s
% linear vectorized subfunctions 0.426 s 3.450 s
% linear 0.363 s 3.134 s
% parallel 0.386 s 1.531 s 11.390 s
% vectorized 0.614 s 5.369 s