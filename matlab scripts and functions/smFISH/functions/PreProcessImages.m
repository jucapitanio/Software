function [ imagebig ] = PreProcessImages( image )
% preprocess the raw image 
% Taken from the 3D membrane reconstruction library

wimg3 = image;
wimg3=wimg3-ImgTh(wimg3,0.8); %usually 0.8 changing to see effect
wimg3(wimg3<0)=0;
extsize=5;
wimg3_ext=zeros(size(wimg3)+2*extsize);
wimg3_ext(1+extsize:end-extsize,1+extsize:end-extsize,1+extsize:end-extsize)=wimg3;
wimg3=wimg3_ext;
wimg3=bpass3(wimg3,1,50,1.84478);
wimg3=wimg3/max(wimg3(:));
imagebig=wimg3;


end

