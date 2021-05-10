image1 = imread(fullfile('4.2.03.tiff'));
image2 = imread(fullfile('4.2.07.tiff'));

fprintf('Displaying image 1\nPress any key to continue...\n\n');
imshow(image1,[0,512])
pause;

fprintf('Displaying image 2\nPress any key to continue...\n\n');
imshow(image2,[0,512])
pause;