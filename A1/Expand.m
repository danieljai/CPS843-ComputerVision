function [ outimg ] = Expand( inimg, width, height )


workingimg = im2double(inimg);

[row, col] = size(workingimg(:,:,1));
expand = width-col;
lastmin = 2*col;

while(col < width)
    [workingimg,lastmin] = ExpandHelper(workingimg,lastmin,expand);
    [row, col] = size(workingimg(:,:,1)); 
end

workingimgt = cat(3,[workingimg(:,:,1)'],[workingimg(:,:,2)'],[workingimg(:,:,3)']);

[row, col] = size(workingimgt(:,:,1));
expand = height-col;
lastmin = 2*col;
while(col < height)
    [workingimgt,lastmin] = ExpandHelper(workingimgt,lastmin,expand);
    [row, col] = size(workingimgt(:,:,1)); 
end

outimg = cat(3,[workingimgt(:,:,1)'],[workingimgt(:,:,2)'],[workingimgt(:,:,3)']);
end