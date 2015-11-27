function [ coloccy3dapi, coloccy5dapi ] = cellLocspot2( colocalizedcy3, colocalizedcy5, dapimasktiff_filepath, dapisegstackfile )
%cellLocspot Check if spot localizes to nuclei or cytoplasm
%   For this you need the files from the nuclei masks folder, created with
% the 'nuclei mask with Z' imageJ macro. They are 3D masks of the dapi 
% nuclei stain. You also need the colocalized spots for cy3 and cy5, they 
% are the outputs from function colocalized.
% If a spot is outside the nuclei the of collumn 4 in the output is 0 if 
% it's inside the nuclei the value will be 255 (the value starts at 10,
% so if you find that in col 4 something is wrong).

coloccy3dapi = colocalizedcy3;
coloccy5dapi = colocalizedcy5;
coloccy3dapi(:,3) = coloccy3dapi(:,3) / 0.24 / 9.2239;
coloccy5dapi(:,3) = coloccy5dapi(:,3) / 0.24 / 9.2239;
stackmask = tiffread2(dapimasktiff_filepath);

dapi = open(dapisegstackfile);
dapiimg = dapi.segStacks{1, 1};

coloccy3dapi(:,4) = ones(1,size(coloccy3dapi,1)) * 10;
coloccy5dapi(:,4) = ones(1,size(coloccy5dapi,1)) * 10;
coloccy3dapi(:,5) = ones(1,size(coloccy3dapi,1)) * 10;
coloccy5dapi(:,5) = ones(1,size(coloccy5dapi,1)) * 10;

value = 10;
for j = 1:size(coloccy3dapi,1)
    value = stackmask(uint8(coloccy3dapi(j,3))).data(coloccy3dapi(j,1), coloccy3dapi(j,2));
    coloccy3dapi(j,4) = value;
end;

value = 10;
for j = 1:size(coloccy5dapi,1)
    value = stackmask(uint8(coloccy5dapi(j,3))).data(coloccy5dapi(j,1), coloccy5dapi(j,2));
    coloccy5dapi(j,4) = value;
end;

value = 10;
for j = 1:size(coloccy3dapi,1)
    value = dapiimg(coloccy3dapi(j,1), coloccy3dapi(j,2), uint8(coloccy3dapi(j,3)));
    coloccy3dapi(j,5) = value;
end;

value = 10;
for j = 1:size(coloccy5dapi,1)
    value = dapiimg(coloccy5dapi(j,1), coloccy5dapi(j,2), uint8(coloccy5dapi(j,3)));
    coloccy5dapi(j,5) = value;
end;

coloccy3dapi(:,3) = coloccy3dapi(:,3) * 0.24 * 9.2239;
coloccy5dapi(:,3) = coloccy5dapi(:,3) * 0.24 * 9.2239;


end

