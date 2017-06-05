% Canny Edge Detector
% Set variables: sigma and thresholds
sig = 1;
mLow = 0.5;
mHigh = 2.5;

%---Read image:
img = imread('block.tif');

%{
% Gaussian filtered (this is optional, depends on the image quality):
k = 0;
while k < 5
    img = imgaussfilt(img);
    k = k+1;
end
%}
%{
%Turning RGB to Gray:
if (ndims(img)==3)
  img =rgb2gray(img);
end
img = double(img);
%}

%---SMOOTHING WITH DERIVATIVE OF GAUSSIAN:
Gau = fspecial('gaussian', [7 7], sig);
dGau = gradient(Gau);
dGau_Size = size(dGau,2);
crop = (dGau_Size-1)/2;

% On both directions: x and y
y = conv2(img, dGau,'same');
x = conv2(img, dGau','same');

% Crop off the boundary parts: the places where the convolution was partial
m = size(img,1);
n = size(img,2);
x = x(crop+1:m-crop, crop+1:n-crop);
y = y(crop+1:m-crop, crop+1:n-crop);

% Magnitude: norm of gradient
Norm = sqrt( x.^2 + y.^2 );
% Direction of gradient
Angle = atan2(y, x) * (180.0/pi);

% For divide by zero
x(x==0) = 1e-10;
Slope = abs(y ./ x);

% Obtain angles all >= 0
y = Angle < 0;
Angle = Angle + 180*y;

%---NON-MAXIMAL SUPPRESSION:
% partition the angles into 4 main directions with 45 degree in difference
Direction = [-inf 45 90 135 inf];
[~, a] = histc(Angle,Direction);
dAngle = a;
[m,n] = size(dAngle);

% Set boundary pixels to 0
dAngle(1,:) = 0;
dAngle(end,:)=0;
dAngle(:,1) = 0;
dAngle(:,end) = 0;

edgePoint = zeros(m,n);
result = edgePoint;
low  = mLow * mean(Norm(:));
high = mHigh * low;
thresh = [low high];

% Each pixel is set to either 1,2,3,or 4, find maximum for each window:
% 1. Gradient direction: 0-45
gDir = 1;
i = find(dAngle == gDir);
slp = Slope(i);

% (1,1) and (1,0)
gDiff1 = slp.*(Norm(i)-Norm(i+m+1)) + (1-slp).*(Norm(i)-Norm(i+1));
% (-1,-1) and (-1,0)
gDiff2 = slp.*(Norm(i)-Norm(i-m-1)) + (1-slp).*(Norm(i)-Norm(i-1));

edge = i( gDiff1 >= 0 & gDiff2 >= 0);
edgePoint(edge) = 1;

%----------------------------------------------------
% 2. Gradient direction: 45-90
gDir = 2;
i = find(dAngle == gDir);
invSlp = 1 ./ Slope(i);

% (1,1) and (0,1)
gDiff1 = invSlp.*(Norm(i)-Norm(i+m+1)) + (1-invSlp).*(Norm(i)-Norm(i+m));
% (-1,-1) and (0,-1)
gDiff2 = invSlp.*(Norm(i)-Norm(i-m-1)) + (1-invSlp).*(Norm(i)-Norm(i-m));

edge = i( gDiff1 >=0 & gDiff2 >= 0);
edgePoint(edge) = 1;

%----------------------------------------------------
% 3. Gradient direction: 90-135
gDir = 3;
i = find(dAngle == gDir);
invSlp = 1 ./ Slope(i);

% (-1,1) and (0,1)
gDiff1 =   invSlp.*(Norm(i)-Norm(i+m-1)) + (1-invSlp).*(Norm(i)-Norm(i+m));
% (1,-1) and (0,-1)
gDiff2 =   invSlp.*(Norm(i)-Norm(i-m+1)) + (1-invSlp).*(Norm(i)-Norm(i-m));

edge = i( gDiff1 >=0 & gDiff2 >= 0);
edgePoint(edge) = 1;

%----------------------------------------------------
% 4. Gradient direction: 135-180
gDir = 4;
i = find(dAngle == gDir);
slp = Slope(i);

% (-1,1) and (-1,0)
gDiff1 = slp.*(Norm(i)-Norm(i+m-1)) + (1-slp).*(Norm(i)-Norm(i-1));
% (1,-1) and (1,0)
gDiff2 = slp.*(Norm(i)-Norm(i-m+1)) + (1-slp).*(Norm(i)-Norm(i+1));

edge = i( gDiff1 >=0 & gDiff2 >= 0);
edgePoint(edge) = 1;


%---HYSTERESIS THRESHOLDING:
% Find pixels lower then Low threshold and higher than High threshold
edgePoint = edgePoint*0.6;
x = find(edgePoint > 0 & Norm < low);
edgePoint(x)=0;
x = find(edgePoint > 0 & Norm  >= high);
edgePoint(x)=1;

% Find all pixels that's connected to High threshold ones but not
% below Low threshold, add 0.4 to then so as to mark edges
xx = [];
x = find(edgePoint == 1);
while (size(xx,1) ~= size(x,1))
  xx = x;
  neighbour = [x+m+1, x+m, x+m-1, x-1, x-m-1, x-m, x-m+1, x+1];
  edgePoint(neighbour) = 0.4 + edgePoint(neighbour);
  y = find(edgePoint == 0.4);
  edgePoint(y) = 0;
  y = find(edgePoint >= 1);
  edgePoint(y) = 1;
  x = find(edgePoint == 1);
end

x = find(edgePoint == 1);
result(x)=1;

%---Ploting the result:
subplot(121), imagesc(img), title('Original image');
subplot(122), imagesc(result), title('Canny edge detector result'), colormap(gray);

