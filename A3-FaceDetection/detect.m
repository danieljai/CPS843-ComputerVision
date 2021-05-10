run('../vlfeat-0.9.21/toolbox/vl_setup')
load("my_svm.mat")
% load("my_svm_0.897.mat")
% load("my_svm_0.881.mat")
imageDir = 'test_images';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);

bboxes = zeros(0,4);
confidences = zeros(0,1);
image_names = cell(0,1);

% (best) cellSize = 4, dims = 144
%  cellSize = 4, dims = 81
cellSize = 4;   
dims = 144;
dim = sqrt(dims);

% Parameters
% =================================================================
powerThreshold = 0.7;           % detection confidence level threshold
overlapThreshold = 0.5;         % standard box ratio threshold
boxEclipseThreshold = 0.5;      % box ratio threshold used when boxes are imbalanced due to scaling
minScale = 0.1;                 % starting scaling factor
maxScale = 0.9;                 % ending scaling factor
incrementScale = 0.1;           % scale increments
topIndices = 75;                % number of top indices to include
% =================================================================

fprintf("\nProcessing image:\t");

for i=1:nImages
    % reinitialize variables
    thisImgbboxes = zeros(0,4);
    thisConfidences = zeros(0,1);
    thisScale = zeros(0,1);
    
    % load and show the image
    clf;
    img = im2single(imread(sprintf('%s/%s',imageDir,imageList(i).name)));
    imshow(img);
    hold on;
    
%     extra magnification if the image is too small
    if sum(size(img))/36 < 50
        adjustMaxScale = round(maxScale*1.2,1);
    else
        adjustMaxScale = maxScale;
    end
    
    
    % Start scaling here
    for scale=minScale:incrementScale:adjustMaxScale
    
        im = imresize(img,scale);
        im = histeq(im);

%         imshow(im);
%         hold on;

        % generate a grid of features across the entire image. you may want to 
        % try generating features more densely (i.e., not in a grid)
        feats = vl_hog(im,cellSize);


        % concatenate the features into 6x6 bins, and classify them (as if they
        % represent 36x36-pixel faces)
        [rows,cols,~] = size(feats);    
        confs = zeros(rows,cols);
        for r=1:rows-(dim-1)            
            for c=1:cols-(dim-1)        
                toRow = r+(dim-1);      
                toCol = c+(dim-1);      
                tempVec = feats(r:toRow, c:toCol,:);
                confs(r,c) = tempVec(:)'*Weight + Bias;
