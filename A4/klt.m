%% Detect HC
clear;
im1 = imread('Sequences\hotel\hotel.seq0.png');


winLen = 7;
threshold = 1e-3;
radiusThres = 225;

fprintf("Finding Harris Corners...");
[hcRow1, hcCol1] = hc(im1, radiusThres, threshold);
fprintf(" done.\n");

imshow(im1);
hold on;
plot(hcCol1,hcRow1,'+','Color','r','LineWidth',1);
pause(1);

%% Sample 20 pairs

% index of 20
splIdx = randperm(size(hcCol1,1),40);
% splPairs = [hcRow(splIdx) hcCol(splIdx)];

% 20 pairs coordinates
splPairs = [max(1,hcRow1(splIdx)-winLen)...
            max(1,hcCol1(splIdx)-winLen)...
            min(size(im1,1),hcRow1(splIdx)+winLen)...
            min(size(im1,2),hcCol1(splIdx)+winLen) ];

%% Combine all images to a 3D matrix
allImg = im2double(im2gray(im1));
for frameIndex=1:48
    thisIm = imread('Sequences\hotel\hotel.seq'+string(frameIndex)+'.png');
    thisIm = im2double(im2gray(thisIm));
    allImg = cat(3,allImg,thisIm);
end

%% Retrieve Optical Flow for 20 boxes

flowWindow = 9;
edgeKiller = ((flowWindow-1)/2)+1;
noOfBoxes = 20;
boxIndex = 1;

fprintf("Calculating u, v for window #: ");

while boxIndex <= noOfBoxes
    
    fprintf(boxIndex + " ");
    startRow = splPairs(boxIndex, 1);
    endRow = splPairs(boxIndex, 3);
    startCol = splPairs(boxIndex, 2);
    endCol = splPairs(boxIndex, 4);
    

    rowOffset = 0;
    colOffset = 0;
    
    for frameIndex=1:48
        tempStartRow = startRow + round(rowOffset);
        tempEndRow = endRow + round(rowOffset);
        tempStartCol = startCol + round(colOffset);
        tempEndCol = endCol + round(colOffset);
        
        if tempEndRow > size(im1,1) || tempEndCol > size(im1,2)
            fprintf("(break@" + frameIndex + ") ");
            break;
        end
        
        window1 = allImg(tempStartRow:tempEndRow, tempStartCol:tempEndCol, frameIndex);
        window2 = allImg(tempStartRow:tempEndRow, tempStartCol:tempEndCol, frameIndex+1);
        
%         subplot(1,2,1);imshow(window1);title('Before');
%         subplot(1,2,2);imshow(window2);title('After');
        
        [u, v, ~] = myFlow(window1, window2, 0.01, flowWindow);
        
        rowOffset = rowOffset - v(8,8);
        colOffset = colOffset - u(8,8);
        


        if frameIndex == 1 && boxIndex == 1
            windowsTracker = [boxIndex frameIndex tempStartRow+7 tempStartCol+7];
        else
            windowsTracker = [windowsTracker;...
                boxIndex frameIndex tempStartRow+7 tempStartCol+7];
        end
        

        
    end
    fprintf("");
    

    
    boxIndex = boxIndex + 1;
end

fprintf(" done. \n");

% windowsTracker = [windowsTracker(1:end-1,:) windowsTracker(2:end,3:4)];


%% Displaying results

fprintf("Drawing results... ");

fps = 2;

for frameIndex=0:48
    thisIm = imread('Sequences\hotel\hotel.seq'+string(frameIndex)+'.png');
    imshow(thisIm);
    hold on;
    
    for winIndex = 1:max(windowsTracker(:,1))
        x = windowsTracker(windowsTracker(:,1) == winIndex & windowsTracker(:,2) <= frameIndex, 4);
        y = windowsTracker(windowsTracker(:,1) == winIndex & windowsTracker(:,2) <= frameIndex, 3);
        plot(x, y,'Color','g','LineWidth',2)
    end
    


    pause(1/fps);
    
end

fprintf(" done.\n\n");


