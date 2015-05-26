function [P] = noisy_points_circle(C,r,n,sig);

% compute the incremental angle 
dtheta= 2*pi/n;

for i = 1:n
    X_noise = random('Normal',0,sig);
    Y_noise = random('Normal',0,sig);
    P(1,i)= C(1,1)+ r*cos(i*dtheta)+X_noise; 
    P(2,i)= C(2,1)+ r*sin(i*dtheta)+Y_noise;
end
