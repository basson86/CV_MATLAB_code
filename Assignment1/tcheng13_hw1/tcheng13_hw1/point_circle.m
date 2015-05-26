function [P] = point_circle(C,r,n);

% compute the incremental angle of each points on the circle contour 
dtheta= 2*pi/n;

for i = 1:n
    % compute the coordinate in XY plane using r and C:
    % Px= Cx + r* cos(theta)
    % Py= Cy + r* sin(theta)
    P(1,i)= C(1,1)+ r*cos(i*dtheta); 
    P(2,i)= C(2,1)+ r*sin(i*dtheta);
end
