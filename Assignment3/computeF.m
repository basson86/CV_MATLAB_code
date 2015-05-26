function [F]=computeF(pts1,pts2);

% find the associated fundamental matrix using the 8-points algorithm
W=[];
for i = 1: length(pts1);  
ui=pts1(1,i);vi=pts1(2,i);   
ui_p=pts2(1,i);vi_p=pts2(2,i); 

Wi=[ui*ui_p ui*vi_p ui vi*ui_p vi*vi_p vi ui_p vi_p 1]; 
W= cat(1,W,Wi);
end

%get the SVD of matrix W
[U,S,V]  =svd(W);
% f is the last row of V
f_n= V(:,9);

% Assemble the homography matrix H_n for normalized points pts1 & pts2
F= [f_n(1:3,:)';f_n(4:6,:)';f_n(7:9,:)'];