%                 confs(r,c) = [tempVec(:)' feat2 ]*Weight + Bias;      % extra feature deprecated
            % create feature vector for the current window and classify it using the SVM model, 
            % take dot product between feature vector and w and add b,
        % store the result in the matrix of confidence scores confs(r,c)

            end
        end


        % get the most confident predictions 
        [pwr,inds] = sort(confs(:),'descend');
        inds = inds(1:min(topIndices,size(inds,1))); % (use a bigger number for better recall)
        boxLength = dim*(cellSize-1);
        for n=1:numel(inds)        
            if (pwr(n) < powerThreshold)  % skip ones with low confidence
                continue
            end
            [row,col] = ind2sub([size(feats,1) size(feats,2)],inds(n));

            bbox = [ round(col*cellSize/scale) ...
                     round(row*cellSize/scale) ...
                     (round(col*cellSize/scale) + round(dim*(cellSize-1)/scale))...
                     (round(row*cellSize/scale) + round(dim*(cellSize-1)/scale))];
            conf = confs(row,col);
            image_name = {imageList(i).name};

    %         % plot
    %         plot_rectangle = [ ...
    %             bbox(1), bbox(2); ...
    %             bbox(1), bbox(4); ...
    %             bbox(3), bbox(4); ...
    %             bbox(3), bbox(2); ...
    %             bbox(1), bbox(2); ...
    %             ];
    %         plot(plot_rectangle(:,1), plot_rectangle(:,2), 'g-');

            % save         
            thisImgbboxes = [thisImgbboxes; bbox];
            thisConfidences = [thisConfidences; conf];
            thisScale = [thisScale; scale];
        end
    
    end
    % Finish Scaling here
    
    % Manipulating numbers to see which boxes to keep or to remove.
    playgrdSize = size(thisConfidences,1);
    sort_playgrd = cat(2, thisImgbboxes, thisConfidences, ones(playgrdSize,1), zeros(playgrdSize,1)-1, thisScale);
    sort_playgrd = sortrows(sort_playgrd,[5 1 2], 'descend');
    for p = 1:size(sort_playgrd,1)
        if sort_playgrd(p,6) <= 0
            continue;   % if this point is global dead, skip to next iteration
        end
        sort_playgrd(p,6) = 102; % mark current
        
        for q = p:size(sort_playgrd,1)

            
            if sort_playgrd(p,6) <= 0
                sort_playgrd(q,7) = -1;
                continue;   % if this point is global dead, skip to next iteration
            end 
            
            pLen = abs(sort_playgrd(p,3) - sort_playgrd(p,1));
            qLen = abs(sort_playgrd(q,3) - sort_playgrd(q,1));
            
            overlapLeft = max(sort_playgrd(p,1),sort_playgrd(q,1));
            overlapRight = min(sort_playgrd(p,3),sort_playgrd(q,3));
            overlapTop = max(sort_playgrd(p,2), sort_playgrd(q,2));
            overlapBottom = min(sort_playgrd(p,4), sort_playgrd(q,4));
            
%             at least 0
            colDiff = max(0,overlapRight - overlapLeft);
            rowDiff = max(0,overlapBottom - overlapTop);
            
            
            areaPc = (colDiff * rowDiff) / (pLen^2 + qLen^2 - (colDiff * rowDiff));

            
            % detect when a bigger box (due to image shrinkage), eclipses
            % smaller boxes; dominating the area.
            minSqPc = (colDiff * rowDiff) / min(pLen^2, qLen^2);
            if (minSqPc > boxEclipseThreshold && areaPc < 0.5)
%                 fprintf("[Imbalance] p=%3d\tq=%3d\tareaPC=%.4f\t\tminSqPc=%.4f\n", p, q, areaPc, minSqPc);
                sort_playgrd(q,7) = minSqPc; % use biased overlap ratio
            else
                sort_playgrd(q,7) = areaPc; % use equal-grounds overlap ratio
            end
        end
        fprintf("");
        relevantIndices = find((sort_playgrd(:,7) <= 1) & (sort_playgrd(:,7) > overlapThreshold));
        sort_playgrd(relevantIndices(2:end), 6) = -1;
        sort_playgrd(relevantIndices(1),6) = 200;           % mark as global ok
        sort_playgrd(:,7) = 0;                              % reset all local to 0
        
        
        % plot
        plot_rectangle = [ ...            
            sort_playgrd(relevantIndices(1),1), sort_playgrd(relevantIndices(1),2);...
            sort_playgrd(relevantIndices(1),1), sort_playgrd(relevantIndices(1),4);...
            sort_playgrd(relevantIndices(1),3), sort_playgrd(relevantIndices(1),4);...
            sort_playgrd(relevantIndices(1),3), sort_playgrd(relevantIndices(1),2);...
            sort_playgrd(relevantIndices(1),1), sort_playgrd(relevantIndices(1),2);...
            ];
        plot(plot_rectangle(:,1), plot_rectangle(:,2), 'g-');
    end
    
    
    bboxes = [bboxes; sort_playgrd(sort_playgrd(:,6) == 200,1:4)];
    confidences = [confidences; sort_playgrd(sort_playgrd(:,6) == 200,5)];
    image_names = [image_names; repelem(image_name,sum(sort_playgrd(:,6) == 200))'];
    
%     pause;
%     fprintf('got preds for image %d/%d\n', i,nImages);
    fprintf("%d",mod(i,10))
end

fprintf(" done.\n");

% evaluate
label_path = 'test_images_gt.txt';
[gt_ids, gt_bboxes, gt_isclaimed, tp, fp, duplicate_detections] = ...
    evaluate_detections_on_test(bboxes, confidences, image_names, label_path);
