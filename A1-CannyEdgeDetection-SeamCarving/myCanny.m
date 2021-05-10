function [ derivX, derivY,gradmag,grador,threshhi,nonmaxsupp] = myCanny( inimg, thhi)
%MYCANNY Summary of this function goes here
%   Detailed explanation goes here

[imgrow,imgcol] = size(inimg);

% Q2-2: gradient blur separate filters
h1=fspecial('gaussian',[1,3],3);
h2=fspecial('gaussian',[3,1],3);
inimg = imfilter(inimg, h1,'conv');
inimg = imfilter(inimg, h2,'conv');



%Sobel Filter instead
Gx = [1,0,-1;2,0,-2;1,0,-1];
Gy = [1,2,1;0,0,0;-1,-2,-1];

derivX = imfilter(inimg, Gx, 'conv');
derivY = imfilter(inimg, Gy, 'conv');

gradmag = sqrt(derivX.^2 + derivY.^2);
grador = atan2(derivY,derivX);

threshhi = gradmag > thhi;
threshhi = threshhi.*gradmag;


%compare left and right, if biggest, keep, if not, suppress = 0

nonmaxsupp = threshhi;
% nonmaxsupplow = threshlow;
for i=2:1:imgrow-1
    for j=2:1:imgcol-1
        checkneighx = round(sin(grador(i,j)));
        checkneighy = round(cos(grador(i,j)));
        if (threshhi(i,j) < threshhi(i+checkneighx,j+checkneighy)) || (threshhi(i,j) < threshhi(i-checkneighx,j-checkneighy))
            nonmaxsupp(i,j) = 0;
        end

        
    end
end

threshhi = nonmaxsupp > thhi;


end