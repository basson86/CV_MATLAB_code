%% (a) (3 pts) Algebraic circle fitting
% see the written sheet- page 1

%% (b) (3 pts)
% see the written sheet- page 2

%% (c) (2 pts) Write a matlab function [Solution file points_circle.m]
% file is in the directory

%% (d) (2 pts) Write a matlab function [Solution file noisy_points_circle.m]
% file is in the directory

%% (e) (2 pts) Write a matlab function [Solution file ls_circle.m]
% file is in the directory

%% (f) (3 pts) Using the previous functions, generate an image of size 512 x 512 containing 10
%points from the circle {C = [130; 150]', r = 50} (circle points have intensity 1, other
%points have intensity 0).
clear all;
close all;

% Circle parameters
C=[130;150];
r=50;
% number of points to be generated on the circle
n=10;

% generate the 10 points using the "point_circle" function 
[P] = point_circle(C,r,n);

%Estimate the circle center and radius using the function "ls_circle" and compare to the original parameters. 
[C_e,r_e]=ls_circle(P);

% Generate the 10 points on the circle using the "estimated" circle
% center:"C_e" and estimated radius: "r_e"
[Pe] = point_circle(C_e,r_e,n);

% Generate an image of size 512x512 containing 10 points from the circle 
% C = [130; 150]T; r = 50 (circle points have intensity 1, other points have intensity 0).
ImC=zeros(512,512);

for i=1:length(P)
ImC(round(P(1,i)),round(P(2,i)))=1;
ImC(round(Pe(1,i)),round(Pe(2,i)))=1;
end

%Compare also the results visually by plotting the estimated circle in the image.
figure;
imshow(ImC);
title('the original circle points & estimated circle points (without noise)')

%*Conclusion: 
% The "ls_cirle" gives us a good estimation, the estimated value of C_e & r_e are
% both identical to the original value C & r, and the generated points from
% both [C,r] and [C_e,r_e] coincide with each other 


%% (g)(2 pts) Perform the same experiment using 10 noisy points (sigma = 10).
sigma=10;
% generate the 10 noisy points using "noisy_points_circle"
[Pn] = noisy_points_circle(C,r,n,sigma);
% From noisy points, estimate the circle center and radius : Cn_e & rn_e
[Cn_e,rn_e]=ls_circle(Pn);

% Generate an image of size 512x512 containing 10 points from the circle 
% C = [130; 150]T; r = 50 (circle points have intensity 1, other points have intensity 0).
% (using 10 noisy cricle points
ImC_n=zeros(512,512);
ImC_ne=zeros(512,512);

% Generate the 10 points on the circle using the "estimated" circle
% center:"Cn_e" and estimated radius: "rn_e"
[Pn_e] = point_circle(Cn_e,rn_e,n);

for i = 1:n
    ImC_n(round(Pn(1,i)),round(Pn(2,i)))=1;
    ImC_ne(round(Pn_e(1,i)),round(Pn_e(2,i)))=1;
end

figure;
imshow(ImC_n);
title('the original circle points with noise)');
figure;
imshow(ImC_ne);
title('the estimated circle points from noisy points');

%% (h) (2 pts) Load the image coins1.jpg. Propose and implement an approach to process the
% image and obtain a resulting binary image containing the (noisy) circle contours of the
% coins.

J = imread('coins1.jpg');
[Circle_Contour]=Detect_Coin_Contour(J);

%Display the Circle Contours of the coins
figure; imshow(Circle_Contour), title('Contours of Coins');

% The description of the approach is written in the comment part of the
% matlab funciton file: "Detect_Coin_Contour", please check it


%% (i) (2 pts) Write a function [Solution file inliers circle.m]
% - Check the function inliers circle in the directory


%% (j) (5 pts) Propose and implement a method derived from RANSAC to detect all the circles
% successively:

% Using the Matlab function "RANSAC" in the directory, the coordinates of
% detected cirlce points is stored in "CP_final"

[CP_final]= RANSAC(Circle_Contour,2);
% please check the description in the MALAB funciton : RANSAC in the
% directory


%% (k) (2 pts) Display on the image all the detected circles.

%Display the estimated 2 cirlces on the image of same size as "coin1.jpg"
%(275 x 250)
ImC=zeros(275,250);
for i = 1:60
    ImC(round(CP_final(1,i)),round(CP_final(2,i)))=1;
end
figure;imshow(ImC), title('Detected Circles');


%%