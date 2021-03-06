%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Harris corner Detector
%  modified by Jana Kosecka, George Mason University
%  last modified, November 2001 (making the local search more efficient)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [D, quality] = harrisCorner(I)

[ydim, xdim] = size(I);

blur    = [1 6 15 20 15 6 1];
blur    = blur / sum(blur);
prefilt = [0.223755 0.552490 0.223755];
derivfilt = [-0.453014 0 0.45301];
fx     = conv2( conv2( I, prefilt', 'same' ), derivfilt, 'same' );
fy     = conv2( conv2( I, prefilt, 'same' ), derivfilt', 'same' );
fx2    = conv2( conv2( fx .* fx, blur', 'same' ), blur, 'same' );
fy2    = conv2( conv2( fy .* fy, blur', 'same' ), blur, 'same' );
fxy    = conv2( conv2( fx .* fy, blur', 'same' ), blur, 'same' );

m = (fx2 + fy2 ) / 2;
d = fx2 .* fy2 - fxy .^ 2;
n = sqrt(m .^ 2 - d);

quality = min(abs(m - n),abs(m + n));


thresh = 0.05;  % 0.005;  
border = 20;    % do not consider the boundary pixels  

q = quality;


q(1:border,:) = zeros(border,xdim);
q(ydim-border+1:ydim,:) = zeros(border,xdim);
q(:,1:border) = zeros(ydim,border);
q(:,xdim-border+1:xdim) = zeros(ydim,border);

% imagesc(q); colormap gray; pause; close 
maxq = max(max(q));
    
thq = thresh*maxq;
Q = (q > thq) & (LocalMaximum(q));

% max. selected features in selection
Nmax = 1000;                            
i = find(Q(:));

%disp('Local max computation...')

[Y,I] = sort(-q(i));

if (size(Y,1)>Nmax),
	Y = Y(1:Nmax);
	I = I(1:Nmax);
end;

% keyboard;

C = ceil(i(I)/ydim);
R = rem(i(I)-1,ydim)+1;

CC = C * ones(1,size(C,1));
RR = R * ones(1,size(R,1));

spacing = 10;		              %% min spacing between 2 feats (in pixel).
D2 = (CC - CC').^2 + (RR-RR').^2; %% matrix of square distances between features
D2_mod = tril(D2-spacing^2,-1);	  %% take the lower-triangle

good_features = ~sum(D2_mod'<0);  %% if the sum is 0 it is a good feature
indexgood = find(good_features);



%keyboard;

featR = R(indexgood);
featC = C(indexgood);

xtt = [featR,featC]';

indxtt = (xtt(2,:)-1)*ydim + xtt(1,:);
qxtt = q(indxtt);

D = xtt;

%Written by Hailin Jin and Paolo Favaro
%Copyright (c) Washington University, 2001
%All rights reserved
%Last updated 10/18/2001
function  [maxima] = LocalMaximum(image)
%
% LOCALMAX	Finds local maxima of image
%
%	[maxima,i,j] = LocalMax(image)
%
%	outputs array maxima of zeros and ones with ones
%	at maxima position (Extended to 9 points by JYB)

[m,n] = size(image);
center_cols = [1:n];
center_rows = [1:m];
left = [2:n n];
right = [1 1:n-1];
top = [2:m m];
bot = [1 1:m-1];
maxima = ( ( (image(center_rows,center_cols) > image(center_rows,left)) & ...
	(image(center_rows,center_cols) > image(center_rows,right)) & ... 
	(image(center_rows,center_cols) > image(top,center_cols)) & ...
	(image(center_rows,center_cols) > image(bot,center_cols)) & ...
	(image(center_rows,center_cols) > image(top,left)) & ...
	(image(center_rows,center_cols) > image(top,right)) & ...
	(image(center_rows,center_cols) > image(bot,left)) & ...
	(image(center_rows,center_cols) > image(bot,right))));


