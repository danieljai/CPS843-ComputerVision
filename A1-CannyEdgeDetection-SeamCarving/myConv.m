function [ outimg ] = myConv( inimg, kern )
%MYCONV Summary of this function goes here
%   Detailed explanation goes here

%flip the kernel
flipkern = flip(flip(kern,1),2);

[sizekernrow, sizekerncol] = size(kern);

padrow = floor(sizekernrow/2);
padcol = floor(sizekerncol/2);

[imgrow,imgcol] = size(inimg);

padimg = zeros(imgrow+padrow*2, imgcol+padcol*2);
padimg(padrow+1:imgrow+padrow, padcol+1:imgcol+padcol) = inimg;

outimg = zeros(imgrow,imgcol);

for i=1:1:imgrow
    for j=1:1:imgcol
        temp = padimg(i:i+2*padrow, j:j+2*padcol);
        outimg(i,j) = sum(sum(temp.*flipkern));
    end
end

end

