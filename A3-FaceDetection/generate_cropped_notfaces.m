% you might want to have as many negative examples as positive examples
n_have = 0;
n_want = numel(dir('cropped_training_images_faces/*.jpg'));

imageDir = 'images_notfaces';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);

new_imageDir = 'cropped_training_images_notfaces';
mkdir(new_imageDir);

dim = 36;

stringStream = "";

fprintf("Cropping files");
while n_have < n_want
    if (mod(n_have,10) == 0)
        fprintf(".");
        if (mod(n_have,500) == 0)
            fprintf("\n@"+n_have+ "\t");
        end
    end
        
    imgidx = randi(nImages);
    filepath = imageList(imgidx).folder +"\"+ imageList(imgidx).name;
    img = im2gray(imread(filepath));
    imgDim = size(img);
    if (imgDim(1) >= dim && imgDim(2) >= dim)
        randRow = randi(imgDim(1)-dim);
        randCol = randi(imgDim(2)-dim);
        
    end
    
%     imwrite(img(randRow:randRow+dim,randCol:randCol+dim,:),new_imageDir + "\cropped-"+n_have+".jpg");
    if randi([0 1]) == 0
        imwrite(img(randRow:randRow+dim-1,randCol:randCol+dim-1,:),"e:\cropped_training_images_notfaces\cropped-"+n_have+".jpg");
    else
        imwrite(img(randRow:randRow+dim-1,randCol:randCol+dim-1,:)',"e:\cropped_training_images_notfaces\cropped-"+n_have+".jpg");
    end
    
    
    % generate random 36x36 crops from the non-face images
    n_have = n_have+1;
    
end
fprintf(" Done.\n");