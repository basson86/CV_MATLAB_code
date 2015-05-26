%function [m1,m2] = match_corners_NCC_m(I1,I2,corners1,corners2,ws);
clear all
close all
ws=10;

I1 = imread('building1.bmp');
I2 = imread('building2.bmp');

J1 = rgb2gray(I1);
J2 = rgb2gray(I2);

[corners1, quality] = harrisCorner(J1);
[corners2, quality] = harrisCorner(J2);

J1d= double (J1);
J2d= double (J2);

m1= corners1;
C2= corners2;

MaxDist= 60;

for i= 1:30%length(m1);
 P1=J1d(m1(1,i)-ws:m1(1,i)+ws,m1(2,i)-ws:m1(2,i)+ws);
 
 maxC=-100;    
 
 for j= 1:length(C2);
      P2=J2d(C2(1,j)-ws:C2(1,j)+ws,C2(2,j)-ws:C2(2,j)+ws);    
      
      Dist= sqrt((m1(1,i)-C2(1,j))^2+ (m1(2,i)-C2(2,j))^2);
      
      
      P1m=P1-mean(mean(P1));
      P2m=P2-mean(mean(P2));
      
      C= sum(sum(P1m.*P2m))/(sqrt(sum(sum(P1m.^2)))*sqrt(sum(sum(P1m.^2))));

      if (Dist <= MaxDist);
          if (C >= maxC)
          mj(:,i)=j;
          maxC=C;
          m2(:,i)=C2(:,j);
          end
      end
 end
 
 C2(:,mj(:,i))=[];

 Cmax(:,i)=maxC;
  end

% figure;
% subplot(1,2,1);
% imshow(J1);hold on;
% plot(corners1(2,:),corners1(1,:),'x','LineWidth',3);
% subplot(1,2,2);
% imshow(J2);hold on;
% plot(corners2(2,:),corners2(1,:),'x','LineWidth',3);
          

figure;
for i= 1:20
subplot(1,2,1);
imshow(J1);hold on;
plot(m1(2,1:i),m1(1,1:i),'x','LineWidth',4);
subplot(1,2,2);
imshow(J2);hold on;
plot(m2(2,1:i),m2(1,1:i),'x','LineWidth',4);
end
