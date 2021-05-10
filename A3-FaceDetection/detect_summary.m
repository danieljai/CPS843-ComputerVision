% \n");
% fprintf("

fprintf("1.	Weights and Bias are loaded from previous step\n");
fprintf("2.	Load all filenames from image folder\n");
fprintf("3.	Iterate each image file to EOF\n");
fprintf("4.	Iterate through scale, from 0.1 to 1.13, increment 0.1\n");
fprintf("5.	Use histeq() to enhance image contrast\n");
fprintf("6.	Calculate each image’s hog values\n");
fprintf("7.	Use sliding window method and calculate the result with Weights and Bias\n");
fprintf("8.	Readjust bbox size to reflect scaled image, and tally all matches found\n");
fprintf("9.	Keep only the highest 75 confidence points that are above a certain threshold\n");
fprintf("10.	Go to step #3 and repeat\n");
fprintf("11.	Copy all the matched points coordinates, confidence level and scale onto another matrix for processing.\n");
fprintf("12.	For each point, check whether any subsequent point overlaps, and if yes by what percent\n");
fprintf("13.	If overlapping percentage is larger than a threshold, mark that point as dead and it won’t be used to \n");
fprintf("        find other matches again.\n");
fprintf("14.	Calculate minimum square percentage. If its larger than a stricter threshold, mark that point as dead.\n");
fprintf("15.	Tally results and display.\n");
fprintf("16.	Go to step #2 and repeat until all files have been processed.\n\n");
fprintf("Result: the average precision is 0.897\n\n");
fprintf("Notes:\n");
fprintf("-  [8] the bounding box has to scale accordingly to a resized image\n");
fprintf("-  [14] Since we shrink our images, the bounding boxes has to scale according with the match. This result to boxes \n");
fprintf("   that are disproportionately large to other boxes that were not scaled down and lead to an imbalance when \n");
fprintf("   calculating the overlapping ratio, such as a larger box completely eclipsing a smaller box yet still has \n");
fprintf("   less than 0.5 overlapping. Step 14 includes another percentage calculation using the denominator of the \n");
fprintf("   smaller box, to adjust this imbalance.\n");
fprintf("\nFailed attempts:\n");
fprintf("-  Attempted to generate another set of features for skin tone by collecting histcounts() of grayscale \n");
fprintf("   levels. However, this did not yield better performance\n");

