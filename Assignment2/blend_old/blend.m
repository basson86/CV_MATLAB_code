function [K] = blend(I1,I2,H)
% close all;
% clear all;
% I1 = imread('hopkins1.jpg');
% I2 = imread('hopkins2.jpg');
%H= [2.77395186131701,-15.5224366300710,4241.65970628572;1.26207625736412,-7.01279356510903,1897.48455332718;0.00425898954382322,-0.0235418691940917,6.42660649764056;];
%H=[0.5 0.5 1; 0.5 1 10; 0 0 1];


%%
%Convert the image from rgb to gray value
I1 = rgb2gray(I1);
I2 = rgb2gray(I2);

%%
%Convert the image of the precision of double 
I1=double(I1);
I2=double(I2);

%% Get the size of the image K based on the corner coordinates of I2 
%when converted to I1
[m1, n1]=size(I1);
[m2, n2]=size(I2);

% Convert the corner coordinate of I2 to I1 using H
Corner_m2t1= H*[n2;m2;1];
Corner_m2t1=Corner_m2t1/Corner_m2t1(3);

mK21=Corner_m2t1(2);
nK21=Corner_m2t1(1);

% determine the size of K by comparing the corner coordinate of I1 & I2 transformed to I1 
mK= max(mK21, m1);
nK= max(nK21, n1);

%% K1: the image of same size to K for storing the intensity of I1
K1=zeros(mK,nK);

%% an 2D array OL_p used to mark the coordinate of overlapping region
OL_p=ones(mK,nK);

%% in K, iterate each pixel coordinate to get the corresponding point in I1 & I2 transformed to K
for y_k=1:mK
    for x_k= 1:nK        
        
% logic symbol used to check if the current coordinate (x_k,y_k) belongs to I1 region  
I1_in=0;
 
 %If current point (x_k,y_k) belongs to I1, put the value of I1 to K1
 %first, and set the logic symbol: "I1_in = 1"
 if (y_k <=m1 && x_k <=n1)
 K1(y_k,x_k)= I1(y_k,x_k);        
 I1_in=1;
 end

 %Transform the current coordinate (x_k,y_k) in K to I2 using 
 %"the inverse of H"
 X_2= inv(H)*[x_k;y_k;1];
 X_2=X_2/X_2(3);

 %% If current point (x_k,y_k) dose lies in the valid range in I2, store the 
 % coordinate in I2 as the meshgrid variable : x_2 and y_2; 
  
  % If current point (x_k,y_k) dose NOT lies in the valid range in I2, store
  % the coordinate of a pixel of "0" value in I2 to the x_2 and y_2 
  if ((X_2(1)<1 || X_2(2)<1 || X_2(1)>n2 || X_2(2)>m2 ))
  x_2(y_k,x_k) = 792;        
  y_2(y_k,x_k)=  401;
  else
  x_2(y_k,x_k) = X_2(1);
  y_2(y_k,x_k)=  X_2(2);
  % If the point also belongs to I1 (I1_in==1), mark the current point as
  % the overlapping region, and set the corresonding index in "OL_p" to 0.5
    if (I1_in==1)
    OL_p(y_k,x_k)=0.5;
    end
    
  end
  
  
    end
end

%% Interpolate the intensity in I2 and map it to K2 (same size of K) using 
% 2D interpolation
K2 = interp2(I2,x_2,y_2);

%% Sum up the 2D array K1 & K2 into Ksum,
% and mupliply it with the OL_p to get the mean value 
% for the overlapping region,and then get the desired K
Ksum=K1+K2;
K=Ksum.* OL_p;

%% Display the resulting image K1, K2 and K
figure;
subplot(1,2,1);
imagesc(K1);
subplot(1,2,2);
imagesc(K2);
figure;
K=uint8(K);
imshow(K);


%% old code
% for y=1:m2
%     for x= 1:n2        
% X_2t1= H*[x;y;1];
% X_2t1=X_2t1/X_2t1(3);
% 
% x2_1(y,x)=X_2t1(1);
% y2_1(y,x)=X_2t1(2);
%     end
% end
% 
% mK = max(max(y2_1));
% nK = max(max(x2_1));

% for y_k=1:mK
%     for x_k= 1:nK        
% 
% %put the value of I1 to K1 first
% if (y_k <=m1 && x_k <=n1)
% K1(y_k,x_k)= I1(y_k,x_k);        
% end
% 
% X_2= inv(H)*[x_k;y_k;1];
% X_2=X_2/X_2(3);
% 
% if ((X_2(1)<1 || X_2(2)<1 || X_2(1)>n2 || X_2(2)>m2 ))
% x_2(y_k,x_k) = 792;        
% y_2(y_k,x_k)=  401;
% else
% x_2(y_k,x_k) = X_2(1);
% y_2(y_k,x_k)=  X_2(2);
% end
% 
%     end
% end

