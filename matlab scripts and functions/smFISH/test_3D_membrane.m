dapi = open('dapi_Pos44_SegStacks.mat');
dapiimg = dapi.segStacks{1, 1};
dapimesh = mesh3(dapiimg);
dapimesh.preprocessth = [2.5 50 .8];
dapimesh.zxr = 0.4517;
% 1 / 0.24 / 9.2239     the z step is 0.24um, 1um is 9.2239 pixel

dapimesh.PreProcessImage; % this enlarges the image, for now OK, 
% later remove that part so it corresponds to the spots coordinates.
% actually it may be best to use the same enlargement in the spot images
% before detection to create clear OUTSIDE nuclei stacks.

%% test shrink images
imagebig = dapimesh.image;
extsize=5;
imagesmall = imagebig(1+extsize:end-extsize,1+extsize:end-extsize,1+extsize:end-extsize);


[ l1,v1,l2,v2,l3,v3 ] = DirectionalLaplacian(dapimesh.image);
[ bw2 ] = NonMaxiumSuppression( l1,l2,l3,v1,dapimesh.cannyth,dapimesh.image);

% 3d canny surface threshold
% strong edge, weak edge, surface remove angle (0.1,.8)
% the smaller th(3) is, the less connected is the surface
dapimesh.cannyth=[.8 .1 .8];
[ bw2a ] = NonMaxiumSuppression( l1,l2,l3,v1,dapimesh.cannyth,dapimesh.image);

dapimesh.cannyth=[.9 .7 .8];
[ bw2b ] = NonMaxiumSuppression( l1,l2,l3,v1,dapimesh.cannyth,dapimesh.image);

bw3 = bw2b
se=ones(3,3,3);
for i=1:3
    bw3=imdilate(bw3,se);
end;

L=bwlabeln(1-bw3);
bw4=L~=1;

for i=1:3
    bw4=imerode(bw4,se);
end;

dapimesh.bwsurf=bw4-bw2b;
L2=ones(size(bw2b));
L2(bw2b==1)=0;
L2((bw4-bw2b)==1)=2;
dapimesh.L=L2;

imgiso=bw4*2-bw2b-1;
imgiso=gaussianfilter3(imgiso,1.5);

p1=isosurface(imgiso,-0.2);
p1zero=isosurface(imgiso,0); % there was a note in the formula that it should be zero but it was not changed...
p1=reducepatch(p1,.5);
p1zero=reducepatch(p1zero,.5);

p1.vertices(:,3)=p1.vertices(:,3)*dapimesh.zxr;
p1zero.vertices(:,3)=p1zero.vertices(:,3)*dapimesh.zxr;

dapimesh.vertices=p1.vertices;
dapimesh.faces=p1.faces;
dapimesh.GetEdgesAndNeighbors;

dapimesh.vertices=p1zero.vertices;
dapimesh.faces=p1zero.faces;
dapimesh.GetEdgesAndNeighbors;

