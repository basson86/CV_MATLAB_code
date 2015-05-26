function [H]=RANSAC_ndlt(m1,m2);
% change m1 & m2 to homogeneous coordinate
m1(3,:)=1;
m2(3,:)=1;

%%
%choosing the number N for inliner number when the
%Homography H from RANSAC is to be accpeted
N=40;
% choose the number of random sampling 
Rn=5;
% choose the threshol distand D for inliner criterion
D=1.3;
% initialized the number of final inliner n_I=0
n_I=20;

%iternation number counter
InT=0;

%% the while loop doing the RANSAC
while (n_I < N)
    
% initialize the sampling point pairs data set from m1 & m2 
m1_sample=[];
m2_sample=[];

% Randomly sampling point pairs from m1 & m2
RanI = randi(length(m1),Rn,1);
for i=1:Rn
 m1_sample= [m1_sample,m1(:,RanI(i))];
 m2_sample= [m2_sample,m2(:,RanI(i))];
end

%% obtain the preliminary estimation of homography H0 using the random-sampled point pairs
[H0]=homography_ndlt(m1_sample,m2_sample);

%  get the first inliner points : INLm1 & INLm2 by the function
% "inliers_homography(H0,m1,m2,D)"
[INLm1 INLm2] = inliers_homography(H0,m1,m2,D);

% if the inliner number is less than the beginning sampled pairs number,
% use the sampled pairs as the inliners
if (length(INLm1)<Rn)
INLm1= m1_sample;    
INLm2= m2_sample;
end
    
%% re-estimate H using inline points INLm1 & INLm2,
[H]=homography_ndlt(INLm1,INLm2);
% re-count the number of inliner when H is applied
[INLm1_r INLm2_r] = inliers_homography(H,m1,m2,D);

%% calculate the number of the inliner to the re-estimated Homography H
n_I=length(INLm1_r)%

% count the total number of iteration
InT=InT+1;
end



