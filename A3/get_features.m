close all
clear
run('../vlfeat-0.9.21/toolbox/vl_setup')

pos_imageDir = 'cropped_training_images_faces';
% pos_imageDir = 'e:\cropped_training_images_faces\';     % local source to improve performance
pos_imageList = dir(sprintf('%s/*.jpg',pos_imageDir));
pos_nImages = length(pos_imageList);

neg_imageDir = 'cropped_training_images_notfaces';
% neg_imageDir = 'e:\cropped_training_images_notfaces\';  % local source to improve performance
neg_imageList = dir(sprintf('%s/*.jpg',neg_imageDir));
neg_nImages = length(neg_imageList);


cellSize = 3;
% cellSize = 6;
% to find the size of the square matrix.
im = im2single(imread(sprintf('%s/%s',pos_imageDir,pos_imageList(1).name)));
matSize = size(im,1)/cellSize;

% featSize = 31*cellSize^2;
featSize = 31*matSize^2;

binSize = 20;   % extra feature

fprintf("Generating positive images features...\n");    
pos_feats = zeros(pos_nImages,featSize);
% pos_feats2 = zeros(pos_nImages,binSize);    % extra feature (deprecated)

for i=1:pos_nImages
    im = im2single(imread(sprintf('%s/%s',pos_imageDir,pos_imageList(i).name)));
%     imInner = im(6:end-6,6:end-6);      % extra feature (deprecated)

%     randomly flips faces
    if randi([0 1]) == 1
        im = flip(im,2);
    end

    feat = vl_hog(im,cellSize);
    pos_feats(i,:) = feat(:);
%     pos_feats2(i,:) = histcounts(im(:),binSize) / prod(size(im)-1);   % extra feature
    
    
    if (mod(i,10) == 0)
        fprintf(".");
        if (mod(i,500) == 0)
            fprintf("\n@"+i+ "\t");
        end
    end
    
    
%     fprintf('got feat for pos image %d/%d\n',i,pos_nImages);    
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end

fprintf("\n\nGenerating negative images features...\n");    
neg_feats = zeros(neg_nImages,featSize);
neg_feats2 = zeros(pos_nImages,binSize);    % extra feature

for i=1:neg_nImages
    im = im2single(imread(sprintf('%s/%s',neg_imageDir,neg_imageList(i).name)));
%     imInner = im(6:end-6,6:end-6);  % extra feature

    
    feat = vl_hog(im,cellSize);
    neg_feats(i,:) = feat(:);
%     neg_feats2(i,:) = histcounts(im(:),binSize) / prod(size(im)-1);   % extra feature

    
    if (mod(i,10) == 0)
        fprintf(".");
        if (mod(i,500) == 0)
            fprintf("\n@"+i+ "\t");
        end
    end
%     fprintf('got feat for neg image %d/%d\n',i,neg_nImages);
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end
% pos_feats = [pos_feats, pos_feats2];        % extra feature (deprecated)
% neg_feats = [neg_feats, neg_feats2];        % extra feature (deprecated)


save('pos_neg_feats.mat','pos_feats','neg_feats','pos_nImages','neg_nImages')