function [m1,m2] = match_corners_NCC_old(I1,I2,corners1,corners2,ws);

J1 = rgb2gray(I1);
J2 = rgb2gray(I2);

J1d= double (J1);
J2d= double (J2);

m1= corners1;
C2= corners2;

for i= 1:length(m1);
 P1=J1d(m1(1,i)-ws:m1(1,i)+ws,m1(2,i)-ws:m1(2,i)+ws);
 
 maxC=-1000;    
 
 for j= 1:length(C2);
      P2=J2d(C2(1,j)-ws:C2(1,j)+ws,C2(2,j)-ws:C2(2,j)+ws);    
      
      P1m=P1-mean(mean(P1));
      P2m=P2-mean(mean(P2));
      
      C= sum(sum(P1m.*P2m))/(sqrt(sum(sum(P1m.^2)))*sqrt(sum(sum(P1m.^2))));
      
      if (C >= maxC);
          mj(:,i)=j;
          maxC=C;
          m2(:,i)=C2(:,j);
          
      end
  end
  Cmax(:,i)=maxC;
  C2(:,mj(:,i))=[];
end


