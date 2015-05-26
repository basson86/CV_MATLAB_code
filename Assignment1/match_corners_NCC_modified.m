function [m1,m2] = match_corners_NCC_modified(I1,I2,corners1,corners2,ws);
%%convert the images to gray level
J1 = rgb2gray(I1);
J2 = rgb2gray(I2);

%convert the gray images to double precision
J1d= double (J1);
J2d= double (J2);

% get the corners' coordinate for compuation
C1= corners1;
C2= corners2;

% setting the desired number of Matching Point Pair
Num_Matching=200;
    

% building up the look-up table storing the matching score
for i= 1:Num_Matching
 %Intensity of corner 1   
 P1=J1d(C1(1,i)-ws:C1(1,i)+ws,C1(2,i)-ws:C1(2,i)+ws);
 
 for j= 1:Num_Matching
 
       %Intensity of corner 2
      P2=J2d(C2(1,j)-ws:C2(1,j)+ws,C2(2,j)-ws:C2(2,j)+ws);    
      
      % Compute the distance as a factor to compute "matching score" 
      Dist= sqrt((C1(1,i)-C2(1,j))^2+ (C1(2,i)-C2(2,j))^2);
      
      % Normalized Cross-corrleaiton formula
      P1m=P1-mean(mean(P1));
      P2m=P2-mean(mean(P2));
       % Cross-correlation coefficient
      C= sum(sum(P1m.*P2m))/(sqrt(sum(sum(P1m.^2)))*sqrt(sum(sum(P1m.^2))));
 
      
      % storing the score value, which include both Cross-correlation & distance value 
      MScore(i,j)= C + 1.5/Dist;
            
  end
end
% initialize arrays to store the matching point informaiton
MScore_1=MScore;
m1=zeros(2,Num_Matching);
m2=zeros(2,Num_Matching);
C1_I_list=zeros(1,Num_Matching);
C2_I_list=zeros(1,Num_Matching);

for i=1:Num_Matching
    %find the index of maximum score in the look-up table : MScore
    [C1_I,C2_I] = find(MScore_1==max(max(MScore_1)));
    %Store the index of the maximum score into 2 index arrays
    C1_I_list(:,i)=C1_I;
    C2_I_list(:,i)=C2_I;
    % using the idex found from the look-up table, locate the point
    % index in Corners1 and Corners2, and stor them to the matching pair
    % index array m1 & m2 ,ie. I1(m1(2,i),m1(1,i)) matches I2(m2(2,i),m2(1,i))
    m1(:,i)=C1(:,C1_I);
    m2(:,i)=C2(:,C2_I); 
    
    %Once the maximum entry in MScore(i,j) is pulled out, forcing the
    %value of "row i" (any matching scores resulted from "Corner1(i)"), and 
    % "column j" (any matching scores resulted from "Corner2(j)")in MScore to
    % be a extremely value : "-1000", so that the next searching will avoid
    % the entry due to corner1(i) & corner2(j), which will have been
    % matched.
    
    MScore_1(C1_I,:)=-1000;
    MScore_1(:,C2_I)=-1000;
    
end     
         
