function [ coloccy3dapi, coloccy5dapi ] = cellLocspot( colocalizedcy3, colocalizedcy5, dapimasktiff_filepath )
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

coloccy3dapi(:,4) = ones(1,length(coloccy3dapi)) * 10;
coloccy5dapi(:,4) = ones(1,length(coloccy5dapi)) * 10;

value = 10;
for j = 1:length(coloccy3dapi)
    value = stackmask(uint8(coloccy3dapi(j,3))).data(coloccy3dapi(j,1), coloccy3dapi(j,2));
    coloccy3dapi(j,4) = value;
end;

value = 10;
for j = 1:length(coloccy5dapi)
    value = stackmask(uint8(coloccy5dapi(j,3))).data(coloccy5dapi(j,1), coloccy5dapi(j,2));
    coloccy5dapi(j,4) = value;
end;

coloccy3dapi(:,3) = coloccy3dapi(:,3) * 0.24 * 9.2239;
coloccy5dapi(:,3) = coloccy5dapi(:,3) * 0.24 * 9.2239;


end

