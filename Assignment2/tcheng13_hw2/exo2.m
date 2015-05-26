clear all;
close all;
%%
%load the floor image
I = imread('floor.jpg');
J = rgb2gray(I);

%% (d) implement the function "map_to_infinity(I)"
% please select the points in the counter-clockwise direction
[H] = map_to_infinity(J);

%% (e) display the backwaping image using the funcion in (d)

% (x,y) is the pixel coordinate in the rectified image frame
for x= 1:480
    for y= 1:360

% transform the coordinate from "rectified image " to the original image
% using inverse of H 
x_m= inv(H)*[x;y;1];
x_m = x_m/x_m(3);

% for the coordinate (x,y) in rectified image, build up a look-up table JX & JY 
% to determine the coordinate of pixel to trace back in the original image

% if the back-mapped coordinate is out of the range of size, arbituarily store
% the coordinate of a single pixel (1,1)   
if (x_m(1)<1 || x_m(2)<1 || x_m(1)>480 || x_m(2)>360 )
JX(y,x)= 1;
JY(y,x)= 1;
else
JX(y,x)= x_m(1);
JY(y,x)= x_m(2);
end

    end
end

% convert the original uint8 image J to double for 2D interpolation
J_d= double(J);

%% Based on J_d, interpolate the image using meshgrid JX & JY to
% obtain JI
JI = interp2(J_d,JX,JY);
JI=uint8(JI);

% display JI
figure;
subplot(1,2,1);
imshow(J);
subplot(1,2,2);
imshow(JI);

