function [warped_img] = myWarp (orgim2, sampleU4, sampleV4 )

[X, Y] = meshgrid(1:size(orgim2,1));
warped_img = interp2(orgim2,abs(X-sampleU4),abs(Y-sampleV4),'bicubic');

% subplot(1,2,1);
% imshow(warped_img);
% subplot(1,2,2);
% imshow(warped_img2);


% % Dealing with nan
imgNan = isnan(warped_img);
warped_img(imgNan) = orgim2(imgNan);




end






