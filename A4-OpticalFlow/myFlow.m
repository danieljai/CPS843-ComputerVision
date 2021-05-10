function [vecU, vecV, bmp] = myFlow(im1, im2,  eigThres, winLen)

    smoothness = 0.75;

    h = (1/12)*[-1 8 0 -8 1];

    im1_dx = imfilter(imgaussfilt(im1, smoothness), flip(flip(h,1),2), 'conv');
    im1_dy = imfilter(imgaussfilt(im1, smoothness), flip(flip(h',1),2), 'conv');
    
    width = 3;
    sigma = 2;
    g = fspecial('gaussian', width, sigma);
    im1_dIdt = imfilter(im1, g, 'symmetric', 'same');
    im2_dIdt = imfilter(im2, g, 'symmetric', 'same');

%     im1_dIdt = imgaussfilt(im1,1,'FilterSize',5);
%     im2_dIdt = imgaussfilt(im2,1,'FilterSize',5);

    diff_dIdt = im2_dIdt - im1_dIdt;

    [rowLen, colLen] = size(im1);


    eigResult = zeros(rowLen, colLen);
    bmp = eigResult;
    vecU = eigResult;
    vecV  = eigResult;
    offset = floor(winLen/2);

    for rowP = 1 + offset : rowLen - offset
        for colP = 1 + offset : colLen - offset

            tempI_x = im1_dx(rowP-offset:rowP+offset , colP-offset:colP+offset);
            tempI_y = im1_dy(rowP-offset:rowP+offset , colP-offset:colP+offset);
            tempI_t = diff_dIdt(rowP-offset:rowP+offset , colP-offset:colP+offset);

            A = [sum(sum(tempI_x.*tempI_x)), sum(sum(tempI_x.*tempI_y)); ...
                sum(sum(tempI_y.*tempI_x)), sum(sum(tempI_y.*tempI_y))];

            b = -[sum(sum(tempI_x.*tempI_t)); sum(sum(tempI_y.*tempI_t))];   

            tempEig = eig(A);
            eigResult(rowP, colP) = min(tempEig);
            


            if eigResult(rowP, colP) > eigThres
                vecX = A\b;
                
               
                vecU(rowP, colP) = vecX(1);
                vecV(rowP, colP) = vecX(2);
                bmp(rowP, colP) = 1;
            end
        end
    end
end