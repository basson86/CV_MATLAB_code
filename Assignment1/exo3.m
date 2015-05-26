clear all;
close all;
%% 
%(a) (2 pts) Load the two images building1.bmp and building2.bmp.
% Load image
I1 = imread('building1.bmp');
I2 = imread('building2.bmp');

%convert the images to gray level
J1 = rgb2gray(I1);
J2 = rgb2gray(I2);

% get corners coornidates from I1 & I2 using Harris detector
[Corners1, quality] = harrisCorner(J1);
[Corners2, quality] = harrisCorner(J2);

% display the corners on the two images
figure(1);
subplot(1,2,1);
imshow(J1);hold on;
plot(Corners1(2,:),Corners1(1,:),'x','LineWidth',3);
subplot(1,2,2);
imshow(J2);hold on;
plot(Corners2(2,:),Corners2(1,:),'x','LineWidth',3);


%%
%(b)(5 pts) Implement a function : Solution file match_corners_NCC.m]
ws=10;   %chosenwindow size

% apply the NCC function to find the matching pairs of the corner points
[m1,m2] = match_corners_NCC(I1,I2,Corners1,Corners2,ws);


%%
%(c) (3 pts) Display the images side-by-side within one figure and draw lines between the
%matched corners to evaluate visually the results using a chosen window size.
figure(2);
for i= 1:30
subplot(1,2,1);
imshow(J1);hold on;
plot(m1(2,1:i),m1(1,1:i),'x','LineWidth',2);
subplot(1,2,2);
imshow(J2);hold on;
plot(m2(2,1:i),m2(1,1:i),'x','LineWidth',2);
% Line-drawing command ( the location of line might be translated because of
% various screen size, but the orientation of lines will not be influenced)
annotation(figure(2),'line',[0.133928571428571+((m1(2,i))/604)*0.3320 0.571428571428571+ ((m2(2,i))/604)*0.3320],...
[0.282842794759825+((454-m1(1,i))/454)*0.4653 0.282842794759825+((454-m2(1,i))/454)*0.4653]);
end



%%
%(d) (4 pts) Modify the previous function to weight the NCC score by a factor depending on
%the spatial distance between the two compared corners. This should exclude corners far
%from each other in order to reduce the number of incorrect matches, since the displace-
%ment between the two images is small. Enforce also symmetry during the matching: select two corners c1 and c2 if and only if
%c1 is the best match for c2 and c2 is the best match for c1.

ws=10; %window size
[m1_m,m2_m] = match_corners_NCC_modified(I1,I2,Corners1,Corners2,ws);

%Display the matching points pair by drawing lines between 2 pictures
figure(3);
for i= 1:50
subplot(1,2,1);
imshow(J1);hold on;
plot(m1_m(2,1:i),m1_m(1,1:i),'rx','LineWidth',2);
subplot(1,2,2);
imshow(J2);hold on;
plot(m2_m(2,1:i),m2_m(1,1:i),'rx','LineWidth',2);
% Line-drawing command ( the location of line might be translated because of
% various screen size, but the orientation of lines will not be influenced)
annotation(figure(3),'line',[0.133928571428571+((m1_m(2,i))/604)*0.3320 0.571428571428571+ ((m2_m(2,i))/604)*0.3320],...
[0.282842794759825+((454-m1_m(1,i))/454)*0.4653 0.282842794759825+((454-m2_m(1,i))/454)*0.4653]);
end


