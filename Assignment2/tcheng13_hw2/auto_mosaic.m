function []=auto_mosaic(I1,I2,p1,p2,d1,d2);

% obtain the corresponding point pairs m1 & m2 using the function:
% "sift_matcher"
[m1 m2]= sift_matcher(p1,p2,d1,d2);

% apply the function "RANSAC_ndlt.mat" to obtain homography from m2 to m1
[H]=RANSAC_ndlt(m2,m1);

% Blend the image I1 I2 to K, and display it 
[K] = blend(I1,I2,H);
figure;
K=uint8(K);
imshow(K);