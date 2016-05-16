function [ cy5fillgaus, Vnorms, midstack ] = NucleoliIsosurfaceBen( cy5segstackfile )
%DAPIisosurface Create an isosurface from the DAPI greyscale image. 
% I had to include a step resize the image up and down or I'd run out of
% memory to create the isosurface. This looses a bit of definition though.
% Oh crap! Now I think this increases the size of the extra pixels in x y
% by 10 and not 5? I fixed it after reincreasing the image size.

Nucleoli = load(cy5segstackfile, 'segStacks');
Nucleoli = Nucleoli.segStacks{1, 1};
Nucleoli = imresize(Nucleoli,0.5);
NucleoliP = PreProcessImageBen(Nucleoli);

stacksize = size(Nucleoli,3);

cy5maskfill = [];
parfor i = 1:stacksize 
    cy5maskfill(:,:,i) = segmentImageBen(Nucleoli(:,:,i)); 
end;
cy5maskfill = imresize(cy5maskfill,2);
cy5maskfill = cy5maskfill(1+5:end-5,1+5:end-5,:);

cy5maskfill=gaussianfilter3(cy5maskfill,1);

isoVal = isovaluetest(cy5maskfill) * 0.5;
cy5fillgaus = isosurface(cy5maskfill,isoVal);

Vnorms = isonormals(cy5maskfill,cy5fillgaus.vertices);

cy5fillgaus.vertices(:,3) = (cy5fillgaus.vertices(:,3)* 1.84478) - 1.84478;

midstack = round(stacksize/2);
end

