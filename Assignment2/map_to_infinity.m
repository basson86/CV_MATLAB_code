function [H] = map_to_infinity(I) 
%%
%display the image for manual selection
imshow(I);
[x,y] = ginput(4);


%% change the selected image coordinate to homogeneous coordinate 
P1= [x(1);y(1);1];
P2= [x(2);y(2);1];
P3= [x(3);y(3);1];
P4= [x(4);y(4);1];

%% compute the vanishing points v1 & v2 using the cross product  P1-P4
% v1= (P2 x P1) x (P3 x P4)
% v2= (P2 x P3) x (P1 x P4)
v1= cross(cross(P2,P1),cross(P3,P4));
v2= cross(cross(P2,P3),cross(P1,P4));

v1=v1/v1(3);
v2=v2/v2(3);
%% compute the line vector in the image by v1 x v2
l= cross(v2,v1);
l=l/l(3);
%% compute the H transforming from l to l infinity 
H= [1,0,0;0,1,0;l(1),l(2),l(3)];

close all;