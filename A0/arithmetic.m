img = imread('4.2.03.tiff');
img_g = img(:,:,2);
[m,n,r] = size(img_g);

% Q4a: min, max, and mean
min(img_g(:));
max(img_g(:));
img_g_mean = double(mean(img_g(:)));
img_g_std = std(double(img_g(:)));

% Q4b
img_g_new = uint8(((double(img_g) - img_g_mean)/img_g_std) *10 + img_g_mean);
imshow(img_g_new);

fprintf('Q4b: (img_g - mean)/sd*10 1\nPress any key to continue...\n\n');
pause;

% Q4c
img_g_shifted = [img_g(:,3:end) zeros(m,2)];
imshow(img_g_shifted);

fprintf('Q4c: shifted 2\nPress any key to continue...\n\n');
pause;

% Q4d
imshow(img_g - img_g_shifted);
fprintf('Q4d: original - shifted\nPress any key to continue...\n\n');
pause;

% Q4e
% img_g_horizontal_flip = flip(img_g,2);
imshow(flip(img_g,2));
fprintf('Q4e: horizontal flip\nPress any key to continue...\n\n');
pause;


% Q4f
img_g_intensity = 255 - img_g;
imshow(uint8(img_g_intensity));
fprintf('Q4f: intensity\nPress any key to continue...\n\n');
pause;