function [INL] = inliers_circle(C,r,P,d)

INL=[];

for i=1:length(P)
% compute the distance to the circle

D = (P(1,i)-C(1,1))^2 + (P(2,i)-C(2,1))^2;

% if the distance is within "d" away from the circle contour, 
% count the point as "inlier"
 if (D <= (r+d)^2 && D >= (r-d)^2)
    INL= [INL,P(:,i)];
 end

end 

