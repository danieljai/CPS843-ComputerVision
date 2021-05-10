

orgim1 = im2double(im2gray(imread(impath1)));
orgim2 = im2double(im2gray(imread(impath2)));

% im16_1 = imresize(orgim1, 1/16);
% im16_2 = imresize(orgim2, 1/16);
im8_1 = imresize(orgim1, 1/reduceFactor);
im8_2 = imresize(orgim2, 1/reduceFactor);
% im4_1 = imresize(orgim1, 1/4);
% im4_2 = imresize(orgim2, 1/4);
% im2_1 = imresize(orgim1, 1/2);
% im2_2 = imresize(orgim2, 1/2);
% im1_1 = imresize(orgim1, 1/1);
% im1_2 = imresize(orgim2, 1/1);

% [vecU, vecV, bmp1] = myFlow(im16_1,im16_2, eigThres, winLen);
[vecU8, vecV8, ~] = myFlow(im8_1,im8_2, eigThres, winLen);

% sampleU = impyramid(im8_1,'expand');
% sampleU2 = imresize(im8_1,2);
% sampleU3 = interp2(vecU8,3);

targetRows = size(orgim1,1);
targetCols = size(orgim1,2);
[X, Y] = meshgrid(1:size(vecU8,1));
[Xq, Yq] = meshgrid(linspace(1,size(vecU8,2), targetCols), linspace(1, size(vecU8, 1), targetRows));
sampleU4 = interp2(X, Y, vecU8*reduceFactor, Xq, Yq);
sampleV4 = interp2(X, Y, vecV8*reduceFactor, Xq, Yq);

matFlowOrg = cat(3,sampleU4,sampleV4);
matFlow = cat(3,vecU8,vecV8);

subplot(1,2,1);
imshow(flowToColor(matFlow));
title('Optical flow');
subplot(1,2,2);
imshow(flowToColor(matFlowOrg));
title('Optical flow (Interpolated)');

fprintf("Showing figure...")
fprintf("\nPress any key to continue...\n\n")

pause;
fprintf("********************************************************** \n");
fprintf("********************************************************** \n");
fprintf("********************************************************** \n");
fprintf("Q3. Difference of the warped img2 and original img1 \n");

warped_img = myWarp(orgim2, sampleU4, sampleV4);

% impath1 = "Sequences\corridor\bt_0.png";
% impath2 = "Sequences\corridor\bt_1.png";
% orgim1 = im2double(imread(impath1));
% orgim2 = im2double(imread(impath2));

imshow(warped_img-orgim1);
title('Warpped image - Original image');
fprintf("Showing figure...")
fprintf("\nPress any key to continue...\n\n")
pause;



fprintf("Q3. Looping warped img2 and original img1 \n");
for iter = 1:10
    
%     imshow(expandedWarpResult);
    imshow(orgim1);
    title('Original');
    pause(.25);
    imshow(warped_img);
    title('Warped');
    pause(.25);
end

fprintf("a4runimage.m finished running.\n\n")







