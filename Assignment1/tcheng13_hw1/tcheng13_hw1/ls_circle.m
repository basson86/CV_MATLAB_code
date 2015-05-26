function [C,r]=ls_circle(P);

for i=1:length(P)
    xi=P(1,i);
    yi=P(2,i);
    A(i,:)= [xi^2+yi^2,xi,yi,1];
    % set the residual error for solving the unknown parameters 
end

% using SVD to get the smallest singular value
[U,S,V] = svd(A);

% in Y, setting the row corresponding to the smallest singular value to be 1
y= zeros(4,1);
% finding the row index "min_I" of smallest singular value
min_I= find(diag(S)== min(diag(S)));
% set the entry at row "min_I" of Y vector to be 1
% and the Y has norm = 1
y(min_I,1)=1;

% solving the least square x
x= V*y;
a=x(1,:);b1=x(2,:);b2=x(3,:);c=x(4,:);
% compute the center location C & radius r
C= [-b1/(2*a); -b2/(2*a)];
r= sqrt((b1^2+b2^2-4*a*c)/(4*a^2));