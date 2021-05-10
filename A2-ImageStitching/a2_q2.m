function newCanvas2 = a2_q2(leftImg1, rightImg2)
    % loading VLFeat
    run('E:\Downloads\vlfeat-0.9.21-bin.tar\vlfeat-0.9.21\toolbox\vl_setup')

    % import image
    fprintf("\n\nLoading images... \n");
    img1 = imread(leftImg1);
    img2 = imread(rightImg2);
%     img1 = imread("parliament-left.jpg");
%     img2 = imread("parliament-right.jpg");

    % converting images
    simg1 = im2single(rgb2gray(img1));
    simg2 = im2single(rgb2gray(img2));

    % P.A.2 -- Detect keypoints and extract descriptors
    % process SIFT
    fprintf("Finding feature and calculating pairs... \n");
    [f1,d1] = vl_sift(simg1) ;
    [f2,d2] = vl_sift(simg2) ;

    % matching descriptors; as suggested by Tony.
    [matches, scores] = vl_ubcmatch(d1, d2) ;
    f1f2PrunedPaired = [f1(1:2, matches(1,:)) ; f2(1:2, matches(2,:))];

    bestTotal = 0;
    % set acceptable radius in pixels
    acceptableRadius = 5;
    sampleSize = findSampleSize(0.5,6,0.99);

    fprintf("Sampling size: " + sampleSize + "\n");
    
    fprintf("Begin sampling... \n");
    for sampling = 1:sampleSize
        if (mod(sampling,25) == 0), fprintf("."),end
        if (mod(sampling,1000) == 0), fprintf("\n"+ sampling ),end

        % Sample and retrieve 3 paired indices from pairedPts as luckyPairs
        % 3 paired indices === 3 feature index from img1, 3 feature index from img2
        % Merge the 6 points in sixPoints
        % Each row is a paired point. (1:2) from map1,(3:4) from map2
        luckyThree = randperm(size(f1f2PrunedPaired,2),3);
        luckyThreeCords = f1f2PrunedPaired(:,luckyThree);


        % bigA = 3 points; (x_1, y_1) cords from sixPoints 
        % vecb = 3 points; (x_2, y_2) cords from sixPoints
        % vecx = generate the unknowns
        bigA = [    luckyThreeCords(1:2,1)' 0 0 1 0;
                    0 0 luckyThreeCords(1:2,1)' 0 1;
                    luckyThreeCords(1:2,2)' 0 0 1 0;
                    0 0 luckyThreeCords(1:2,2)' 0 1;
                    luckyThreeCords(1:2,3)' 0 0 1 0;
                    0 0 luckyThreeCords(1:2,3)' 0 1;
            ];
    
        vecb = reshape(luckyThreeCords(3:4,1:3),6,1);


        vecx = bigA\vecb;    
        


        % prep matrix to collect votes
        % calculate transform, calculate distance of predicted to actual
        % collect vote if in radius
        tempReport = [f1f2PrunedPaired ; zeros(2,size(f1f2PrunedPaired,2))];

        for idx = 1:size(tempReport,2)
            tempReport(5:6,idx) = ([tempReport(1:2,idx)' 0 0 1 0; 0 0 tempReport(1:2,idx)' 0 1]*vecx)';
            tempReport(7,idx) = dist2(tempReport(3:4,idx)', tempReport(5:6,idx)');
            tempReport(8,idx) = tempReport(7,idx) < acceptableRadius^2;
        end

        tempVoteTotal = sum(tempReport(8,:));


        if (bestTotal < tempVoteTotal)
    %         get all inliers
            tempVotedPairs = tempReport(1:4, tempReport(8,:)==1);


            % prep vector b and matrix A.
            % find vec x with all inliers
            tempVecb = reshape(tempVotedPairs(3:4,:),[],1);
            tempA = tempVotedPairs(1:2,:)';
            tempA = repmat(repelem(tempA,2,1),1,2);
            tempA = [tempA zeros(size(tempA,1),2)];
            tempA(1:2:end,3:4) = 0;        
            tempA(2:2:end,1:2) = 0;
            tempA(1:2:end,5) = 1;
            tempA(2:2:end,6) = 1;
            tempVecx =  tempA\tempVecb;

    %         collect votes again 
            for idx = 1:size(tempVotedPairs,2)
                tempVotedPairs(5:6,idx) = ([tempVotedPairs(1:2,idx)' 0 0 1 0; 0 0 tempVotedPairs(1:2,idx)' 0 1]*vecx)';
                tempVotedPairs(7,idx) = dist2(tempVotedPairs(3:4,idx)', tempVotedPairs(5:6,idx)');
                tempVotedPairs(8,idx) = tempVotedPairs(7,idx) < acceptableRadius^2;
            end

            % if new vec x still wins, save info
            % bestTotal returns the best vote count
            if bestTotal < sum(tempVotedPairs(8,:))
                bestTotal = sum(tempVotedPairs(8,:));
                bestVecx = tempVecx;
