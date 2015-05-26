%%load the image file: 'hopkins1.jpg' & 'hopkins2.jpg'  
clear all
close all
I1=imread('hopkins1.jpg');
I2=imread('hopkins2.jpg');

%% load the file containing the corresponding features
load ('hopkins_points.mat');

%% (a)Display the positions of the features in the two images
figure;
subplot(1,2,1);
imshow(I1);
hold on
plot(P1(1,:),P1(2,:),'b.','MarkerSize',15);
subplot(1,2,2);
imshow(I2);
hold on
plot(P2(1,:),P2(2,:),'b.','MarkerSize',15);

%% (c) Using the previous function to compute the fundamental matrix
pts1=P1(:,1:8);
pts2=P2(:,1:8);
[F]=computeF(pts1,pts2);


figure;
% display the 8 features in I2 first
imshow(I2);
hold on
%display in image I2 the epipolar lines corresponding to the 
%first 8 features from I1 using : l2= F' * X1
plot(P2(1,1:8),P2(2,1:8),'b.','MarkerSize',15);
for i=1:8
X1=pts1(:,i);
X1(3,:)=1;
l2=F'*X1;
hold on
hLine(l2(:,1));
end

%% (d) Display in I1 the epipolar lines corresponding to the first 8 features from I2.
figure;
imshow(I1);
hold on
% display the 8 features in I1 first
plot(P1(1,1:8),P1(2,1:8),'b.','MarkerSize',15);
%display in image I1 the epipolar lines corresponding to the 
%first 8 features from I2 using : l1= F* X2
for i=1:8
X2=pts2(:,i);
X2(3,:)=1;
l1=F*X2;
hold on
hLine(l1(:,1));
end


