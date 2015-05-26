function [m1 m2]= sift_matcher(p1,p2,d1,d2);
% setting the desired number of Matching Point Pair 
Num_Matching=50;

% building up the look-up table storing the Euclidien Distance
for i= 1:length(p1)  
 for j= 1:length(p2)
      VectorD_IJ = double(d1(:,i)-d2(:,j));     
      EuD(i,j)=norm(VectorD_IJ,2);
  end
end

% initialize arrays to store the matching point informaiton
EuD_1=EuD;
m1=zeros(2,Num_Matching);
m2=zeros(2,Num_Matching);
D1_I_list=zeros(1,Num_Matching);
D2_I_list=zeros(1,Num_Matching);


for i=1:Num_Matching
    %find the index of maximum score in the look-up table : MScore
    [D1_I,D2_I] = find(EuD_1==min(min(EuD_1)));
    D1_I=D1_I(1);
    D2_I=D2_I(1);
    %[minEuD,D1_I,D2_I] = min(min(EuD_1));
    EuD_value(:,i)=min(min(EuD_1));
    
    %Store the index of the maximum score into 2 index arrays
    D1_I_list(:,i)=D1_I;
    D2_I_list(:,i)=D2_I;
    
    % using the idex found from the look-up table, locate the point
    % index in p1 & pw, and stor them to the matching pair
    % index array m1 & m2 ,ie. I1(m1(2,i),m1(1,i)) matches I2(m2(2,i),m2(1,i))
    m1(:,i)=p1(:,D1_I);
    m2(:,i)=p2(:,D2_I); 
    
    %Once the minimum entry in EuD(i,j)_1 is pulled out, forcing the
    %value of "row i" (any matching scores resulted from "p1(i)"), and 
    % "column j" (any matching scores resulted from "p2(j)")in EuD_1 to
    % be a extremely value : "1000", so that the next searching will avoid
    % the entry due to m1(i) & m2(j), which will have been
    % matched.
    
    EuD_1(D1_I,:)=1000;
    EuD_1(:,D2_I)=1000;
       
end


% for i= 1:20
% figure(1);
% subplot(1,2,1);
% imshow(I1);hold on;
% plot(m1(1,1:i),m1(2,1:i),'rx','LineWidth',2);
% [linex1,liney1] = dsxy2figxy(gca, m1(1,i), m1(2,i));
% subplot(1,2,2);
% imshow(I2);hold on;
% plot(m2(1,1:i),m2(2,1:i),'rx','LineWidth',2);
% [linex2,liney2] = dsxy2figxy(gca, m2(1,i), m2(2,i));
% annotation(figure(1),'line',[linex1 linex2],[1-0.5*liney1-0.2 1-0.5*liney2-0.2]);
% end