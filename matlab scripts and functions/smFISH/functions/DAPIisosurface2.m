function [ dapifillgaus, Vnorms, midstack ] = DAPIisosurface2( dapisegstackfile )
%DAPIisosurface Create an isosurface from the DAPI greyscale image. 
% I had to include a step resize the image up and down or I'd run out of
% memory to create the isosurface. This looses a bit of definition though.
% Oh crap! Now I think this increases the size of the extra pixels in x y
% by 10 and not 5? I fixed it after reincreasing the image size.

dapi = open(dapisegstackfile);
dapi = dapi.segStacks{1, 1};
dapi = imresize(dapi,0.5);
dapi = PreProcessImages(dapi);

stacksize = size(dapi,3);
level = graythresh(dapi) * 0.8;

dapimaskfill = [];
parfor i = 1:stacksize 
    dapimaskfill(:,:,i) = segmentNuclei(dapi(:,:,i),level);
end;
dapimaskfill = imresize(dapimaskfill,2);
dapimaskfill = dapimaskfill(1+5:end-5,1+5:end-5,:);

dapimaskfill=gaussianfilter3(dapimaskfill,1.5);
dapifillgaus = isosurface(dapimaskfill);

Vnorms = isonormals(dapimaskfill,dapifillgaus.vertices);

dapifillgaus.vertices(:,3) = (dapifillgaus.vertices(:,3)* 2.213736) - 2.213726;

midstack = round(stacksize/2);
end

