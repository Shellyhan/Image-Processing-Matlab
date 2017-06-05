% Linear Stretching of image histogram
%---Read image:
img = imread('dark.tif');
img = double(img);

%Find max and min pixel intensity
imax = max(img(:));
imin = min(img(:));

%Customized range of intensity
a = 10;
b = 150;
img2 = zeros(240,320,'uint8');

%---Linearly stretch:
for i = 1:240
    for j = 1:320
        intensity = img(i,j);
        if (intensity >= a) && (intensity <= b)
            img2(i,j) = ((imax-imin)/(b-a))*(intensity-a)+imin;
        elseif intensity < a
            img2(i,j) = imin;
        elseif intensity > b
            img2(i,j) = imax;
        end
    end
end
img = uint8(img);

%---Display results:
figure;
subplot(221),imshow(img), title('Oringinal image');
subplot(222),plot(imhist(img)),title('Histogram');
subplot(223),imshow(img2), title('Stretched with range (10,150)');
subplot(224),plot(imhist(img2)),title('Stretched histogram');
%impixelinfo;
