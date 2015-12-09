function [ dapifillgaus, Vnorms, midstack ] = DAPIisosurface( dapisegstackfile )
%DAPIisosurface Create an isosurface from the DAPI greyscale image.

dapi = open(dapisegstackfile);
dapiimg = dapi.segStacks{1, 1};

dapiPP = PreProcessImages(dapiimg);

stacksize = size(dapiPP,3);
level = graythresh(dapiPP);

dapimaskfill = [];
parfor i = 1:stacksize 
    dapimaskfill(:,:,i) = segmentNuclei(dapiPP(:,:,i),level);
end;

imgiso=gaussianfilter3(dapimaskfill,1.5);
dapifillgaus = isosurface(imgiso);

Vnorms = isonormals(imgiso,dapifillgaus.vertices);

dapifillgaus.vertices(:,3) = (dapifillgaus.vertices(:,3)* 2.213736) - 2.213726;

midstack = round(stacksize/2);
end

