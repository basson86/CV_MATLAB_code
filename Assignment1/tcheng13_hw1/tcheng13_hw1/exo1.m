close all;
clear all;

%%
%(a) (1 pts) Load the image lena.jpg and convert it to a greyscale image, called J in the
%following.
I = imread('lena.jpg');
J = rgb2gray(I);
%figure;imshow(J);

%%
%(b) Let gh(sigma) be a Gaussian filter of size [3sigma,1], gv(sigma) be a Gaussian filter of size [1,3sigma] and
%gr(sigma) be a Gaussian filter of size [3sigma,3sigma]. 
sigma=2;
grsize=[3*sigma,3*sigma];
ghsize=[3*sigma,1];
gvsize=[1,3*sigma];

% i. (2 pts) Convolve the image J it with gr(2), using the matlab function conv2. [Method M1]
gr=fspecial('gaussian', grsize, sigma);
I1 = conv2(J,gr);

% ii. (2 pts) Convolve the image J successively with gh(2) and gv(2). [Method M2]
gh=fspecial('gaussian', ghsize, sigma);
gv=fspecial('gaussian', gvsize, sigma);

% convolve the image successively
I2 = conv2(conv2(J,gh),gv);


% iii.; (2 pts) Convolve the image J with gh(2) x gv(2). [Method M3]
I3 = conv2(J,gh*gv); % gh(2) x gv(2)


% iv. (2 pts) Compare the results visually. What do you conclude ?
figure;
subplot(1,3,1);
imagesc(I1);colormap gray;
title('convolved with gr');
subplot(1,3,2);
imagesc(I2);colormap gray;
title('convolved with gh and gv');
subplot(1,3,3);
imagesc(I3);colormap gray;
title('convolved with gh x gv');

%*Conclusion : 
% The difference of the 3 images can hardly be distinguished
% visually, which means the effects of convolving with gr(2), gh(2) and 
% gv(2), and gh(2) x gv(2) are equivalent, since gr(2) = gh (2) x gv(2), 
% we can conclude that the operation of gaussiaon filters is "associative"  



%%
%(c) (3 pts) Compare the resulting images using the mean of the square
%differences (sx x sy is the size of the image):

e12=I1-I2;
e23=I2-I3;
e13=I1-I3;

mse12=sum(sum((I1-I2).^2))/(length(J)^2); % mean of square difference between I1 & I2
mse23=sum(sum((I2-I3).^2))/(length(J)^2); % mean of square difference between I2 & I3
mse13=sum(sum((I1-I3).^2))/(length(J)^2); % mean of square difference between I1 & I3

%*Conclusion: 
%It can be observed that the maximum difference between 2 pixels is of the order of 10^-13, and  maximum mean square difference 
%is of the order of 10^-28, which is tiny enough to be ignored. These tiny difference is likely due to the numerical operation 
%during the compuating process.


%% (d) (4 pts) Compare the speed of methods [M1] and [M2] for sigma= {1......10}. Plot together
% the computation times for each method with respect to sigma (Hint: check the matlab functions 
% tic and toc)

M1Time= zeros(10,1);
M2Time= zeros(10,1);

% applying the gaussian filter using incremental sigma = 1 - 10 
for s=1:10;
    
gr_c=fspecial('gaussian', grsize, s);
gh_c=fspecial('gaussian', ghsize, s);
gv_c=fspecial('gaussian', gvsize, s);

%computational time for M1
tic
I1 = conv2(J,gr_c);
t1=toc;
M1Time(s,1)=t1;
%computational time for M2
tic
I2 = conv2(conv2(J,gh_c),gv_c);
t2=toc;
M2Time(s,1)=t2;
end

% plot the computational time for M1 & M2 together
figure; plot(M1Time(:,1),'rs-');
hold on;
plot(M2Time(:,1),'b-o');
legend('M1','M2');
grid on;
xlabel('sigma');
ylabel('computational time (seconds) using "conv2"');

%*Conclusion: From figure 2, it can be observed that overally, 
% M1 slightly runs faster than M2, and both M1 & M2 take longer time when the sigma =1,
%but as sigma goes higher than 2, the computaional time does not change
%significantly.


%%
%(e)What do you conclude from the previous two experiments?
% From the previous experiments, we can conclude that the effects of applying M1 and M2 
% to the image is almost equvalent, and when the sigma is larger than 1, the compuational speed does not
% depend highly on the sigma value.


%%
%(f) (600.461 only) 
%i. (2 pts) Perform the same experiment using the matlab function "imfilter"
F1 = imfilter(J, gr);
F2 = imfilter(imfilter(J, gh), gv);
F3 = imfilter(J, gh*gv);

% display the image after processed by "imfilter"
figure;
subplot(1,3,1);
imshow(F1);title('convolved with gr')
subplot(1,3,2);
imshow(F2);title('convolved with gh and gv');
subplot(1,3,3);
imshow(F3);title('convolved with gh x gv');

%%
%ii. (3 pts) What is the result concerning the computation times ? 
M1TimeF= zeros(10,1);
M2TimeF= zeros(10,1);
for s=1:10;
    
gr_f=fspecial('gaussian', grsize, s);
gh_f=fspecial('gaussian', ghsize, s);
gv_f=fspecial('gaussian', gvsize, s);

%computational time for M1
tic
I1 = imfilter(J,gr_f);
t1=toc;
M1TimeF(s,1)=t1;
%computational time for M2
tic
I2 = imfilter(imfilter(J,gh_f),gv_f);
t2=toc;
M2TimeF(s,1)=t2;
end

% plot the compuational time vs sigma
figure; plot(M1TimeF(:,1),'rs-');
hold on;
plot(M2TimeF(:,1),'b-o');
legend('M1','M2');
grid on;
xlabel('sigma');
ylabel('computational time (seconds) using "imfilter"');


% Can you explain the difference, compared to conv2?
% *Answer: As compared to conv2, from figure 3 and figure 4, we can observe that the difference in terms of 
% computational time between M1 and M2 is more apparent, M1 still runs faster than M2, and the overall speed 
% when applying "imfilter" is faster than "conv2". The difference is likely because the "imfilter" is operated 
% in the frequency domain, which is more computationally efficient than "conv2", which involve the convolution 
% operation in the spatial domain

