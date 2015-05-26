%% 
%(h) (2 pts) Load the image coins1.jpg. Propose and implement an approach to process 
% the image and obtain a resulting binary image containing the (noisy) circle contours of the
% coins.

%Convert the image to gray scale
clear all;
close all;
J = imread('coins2.jpg');
Coin= rgb2gray(J);
figure;imshow(Coin);

%% Detect the edge using Sobel operator 
[junk threshold] = edge(Coin, 'sobel');
fudgeFactor = .5;
BWs = edge(Coin,'sobel', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');

%% Dilate the image 
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');

%% Fill interior gap
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');

close all;
%% Display the Circle Contours of the coins
Circle_Contour = bwperim(BWdfill);
figure, imshow(Circle_Contour), title('outlined image');

%%
%(j) (5 pts) Propose and implement a method derived from RANSAC to detect all the circles
%successively: 


% the list of points on the circle contour
C_white = regionprops(Circle_Contour,'pixellist');
Circle_list = cat(1, C_white.PixelList);
CP= Circle_list';

d=10;
Rn=40;
do=1;

Circle_Number=0;
C_list=[];
r_list=[];
while (do)

    CP_random=[];  
    RanI = randi(length(CP),Rn,1);

for i=1:Rn
 CP_random= [CP_random,CP(:,RanI(i,1))];
end

%1) use RANSAC to detect one circle and the corresponding inliers; 
[C_e,r_e]=ls_circle(CP_random);
[INL1] = inliers_circle(C_e,r_e,CP,d);

%2)re-estimate the circle parameters using all the inliers; 
[C_re,r_re]=ls_circle(INL1);
[INL2] = inliers_circle(C_re,r_re,CP,d);

 if (length(INL2) >= 100)
 C_list=[C_list,C_re];
 r_list=[r_list,r_re];
 Circle_Number= Circle_Number +1;
   
   %3)remove the inliers of this circle from the list of image points;
   for j=1:length(INL2) 
      for k=1:length(CP)-1
          if (CP(:,k)==INL2(:,j))
          CP(:,k)=[];
          end
      end 
   end 
   
  
 end
 length(INL2)
 if (length(CP)<10)
   do=0;
 end
 
 
end
 


CP_final=[];

for i=1:Circle_Number
    
CP_final = [CP_final, point_circle(C_list(:,i),r_list(:,i),30)];

end


ImC=zeros(275,250);

for i = 1:Circle_Number*30
    if (round(CP_final(1,i))>=0 && round(CP_final(2,i))>=0)
    ImC(round(CP_final(1,i)),round(CP_final(2,i)))=1;
    end
end

figure;imshow(ImC), title('outlined image');


%Describe how you choose your thresholds.
