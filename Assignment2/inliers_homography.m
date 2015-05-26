function [INLm1 INLm2] = inliers_homography(H,m1,m2,D)
%initialize the inliner arrays INLm1 & INLm2
INLm1=[];
INLm2=[];

for i=1:length(m1)
% compute the algebraic distance between m2 & H*m1
m2_e(:,i) = H*m1(:,i);
m2_e(:,i) = m2_e(:,i)/m2_e(3,i);

% get teh distance value by 2-norm 
re_vector = m2(1:2,i)-m2_e(1:2,i); 
d = norm(re_vector,2);

% if the estimated "m2_e" is close to "m2" within the distance d, 
% count the point as "inlier"
 if (d  <= D)
    INLm1= [INLm1,m1(:,i)];
    INLm2= [INLm2,m2(:,i)];
 end

end 
