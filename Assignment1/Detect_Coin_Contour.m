function [Circle_Contour] = Detect_Coin_Contour(J);
%% In this funciton, the method to detect the coin coutour is proposed and implemented:

% There are 4 basic steps for this approach:
% Step 1: Convertion to Grayscale
% Step 2: Edge detection using Soble operation
% Step 3: Image Dialation
% Step 4: Filling Interior Gaps
% Step 5: Finding the perimeter in binary image

%% Step 1: Convertion to Grayscale
% We first convert the 'coin1.jpg' image to gray scale for image processing
Coin= rgb2gray(J);
figure;subplot(2,2,1);imshow(Coin);title('gray scale image');


%% Step 2: Edge detection using Soble operation 
% In the 2nd Step, we applied the edge detection method: Sobel method,
% which is based on the gradient of image. First, we used edge and the Sobel 
% operator to calculate the threshold value, then we tuned the threshold 
% value and use edge again to obtain a binary mask, which will be used to
% dilate the image in the next step

[junk threshold] = edge(Coin, 'sobel');
fudgeFactor = .5;
BWs = edge(Coin,'sobel', threshold * fudgeFactor);
subplot(2,2,2), imshow(BWs), title('binary gradient mask');

%% Step 3: Image Dialation
% The binary gradient mask shows lines of high contrast in the image. These lines
% do not quite delineate the outline of coins. 
% To eliminate the gaps surrounding the coin in the gradient mask, we used
% "strel" function to dilate the image using linear structuring elements

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90 se0]);
subplot(2,2,3), imshow(BWsdil), title('dilated gradient mask');

%% Step 4: Filling Interior Gaps
% After the dilation step, there are still holes in the interior of coins. 
% To fill these holes we use the imfill function to get "filled" object in
% the binary image, which can be used to determine the contours.
BWdfill = imfill(BWsdil, 'holes');
subplot(2,2,4), imshow(BWdfill);
title('binary image with filled holes');

%% Step 5: Finding the perimeter in binary image
% After filling the image, based on the intact objects in the binary image,
% finally we used the function: 'bwperim' to find the perimeter, which
% represents the contours of coins.

Circle_Contour = bwperim(BWdfill);


