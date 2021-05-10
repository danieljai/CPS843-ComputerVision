% Andy Lee
% 500153559
% CPS843 - Assignment 1
% 


% Question 1-1
fprintf("0  5  0  0  0  0  0  0  0  0\n");
fprintf("0  0  0  0  0  0  0  0  0  0\n");
fprintf("0 -7  2  8 -1  2 -1 -3  0  0\n");
fprintf("0  0  1  1  0  0 -1 -1  0  0\n");
fprintf("0  0  3  1 -2  4 -1 -5  0  0\n");
fprintf("0  0 -1 -1  0  0  1  1  0  0\n");
fprintf("0  0  1  2  2  2 -3 -4  0  0\n");
fprintf("0  0  0  0  0  0  0  0  0  0\n");
fprintf("0  0  0  0  0  0  0  0  0  0\n");

% Question 1-2
fprintf("[2 3] = sqrt(65)\n");
fprintf("[4 3] = sqrt(5)\n");
fprintf("[4 6] = sqrt(5)\n");

% Question 1-3
% Check myConf.m

% Question 1-4
img=rgb2gray(imread('ryerson.jpg'));
imgdbl=im2double(img);

gkern = [1,2,1;2,4,2;1,2,1]/16;
flippedGkern = flip(flip(gkern));
imgdbl_guassian = myConv(imgdbl, flippedGkern);
imshow(imgdbl_guassian);
fprintf("Showing myConv()...\n\n");
pause;

h = fspecial('gaussian',13,2);
I = imfilter(imgdbl, h, 'symmetric', 'same');

imshow(abs(I-imgdbl_guassian));
fprintf("Showing my difference between myConv() and imfilter()...\n\n");
fprintf("Q1-4 A: The difference produces a faint outline of the original picture given the difference in size between the two filters.\n\n\n");
pause;


% Question 1-5

sigma = 8;
twoDResult = 0;
oneDResult = 0;
tries = 50;
imgtictoc = rgb2gray(imread('791-640x480.jpg'));

for i = 1:tries

    tic;
    h=fspecial('gaussian',[3 3],sigma);
    imfilterout1 = imfilter(imgtictoc,h);
    etoc = toc;
    twoDResult = twoDResult + etoc;


    tic;
    h=fspecial('gaussian',[1 3],sigma);
    imfilterout = imfilter(imgtictoc,h);
    h=fspecial('gaussian',[3 1],sigma);
    imfilterout2 = imfilter(imfilterout,h);
    etoc = toc;
    oneDResult = oneDResult + etoc;

end
fprintf("After " + tries + " tries...\n");
fprintf("Average one 2D filter: \t\t" + twoDResult/tries + "\n" );
fprintf("Average two 1D filters: \t" + oneDResult/tries  + "\n");

if (twoDResult/tries < oneDResult/tries)
    fprintf("One 2D filter is faster\n");
else
    fprintf("Two 1D filter is faster\n");
end
fprintf("A: 2D filter on average is faster on this image. However two 1D filter would probably be faster given larger image as it has a complexity of  linear time (O(n)) instead of quadratic (O(n^2)) time. Or maybe the  builtin algorithm is able to go through the matrix more efficient than n^2.");
fprintf("\n\n\n");




% Question 2-1 - bowl of fruits
% Question 2-2 inside myCanny.m
fprintf("Computing Q2-1\n");
img = imread('bowl-of-fruit.jpg');
img_gray = (im2double(rgb2gray(img)));
[~,~,~,~,~,img_canny] = myCanny(img_gray,15/255);
imshow(img_canny);
fprintf("Showing 2-1 myCanny() on bowl of fruits.\n\n");
pause;

% Question 2-1 - ryerson
fprintf("Computing Q2-1\n");
img = imread('ryerson.jpg');
img_gray = (im2double(rgb2gray(img)));
[~,~,~,~,~,img_canny] = myCanny(img_gray,15/255);
imshow(img_canny);
fprintf("Showing 2-1 myCanny() on ryerson.\n\n");
pause;
fprintf("\n\n\n");
% Question 3-1
fprintf("Computing Q3-1\n");
img = imread('ryerson.jpg');
fprintf("Computing...\n");
imshow(mySeamCarving3( img, 640, 480));
fprintf("Showing mySeamCarving() 640 × 480.\n\n");
pause;

fprintf("Computing...\n");
imshow(mySeamCarving3( img, 720, 320));
fprintf("Showing mySeamCarving() 720 × 320..\n\n");
pause;

% Question 3-1 own image attempt
fprintf("Computing Q3-1 own image\n");
img = imread('791-640x480.jpg');
fprintf("Computing...\n");
imshow(mySeamCarving3( img, 580, 480));
fprintf("Showing 580 × 480.\n\n");
pause;

fprintf("Computing...\n");
imshow(mySeamCarving3( img, 640, 400));
fprintf("Showing 720 × 320.\n\n");
pause;



% Question 3-2 (bonus)
fprintf("Computing Q3-2 using own image\n");
img = imread('791-640x480.jpg');
fprintf("Computing...\n");
imshow(Expand( img, 680, 480));
fprintf("Showing Expand() 720 × 480.\n\n");






