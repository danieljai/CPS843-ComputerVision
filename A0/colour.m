img = imread('4.2.03.tiff');

fprintf('Swapping red and green channels.\nPress any key to continue...\n\n');
img2 = img;
img2(:,:,1)=img(:,:,3); 
img2(:,:,3)=img(:,:,1);
imshow(img2);
pause;

fprintf('Green channel\nPress any key to continue...\n\n');
img_g = img(:,:,2);
imshow(img_g);
pause;

fprintf('Red channel\nPress any key to continue...\n\n');
img_r = img(:,:,1);
imshow(img_r);
pause;

fprintf('rgb2gray');
img_gray = rgb2gray(img);
imshow(img_gray);
