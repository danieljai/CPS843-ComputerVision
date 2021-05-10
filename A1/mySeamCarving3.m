function [ outimg ] = mySeamCarving3( inimg, width, height )
%MYSEEMCARVING Summary of this function goes here
%   Detailed explanation goes here


workingimg = im2double(inimg);

[row, col] = size(workingimg(:,:,1));

while(col > width)
    workingimg = CarvingHelper(workingimg);
    [row, col] = size(workingimg(:,:,1)); 
end

workingimgt = cat(3,[workingimg(:,:,1)'],[workingimg(:,:,2)'],[workingimg(:,:,3)']);

[row, col] = size(workingimgt(:,:,1));

while(col > height)
    workingimgt = CarvingHelper(workingimgt);
    [row, col] = size(workingimgt(:,:,1)); 
end

outimg = cat(3,[workingimgt(:,:,1)'],[workingimgt(:,:,2)'],[workingimgt(:,:,3)']);
end

