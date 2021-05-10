function status = bonus(leftImg1, rightImg2)
    % loading VLFeat
    run('E:\Downloads\vlfeat-0.9.21-bin.tar\vlfeat-0.9.21\toolbox\vl_setup')

    % import image

    img1 = imread(leftImg1);
    img2 = imread(rightImg2);
%     img1 = imread("P9190003.jpg");
%     img2 = imread("P9190004.jpg");

    % converting images
    simg1 = im2single(rgb2gray(img1));
    simg2 = im2single(rgb2gray(img2));

    % P.A.2 -- Detect keypoints and extract descriptors
    % process SIFT
    [f1,d1] = vl_sift(simg1) ;
    [f2,d2] = vl_sift(simg2) ;

    % matching descriptors; as suggested by Tony.
    [matches, scores] = vl_ubcmatch(d1, d2) ;
    f1f2PrunedPaired = [f1(1:2, matches(1,:)) ; f2(1:2, matches(2,:))];

    bestTotal = 0;
    % set acceptable radius in pixels
    acceptableRadius = 5;
    sampleSize = findSampleSize(0.5,8,0.99);

    fprintf("Sampling ");

    for sampling = 1:sampleSize
        if (mod(sampling,25) == 0), fprintf("."),end
        if (mod(sampling,200) == 0), fprintf("\niteration #: "+ sampling ),end

        % Sample and retrieve 3 paired indices from pairedPts as luckyPairs
        % 3 paired indices === 3 feature index from img1, 3 feature index from img2
        % Merge the 6 points in sixPoints
        % Each row is a paired point. (1:2) from map1,(3:4) from map2
        luckyFour = randperm(size(f1f2PrunedPaired,2),4);
        luckyFourCords = f1f2PrunedPaired(:,luckyFour);


        % bigA = 3 points; (x_1, y_1) cords from sixPoints 
        % vecb = 3 points; (x_2, y_2) cords from sixPoints
        % vecx = generate the unknowns
        bigA = [
                homographyA(luckyFourCords(:,1));
                homographyA(luckyFourCords(:,2));
                homographyA(luckyFourCords(:,3));
                homographyA(luckyFourCords(:,4))
            ];
        [U,S,V]=svd(bigA);
        vecx = V(:,end);




    % prep matrix to collect votes
    % calculate transform, calculate distance of predicted to actual
    % collect vote if in radius
        tempReport = [f1f2PrunedPaired ; zeros(4,size(f1f2PrunedPaired,2))];

        for idx = 1:size(tempReport,2)
    %         tempReport(5:6,idx) = (homographyA(tempReport(1:4,idx)) * vecx)';
            tempReport(5:6,idx) = homographyGetPoints(tempReport(1:2,idx), vecx);
            tempReport(7,idx) = dist2(tempReport(3:4,idx)', tempReport(5:6,idx)');
            tempReport(8,idx) = tempReport(7,idx) < acceptableRadius^2;
        end

        tempVoteTotal = sum(tempReport(8,:));


        if (bestTotal < tempVoteTotal)
    %         get all inliers
            tempVotedPairs = [tempReport(1:4, tempReport(8,:)==1) ; zeros(4,tempVoteTotal)];


            % prep vector b and matrix A.
            % find vec x with all inliers
            tempA = zeros(size(tempVotedPairs,2)*2 ,9);

            for e = 1:2:size(tempVotedPairs,2)*2
                tempA(e:e+1,1:9) = homographyA(tempVotedPairs(:,(e+1)/2));
            end

            [tempU,tempS,tempV]=svd(tempA);
            tempVecx = tempV(:,end);

            for idx = 1:size(tempVotedPairs,2)
                tempVotedPairs(5:6,idx) = homographyGetPoints(tempVotedPairs(1:2,idx), tempVecx);
                tempVotedPairs(7,idx) = dist2(tempVotedPairs(3:4,idx)', tempVotedPairs(5:6,idx)');
                tempVotedPairs(8,idx) = tempVotedPairs(7,idx) < acceptableRadius^2;
            end        


            % if new vec x still wins, save info
            % bestTotal returns the best vote count
            if bestTotal < sum(tempVotedPairs(8,:))
                bestTotal = sum(tempVotedPairs(8,:));
                bestVecx = tempVecx;
                bestReport = tempVotedPairs;
                fprintf(" \nbest: " + bestTotal + " ");
            end



        end
    end
    fprintf(" Done.\n");

    % fit tform matrix and tform
    tmat = reshape(bestVecx,3,3);

    tform = projective2d(tmat);
    transformedImg1 = imwarp(img1,tform);
    % imshow(transformedImg1);
    % imwrite(transformedImg1,"homography" + datestr(now,'yyyymmdd-HHMMSS')+".jpg");

    % create new canvas three times and two times the largest rows and columns
    % set new origin to mid-right
    threeTimesMaxRow = max(size(transformedImg1,1),size(img2,1))*3;
    twoTimesMaxCol = max(size(transformedImg1,2),size(img2,2))*3;
    newCanvas = uint8(zeros(threeTimesMaxRow, twoTimesMaxCol, 3));
    newCanvas2 = newCanvas; 
