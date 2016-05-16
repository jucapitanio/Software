function [ dapifillgaus, Vnorms, midstack ] = DAPIisosurfaceBen( dapisegstackfile )
%DAPIisosurface Create an isosurface from the DAPI greyscale image. 
% I had to include a step resize the image up and down or I'd run out of
% memory to create the isosurface. This looses a bit of definition though.
% Oh crap! Now I think this increases the size of the extra pixels in x y
% by 10 and not 5? I fixed it after reincreasing the image size.

dapi = open(dapisegstackfile);
dapi = dapi.segStacks{1, 1};
dapi = imresize(dapi,0.5); %you can try to avoid resizing image
dapi = PreProcessImageBen(dapi); %change parameters for this function too

stacksize = size(dapi,3);

dapimaskfill = [];

level = graythresh(dapi) * 0.01; %play with this 0.01 to see the effects
parfor i = 1:stacksize 
    dapimaskfill(:,:,i) = segmentNucleiBen(dapi(:,:,i),level); %plot the dapimaskfill to see how it changes
end;
dapimaskfill = imresize(dapimaskfill,2); %you can try to avoid resizing image
dapimaskfill = dapimaskfill(1+5:end-5,1+5:end-5,:);

dapimaskfill=gaussianfilter3(dapimaskfill,1); % you can change the 1 here too, for more or less bluriness

isoVal = isovaluetest(dapimaskfill) * 0.5; %change the 0.5 to see where the surface is created.
dapifillgaus = isosurface(dapimaskfill,isoVal);

Vnorms = isonormals(dapimaskfill,dapifillgaus.vertices);

dapifillgaus.vertices(:,3) = (dapifillgaus.vertices(:,3)* 1.84478) - 1.84478;

midstack = round(stacksize/2);
end

