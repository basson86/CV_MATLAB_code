function [CP_final]= RANSAC(Circle_Contour,Circle_Number)
%% This function is to return the etimated coin contour points using RANSAC method.The arguments
% are the detected Circle Contour, and the Circle Number to be detected

% pull out the coordinate of white points in "Circle_Contour"
% to on the points set to be fitted (CP)
C_white = regionprops(Circle_Contour,'pixellist');
Circle_list = cat(1, C_white.PixelList);
CP= Circle_list';

% Choose the distance value d
d=20;
% number of random sampling points: Rn
Rn=25;

% Threshold value ( The number of inlier after secondary fitting)
ThrV =330;

C_list=[];
r_list=[];

%The number of reamining circle to be detected 
Rem_Cir=Circle_Number;
% logic switch for while loop ( run if the Rem_Cir >0)
do=1;

while (do)

    CP_random=[];  
    % Randomly sampling circle points on the image
    RanI = randi(length(CP),Rn,1);

for i=1:Rn
 CP_random= [CP_random,CP(:,RanI(i,1))];
end

%1) use RANSAC to detect first circle of [C_e, r_e]and the corresponding inliers; 
[C_e,r_e]=ls_circle(CP_random);
[INL1] = inliers_circle(C_e,r_e,CP,d);

%2)re-estimate the second circle parameters [C_re, r_re] using all the inliers from the 
% first circle; 
[C_re,r_re]=ls_circle(INL1);
[INL2] = inliers_circle(C_re,r_re,CP,d);

%Check if the number inlier of the "re-estimated" circle is large enough, 
% if it is higher than
 if (length(INL2) >= ThrV)
 C_list=[C_list,C_re];
 r_list=[r_list,r_re];
 Rem_Cir= Rem_Cir-1;
   
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
 
 % If the remaining circle number is zero, terminate the while loop
 if (Rem_Cir==0)
   do=0;
 end
 
 
end
 
% creating array to store all the detected circle paramter C & r
CP_final=[];

for i=1:Circle_Number  
CP_final = [CP_final, point_circle(C_list(:,i),r_list(:,i),30)];
end