%                 bestReport = tempVotedPairs;
                fprintf(" \nbest: " + bestTotal + " ");
            end



        end
    end
    fprintf(" Done.\n");

    % fit tform matrix and tform
    fprintf("Transforming image... \n");
    tmat = [reshape(bestVecx(1:4),2,2) ; bestVecx(5:6)'];
    tform = affine2d(tmat);
    transformedImg1 = imwarp(img1,tform);


    [img1row, img1col,~] = size(img1);

    % create new canvas three times and two times the largest rows and columns
    % set new origin to mid-right
    threeTimesMaxRow = max(size(transformedImg1,1),size(img2,1))*3;
    twoTimesMaxCol = max(size(transformedImg1,2),size(img2,2))*2;
    newCanvas = uint8(zeros(threeTimesMaxRow, twoTimesMaxCol, 3));
    newCanvasImg2Cord = [size(newCanvas,1)*1/3 size(newCanvas,2)/2];

    % insert img2
    [img2row, img2col,~] = size(img2);
    newCanvas(newCanvasImg2Cord(1):newCanvasImg2Cord(1)+img2row-1, newCanvasImg2Cord(2):newCanvasImg2Cord(2)+img2col-1,:) = img2;

    % find coordinates to insert transformed img1
    [img1trow, img1tcol,~] = size(transformedImg1);

    % cw rotation, adjust cols
    if (bestVecx(2)<0) 
        shiftcol = round(bestVecx(5)+bestVecx(2)*img1row);
    else
        shiftcol = round(bestVecx(5));
    end

    % ccw rotation, adjust rows
    if (bestVecx(3)<0) 
        shiftrow = round(bestVecx(6)+bestVecx(3)*img1row);
    else
        shiftrow = round(bestVecx(6));
    end
    newCanvas(newCanvasImg2Cord(1)+shiftrow:newCanvasImg2Cord(1)+shiftrow+img1trow-1, ...
        newCanvasImg2Cord(2)+shiftcol:newCanvasImg2Cord(2)+shiftcol+img1tcol-1,:) = ...
        max(newCanvas(newCanvasImg2Cord(1)+shiftrow:newCanvasImg2Cord(1)+shiftrow+img1trow-1, ...
        newCanvasImg2Cord(2)+shiftcol:newCanvasImg2Cord(2)+shiftcol+img1tcol-1,:),transformedImg1);

    % trim edges
    rowZeros = find( sum(newCanvas(:,:,1),2));
    colZeros = find( sum(newCanvas(:,:,1),1));
    leftCol = min(colZeros);
    rightCol = max(colZeros);
    topRow = min(rowZeros);
    bottomRow = max(rowZeros);

    newCanvas2 = newCanvas(topRow:bottomRow,leftCol:rightCol,:);
    fprintf("Stitching completed. \n");
    imshow(newCanvas2);

end

                
 