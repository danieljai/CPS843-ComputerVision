function imageMatrix = imageBlend2(img1, img2)
%     img1 = newCanvas;
%     img2 = newCanvas2;
    
%   convert any cell that has a value to 1
%   multiple two to get the interacting area
    img1neg = rgb2gray(img1);
    img2neg = rgb2gray(img2);
    img1neg(img1neg>0) = 1;
    img2neg(img2neg>0) = 1;
    img1neg = double(img1neg);
    img2neg = double(img2neg);
    imgOverlap = img1neg .* img2neg;
    
    
    
    rowZeros = find( sum(imgOverlap(:,:,1),2));
    colZeros = find( sum(imgOverlap(:,:,1),1));
    leftCol = min(colZeros);
    rightCol = max(colZeros);
    topRow = min(rowZeros);
    bottomRow = max(rowZeros);
    totalRows = bottomRow - topRow;
    totalCols = rightCol - leftCol;
    quarterRows = round(totalRows /4);
    quarterCols = round(totalCols/4);
    
    
%     Filling the holes in intersecting area.
    for idx = topRow:bottomRow
        whiteLeftCol = find(imgOverlap(idx,:), 1 );
        whiteRightCol = find(imgOverlap(idx,:), 1, 'last' );
        imgOverlap(idx,whiteLeftCol:whiteRightCol) = 1;
    end
    
%     reserved intersecting bits
    imgWarBox = imgOverlap;
%     imshow(imgWarBox);
    
    
    
    fprintf("And we're blending, and we're blending,");
    
% %     left fade
%     for i = leftCol:(leftCol+quarterCols)
%         opacity = ((i-leftCol)/quarterCols) ;        
% %         fprintf(" " + i + "\t");
% %         fprintf(" " + opacity + "\n");
%         imgOverlap(:,i) = imgOverlap(:,i)*opacity;
%     end
%     
%     % top fade
%     for i = topRow:(topRow+quarterRows)
%         opacity = ((i-topRow)/quarterRows) ;        
% %         fprintf(" " + i + "\t");
% %         fprintf(" " + opacity + "\n");
%         imgOverlap(i,:) = imgOverlap(i,:)*opacity;
%     end
%     
%     
%     % bottom fade
%     for i = (bottomRow-quarterRows):bottomRow
%         opacity = 1-(i-bottomRow+quarterRows)/quarterRows;        
% %         fprintf(" " + i + "\t");
% %         fprintf(" " + opacity + "\n");
%         imgOverlap(i,:) = imgOverlap(i,:)*opacity;
%     end
    
%     right fade
    for i = leftCol:rightCol
        opacity = (i-leftCol)/totalCols;
%         fprintf(" " + i + "\t");
%         fprintf(" " + opacity + "\n");
        imgOverlap(:,i) = imgOverlap(:,i)*opacity;
    end
    
    fprintf("... and we’re done \n");
    
    negImgOverlap = abs(1-imgOverlap);
    dblImg1 = im2double(img1);
    dblImg2 = im2double(img2);
%     imshow(dblImg2.*imgOverlap);
        
%     imshow(imgOverlap);
%     merge everything
    imageMatrix = (dblImg1.*imgWarBox.*negImgOverlap + dblImg2.*imgOverlap + dblImg2.*~imgWarBox + dblImg1.*~imgWarBox );
    
    
end