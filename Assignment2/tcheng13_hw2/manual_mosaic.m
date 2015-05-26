function [K]=manual_mosaic(I1,I2)

%% Display the image for manual selection of corresponding point pairs
imshow(I1);
X1 =ginput(4);
X1=X1';
X1(3,:)=ones(1,length(X1));

imshow(I2);
X2= ginput(4);
X2=X2';
X2(3,:)=ones(1,length(X1));
close all;
%% Obtain the homography H from X1 & X2 using homography_ndlt
[H]=homography_ndlt(X2,X1);

%% Blend the image using blend(I1,I2,H) to image K, and display it
[K] = blend(I1,I2,H);
figure;
K=uint8(K);
imshow(K);