function [hcRow, hcCol] = hc(im, radiusThres, globalThreshold)

frame = im2double(im2gray(im));

sigma = 5;

g = fspecial('gaussian', 2*sigma*3+1, sigma);
dx = [-1 0 1;-1 0 1; -1 0 1];

Ix = imfilter(frame, dx, 'symmetric', 'same');
Iy = imfilter(frame, dx', 'symmetric', 'same');
Ix2 = imfilter(Ix.^2, g, 'symmetric', 'same');
Iy2 = imfilter(Iy.^2, g, 'symmetric', 'same');
Ixy = imfilter(Ix.*Iy, g, 'symmetric', 'same');
k = 0.04; % k is between 0.04 and 0.06
% --- r = Det(M) - kTrace(M)^2 ---
r = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;

newR = r;
newR(newR < globalThreshold) = 0;

[rowy, colx, val] = find(newR);

newRlist = [rowy colx val zeros(size(rowy,1),3)];
newRlist = sortrows(newRlist, 3, 'descend');

% New NMS
for i = 1:size(newRlist,1)
    
    if newRlist(i,5) < 0
        continue;               % skip disqualified points
    else
        newRlist(:,4) = 0;      % reset 0
        newRlist(i,5) = 200;    % mark as current and ok.    
    end
    
    
    newRlist(i+1:end,4) = (newRlist(i+1:end,1)-newRlist(i,1)).^2 ...
        + (newRlist(i+1:end,2)-newRlist(i,2)).^2;
    
    % disqualify point that are not: 200, negative, and under threshold
    % mark it with -i, the index of the point that disqualifies it
    newRlist(~(newRlist(:,5) == 200 | newRlist(:,5) < 0) & newRlist(:,4) < radiusThres, 5) = -i;
    
    
end

% winners = newRlist(newRlist(:,5) == 200,1:3);
hcRow = newRlist(newRlist(:,5) == 200,1);
hcCol = newRlist(newRlist(:,5) == 200,2);

fprintf("");

% points = detectHarrisFeatures(im)
% imshow(im);hold on;
% plot(points.selectStrongest(50));

% NMS
% for iRow=1 : size(newR,1)
%     for iCol=1 : size(newR,2)
%         window = newR(max(1,iRow-windowLen):min(size(newR,1),iRow+windowLen) , max(1,iCol-windowLen):min(size(newR,2),iCol+windowLen));
%         if newR(iRow,iCol) < max(window(:))
%             newR(iRow,iCol) = 0;
%         end
%     end
% end
% 
% 
% [hcRow, hcCol] = find(newR);

end