%     newCanvasImg2Cord = [size(newCanvas,1)*1/3 size(newCanvas,2)/2];
    newCanvasImg2Cord = [size(newCanvas,1)/3 size(newCanvas,2)/3];
    newOrgRow = size(newCanvas,1)/3;
    newOrgCol = size(newCanvas,2)/3;

    % insert img2
    [img2row, img2col,~] = size(img2);
%     newCanvas(newCanvasImg2Cord(1):newCanvasImg2Cord(1)+img2row-1, newCanvasImg2Cord(2):newCanvasImg2Cord(2)+img2col-1,:) = img2;

    % find coordinates to insert transformed img1
    [img1trow, img1tcol,~] = size(transformedImg1);


    newTopLeft = homographyGetPoints([1;1],bestVecx);
    newTopRight = homographyGetPoints([size(img1,2);1],bestVecx);
    newBottomLeft = homographyGetPoints([1;size(img1,1)],bestVecx);

    % find shifted left boundaries and shifted top boundaries
    shiftcol = floor(min(newTopLeft(1),newBottomLeft(1))) ;
    shiftrow = floor(min(newTopLeft(2),newTopRight(2)))-1;

    % combining two canvas together
    newCanvas(...
        newOrgRow+shiftrow:newOrgRow+shiftrow+img1trow-1, ...
        newOrgCol+shiftcol:newOrgCol+shiftcol+img1tcol-1,:) = ...
        newCanvas(newOrgRow+shiftrow:newOrgRow+shiftrow+img1trow-1, ...
        newOrgCol+shiftcol:newOrgCol+shiftcol+img1tcol-1,:) + transformedImg1;
    newCanvas2(newOrgRow:newOrgRow+img2row-1, newOrgCol:newOrgCol+img2col-1,:) = img2;
%     newCanvas(newOrgRow:newOrgRow+img2row-1, newOrgCol:newOrgCol+img2col-1,:) = img2;

    blendImg1 = (imageBlend(newCanvas,newCanvas2));
    blendImg2 = (imageBlend2(newCanvas,newCanvas2));
    
    

    % trim edges
    rowZeros = find( sum(blendImg1(:,:,1),2));
    colZeros = find( sum(blendImg1(:,:,1),1));
    leftCol = min(colZeros);
    rightCol = max(colZeros);
    topRow = min(rowZeros);
    bottomRow = max(rowZeros);

    figure('NumberTitle', 'off', 'Name', 'Blending top, left, and bottom of the intersection with imageBlend()');
    imshow(blendImg1(topRow:bottomRow,leftCol:rightCol,:));
    
    
    % trim edges
    rowZeros = find( sum(blendImg2(:,:,1),2));
    colZeros = find( sum(blendImg2(:,:,1),1));
    leftCol = min(colZeros);
    rightCol = max(colZeros);
    topRow = min(rowZeros);
    bottomRow = max(rowZeros);

    figure('NumberTitle', 'off', 'Name', 'Blending only left of the intersection with imageBlend2()');
    imshow(blendImg2(topRow:bottomRow,leftCol:rightCol,:));
    status = 1;
    return
end

