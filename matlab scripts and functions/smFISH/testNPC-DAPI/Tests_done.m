%% regular code in script
i = 11;

rootfolder = pwd;

dapisegstack = dir(fullfile(strcat(rootfolder,'\AnalysisJu\SegStacks\dapi') ...
    , 'dapi_Pos*_SegStacks.mat'));

dapisegstackfile = dapisegstack(i).name;

[ dapiiso, Vnorm, stackmid ] = DAPIisosurface2( dapisegstackfile );

%figspanel1dye( dapiiso, Vnorm, cy3dapi, cy3mid, cy3_spotStats_file);
%% Open up DAPIisosurface2 function

dapi = open(dapisegstackfile);
dapi = dapi.segStacks{1, 1};
dapiraw = imresize(dapi,0.5);
dapi = PreProcessImages(dapiraw);

stacksize = size(dapi,3);
level = graythresh(dapi) * 0.8; %change level value to see effect 
%this is done in the DAPIisosurface function save in the experiment folder.
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

%% Effect of changing levels in the creation of masks used for isosurface 
%creation.

dapi = open(dapisegstackfile);
dapi = dapi.segStacks{1, 1};
dapiraw = imresize(dapi,0.5);
dapi = PreProcessImages(dapiraw);

level = graythresh(dapi) * 0.8; % vary to 0.1, 0.00001.
dapimaskfill = segmentNuclei(dapi(:,:,20),level); %slice 20 as example

%% Changing the PreProcess function to improve masks created.

dapi = open(dapisegstackfile);
dapi = dapi.segStacks{1, 1};
dapi = imresize(dapi,0.5);

wimg3 = dapi;
wimg3=wimg3-ImgTh(wimg3,0.4); %usually 0.8 changing to see effect
wimg3(wimg3<0)=0;

imtool(wimg3(:,:,20));

% extsize=5;
% wimg3_ext=zeros(size(wimg3)+2*extsize);
% wimg3_ext(1+extsize:end-extsize,1+extsize:end-extsize,1+extsize:end-extsize)=wimg3;
% wimg3=wimg3_ext;
% wimg3=bpass3(wimg3,1,50,2.213736);
% wimg3=wimg3/max(wimg3(:));
% imagebig=wimg3;

level = graythresh(wimg3) * 0.8; % vary to 0.1, 0.00001.
dapimaskfill = segmentNuclei(wimg3(:,:,20),level); %slice 20 as example
imtool(dapimaskfill);

%% Changing the segmentNuclei function
dapi = open(dapisegstackfile);
dapi = dapi.segStacks{1, 1};
dapiraw = imresize(dapi,0.5);
dapi = PreProcessImages(dapiraw);

level = graythresh(dapi) * 0.01;
im = dapi(:,:,20);

mask = im2bw(im,level);
mask = imfill(mask, 'holes');% I added this since activecontour does not accept masks with holes. If it breaks the code, remove it.
% Evolve segmentation
BW = activecontour(im, mask, 100, 'Chan-Vese','SmoothFactor',1.5,'ContractionBias',0); %Changing contraction bias to see effect

% Suppress components connected to image border
BW = imclearborder(BW);

% Fill holes
BW = imfill(BW, 'holes');

% Filter components by area, uncomment if desired.
% The nuclei in a mid stack is between 8000 and 14000 or so
% Good limits may be [2500 30000]
BW = bwareafilt(BW, [50 30000]);

% Form masked image from input image and segmented image.
maskedImage = im;
maskedImage(~BW) = 0;

% Fill holes in greyscale dapi
imgfillmask = imfill(maskedImage, 'holes');

%% Changing the isosurface function

dapi = open(dapisegstackfile);
dapi = dapi.segStacks{1, 1};
dapi = imresize(dapi,0.5);
dapi = PreProcessImages(dapi);

stacksize = size(dapi,3);
level = graythresh(dapi) * 0.01; %usually 0.8, changing to see effect, looks like no change.

dapimaskfill = [];
parfor i = 1:stacksize 
    dapimaskfill(:,:,i) = segmentNuclei(dapi(:,:,i),level); 
end;
dapimaskfill = imresize(dapimaskfill,2);
dapimaskfill = dapimaskfill(1+5:end-5,1+5:end-5,:);

dapimaskfill=gaussianfilter3(dapimaskfill,1.5);

% Usually the function below automatically chooses an isovalue based on the histogram of
% the image using the isovalue function. Let's see if we can change that
% value up and down to check the effect. I had to resave the isovalue
% function with the name isovaluetest so I can actually use it outside of
% isosurface.
isoVal = isovaluetest(dapimaskfill) * 0.5;
dapifillgaus = isosurface(dapimaskfill, isoVal);

Vnorms = isonormals(dapimaskfill,dapifillgaus.vertices);

dapifillgaus.vertices(:,3) = (dapifillgaus.vertices(:,3)* 2.213736) - 2.213726;


%% Plotting

pd = patch(dapiiso);
Vnorm;
pd.FaceColor = 'blue';
pd.EdgeColor = 'none';
daspect([1,1,1]) % Corrigir isso no make fig.
view(3); axis tight
camlight 
lighting gouraud
pd.FaceAlpha = 0.5;

hold on

scatter3(cy5dapi(cy5dapi(:,4) < 0,1),cy5dapi(cy5dapi(:,4) < 0,2),cy5dapi ...
    (cy5dapi(:,4) < 0,3),'MarkerEdgeColor','red','Marker','.');