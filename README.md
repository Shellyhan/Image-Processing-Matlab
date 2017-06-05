# Image-Processing-Matlab


1. Histogram transformation:

  1.1 Linear stretching:
  
  ![alt text](https://github.com/Shellyhan/Image-Processing-Matlab/raw/master/results/1.jpg)
  
  1.2 Histogram equalization:
  
  ![alt text](https://github.com/Shellyhan/Image-Processing-Matlab/raw/master/results/2.jpg)
  
2. Edge detection:

  
  Three different edge operators, including Prewitt’s, Laplacian of Gaussian, and Canny, are applied to both original and Gaussian smoothed images. Following are the results of edge detection.
  
  ![alt text](https://github.com/Shellyhan/Image-Processing-Matlab/raw/master/results/3.jpg)

Prewitt’s edge operator:

1.	Reduces some effect of noise with local averaging, but losses part of main edges

2.	Gives poor localization of edges

3.	Detected edge is broken into sections

Laplacian of Gaussian operator:

1.	Fails to filter out noises, performance improved a lot on smoothed image

2.	Finds most of the main edges from Laplacian operation

3.	Poor localization of edges due to a lack of directional information

Canny edge operator:

1.	Removes partial noise

2.	Detected edges match the correct location of edges

3.	Gives thin edges due to non-maximum suppression

4.	Returns only real edges with Hysteresis threshold
