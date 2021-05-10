% Andy Lee
% 500163559
% CP8307/CPS843 - Intro to Computer Vision
% Assignment 2


% Q1.1 - Least Squares Fitting of a Plane
clear;
fprintf("\n\nRunning Q1.1... \n");
alpha = 1;
beta = 2;
gamma = -3;
[x, y] = meshgrid(1:1:20,1:1:25);
z = alpha.*x + beta.*y + gamma;
z = z+randn(25,20);
surf(x,y,z);
fprintf("\n\nPress any key to continue... [1/7]\n");pause;


% Q1.2
fprintf("\n\nRunning Q1.2... \n");
A = ones(500,3);
A(:,1)=x(:);
A(:,2)=y(:);

z2= z(:);

est = inv(A'*A)*A'*z2;
disp(est)
fprintf("\n\nPress any key to continue... [2/7]\n");pause;


% Q1.3
fprintf("\n\nRunning Q1.3... \n");
orig = [alpha beta gamma]';
disp("Absolute error of alpha, beta, and gamma of ground truth and estimated plane is");
disp(abs(est - orig));
fprintf("\n\nPress any key to continue... [3/7]\n");pause;


% Q2 Part A - RANSAC-based Image Stitching
clear;
fprintf("\n\nRunning Q2 Part Aaaaaa... \n");
imshow(a2_q2("parliament-left.jpg", "parliament-right.jpg"));
fprintf("\n\nPress any key to continue... [4/7]\n");pause;


%  Q2 Part B.1
clear;
fprintf("\n\nRunning Q2 Part B.1... \n");
imshow(a2_q3("Ryerson-right.jpg", "Ryerson-left.jpg"));
fprintf("\n\nPress any key to continue... [5/7]\n");pause;


%  Q2 Part B.1
fprintf("\n\nRunning Q2 Part B.2... \n");
imshow(a2_q3("P9190003.jpg", "P9190004.jpg"));
fprintf("\n\nPress any key to continue...\n");pause;
fprintf("\n\nRunning Q2 Part B.2 with blending... \n");
bonus("P9190003.jpg", "P9190004.jpg");
fprintf("\n\nPress any key to continue... [6/7]\n");pause;


% Bonus 1 and 2
clear;
fprintf("\n\nRunning Bonus 1...\n");
figure('NumberTitle', 'off', 'Name', 'Bonus 1: RAC in Winter and Summer');
imshow(a2_q3("1.jpg", "2.jpg"));
fprintf("\n\nBonus 1 - Stitching RAC entrance during Winter and Summer together.\n");
fprintf("\n\nPress any key to continue... [7/7]\n");pause;


fprintf("\n\nRunning Bonus 2...\n");
figure('NumberTitle', 'off', 'Name', 'Bonus 2: Bonus 1 with Blending Techniques');
bonus("1.jpg","2.jpg");
fprintf("\n\nBonus 2 - Using the stitch from bonus one, apply two blending techniques.\n");
fprintf("First figure uses imageBlend(); blending only the center of the intersecting region.\n");
fprintf("Second figure uses imageBlend2(); blending all rows from left to right of the intersecting region.\n");

