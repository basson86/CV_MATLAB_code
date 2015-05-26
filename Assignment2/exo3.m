close all;
clear all;
I1 = imread('hopkins1.jpg');
I2 = imread('hopkins2.jpg');


%% (a)please check the written part of the homework
%% (b)check the solution file : homography_ndlt.m
%% (c) check the solution file : blend.m

%% (d)
K=manual_mosaic(I1,I2);

%% (f) Load "sift_hopkins.mat" to creat the variables SIFT_D1,SIFT_D2,SIFT_P2,SIFT_P2
S = load('sift_hopkins.mat');
SIFT_D1=S.SIFT_D1;
SIFT_D2=S.SIFT_D2;
SIFT_P1=S.SIFT_P1;
SIFT_P2=S.SIFT_P2;

%(i) Display the feature locations on the images
figure;
subplot(1,2,1);
imshow(I1);
hold on;
scatter(SIFT_P1(1,:),SIFT_P1(2,:),'x');
subplot(1,2,2);
imshow(I2);
hold on;
scatter(SIFT_P2(1,:),SIFT_P2(2,:),'x');

% (ii) implement a function : sift_matcher(p1,p2,d1,d2)
d1=S.SIFT_D1;
d2=S.SIFT_D2;
p1=S.SIFT_P1;
p2=S.SIFT_P2;

[m1 m2]= sift_matcher(p1,p2,d1,d2);

% (iii) Display 2 images side-by-side to draw lines between the matched
% features
for i= 1:20
figure(3);
subplot(1,2,1);
imshow(I1);hold on;
plot(m1(1,1:i),m1(2,1:i),'rx','LineWidth',2);
[linex1,liney1] = dsxy2figxy(gca, m1(1,i), m1(2,i));
subplot(1,2,2);
imshow(I2);hold on;
plot(m2(1,1:i),m2(2,1:i),'rx','LineWidth',2);
[linex2,liney2] = dsxy2figxy(gca, m2(1,i), m2(2,i));
annotation(figure(3),'line',[linex1 linex2],[1-0.5*liney1-0.2 1-0.5*liney2-0.2]);
end

%% (g) 
% (i)implement the function RANSAC_ndlt
[H]=RANSAC_ndlt(m1,m2);

% (ii)Display the two images side-by-side and show the inliners computed in
% the previous question
m1(3,:)=1;
m2(3,:)=1;
% distance threshold for inliner computation
D=1.3;
% get the inliner of estimated H from RANSAC using the funciton: "inliers_homography.mat" 
[INLm1 INLm2]=inliers_homography(H,m1,m2,D);
% display the inliners on the two images
figure;
subplot(1,2,1);
imshow(I1);
hold on;
scatter(INLm1(1,:),INLm1(2,:),'r*');
subplot(1,2,2);
imshow(I2);
hold on;
scatter(INLm2(1,:),INLm2(2,:),'r*');

% (iii) implement the function : "auto_mosaic.mat"  
auto_mosaic(I1,I2,p1,p2,d1,d2);
