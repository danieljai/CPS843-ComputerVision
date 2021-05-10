img = imread('4.2.03.tiff');
[m,n,r] = size(img);
img_gray = rgb2gray(img);


sqr_begin = m/2 - 50;
sqr_end = sqr_begin + 100;


clip = img_gray(sqr_begin:sqr_end,sqr_begin:sqr_end);

image2 = rgb2gray(imread('4.2.07.tiff'));
new_img_gray = image2;
image2(sqr_begin:sqr_end,sqr_begin:sqr_end) = clip;
imshow(image2)