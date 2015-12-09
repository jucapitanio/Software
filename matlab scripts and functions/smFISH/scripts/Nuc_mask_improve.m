%% Loading the segmented images from dapi SegStacks files. Create a mesh object and use the preprocessing.
dapi = open('dapi_Pos9_SegStacks.mat');
dapiimg = dapi.segStacks{1, 1};
%dapimesh = mesh3(dapiimg);
%dapimesh.preprocessth = [1 50 .8]; % gaussian smooth size, background remove size , cut background 80%
%dapimesh.zxr = 2.213736; % ou 0.45172504761182 reverso
% 1stack = 0.24um * 9.2239px/um     the z step is 0.24um, 1um is 9.2239 pixel

dapiPP = PreProcessImages(dapiimg); % this enlarges the image, for now OK, 
% later use the same enlargement in the spot images

%% Create a binary nuclei mask and shrink the processed images back to the original size.

stacksize = size(dapiPP,3);
level = graythresh(dapiPP);

dapimaskfill = [];
parfor i = 1:stacksize 
    dapimaskfill(:,:,i) = segmentNuclei(dapiPP(:,:,i),level);
end;

%% Load spots to compare to surfaces.
% This has to be completed for cy5 and colocalized spots when I have 2
% channels later on.
cy3spots = open('cy3_Pos9_spotStats.mat');
locs3=cy3spots.spotStats{1}.locAndClass(cy3spots.spotStats{1}.locAndClass(:,4)==1,1:3); % Careful, the X and Y from spots and isosurface are inverted.
locs3fix = locs3 + 5; % correct point coordinates to match dapi, done in the goodspots

%% Create isosurface and isonormals

imgiso=gaussianfilter3(dapimaskfill,1.5);
dapifillgaus = isosurface(imgiso);
% Below we have the plotting step by step and a new plotting function that can be used instead.

% This one creates a lot of holes in the surface
% scatter3(locs3fix(:,2),locs3fix(:,1),locs3fix(:,3),'MarkerEdgeColor','red','Marker','.');
% hold on;
% pd = patch(dapifillgaus);
% isonormals(imgiso,pd)
% pd.FaceColor = 'blue';
% pd.EdgeColor = 'none';
% daspect([1,1,0.45]) % Corrigir isso no make fig.
% view(3); axis tight
% camlight 
% lighting gouraud

% To use with the new function:
%createfigure2(X1, Y1, Z1, S1, C1, Vertices1, VertexNormals1, Faces1)

Vnorms = isonormals(imgiso,dapifillgaus.vertices);
%createfigure2(locs3fix(:,2), locs3fix(:,1), locs3fix(:,3), 50, 'red', dapifillgaus.vertices, Vnorms, dapifillgaus.faces);

%% Transform isosurface and points Zvalue and X,Y coordinates.
% First we need to fix the Zdim values, for the points and the surface
% vertices. 
% Zstep = 0.24 microns, 1 micron = 9.2239pixels, 0.24 = 2.213736
% Zvalue = (Stacknum * 2.213736) - 2.213736 -> subtract to set 1st stack 0.
points = [];
points(:,1) = locs3fix(:,2);
points(:,2) = locs3fix(:,1);
points(:,3) = (locs3fix(:,3) * 2.213736) - 2.213726; % I'm doing this in the goodspots function now.

dapifillgaus.vertices(:,3) = (dapifillgaus.vertices(:,3)* 2.213736) - 2.213726;

% I think this is the same as the patch function above... Is an isosurface
% a triangulated mesh? 
% meshdapi = drawMesh(dapiiso,'blue'); I think this is the same as patch?

% The input for point2trimesh should be a triangulated mesh, but it worked only
% with the isosurface not the mesh from drawMesh. Is that OK?
distances = point2trimesh(dapifillgaus, 'QueryPoints', points, 'Algorithm', 'parallel_vectorized_subfunctions'); 

%separando só pontos dentro do nucleo
positivos = points(distances > 0,:);
negativos = points(distances < 0,:);

% plot de ptos com mesh e hist de distancias com density function (kernel).

createfigure3(positivos(:,1), positivos(:,2), positivos(:,3), dapifillgaus.vertices, Vnorms, dapifillgaus.faces ,negativos(:,1),negativos(:,2),negativos(:,3));
histfit(distances,30,'kernel');

% outside nuclei = neg val, inside = pos val.
