img = imread('4.2.03.tiff');

gaussian_variance = 0.1;
gaussian_noise = randn(512,512,3) * gaussian_variance;

imshow(gaussian_noise + im2double(img));
