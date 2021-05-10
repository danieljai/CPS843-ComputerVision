function [outimg] = CarvingHelper(inimg)

Gx = [1,0,-1;2,0,-2;1,0,-1];
Gy = [1,2,1;0,0,0;-1,-2,-1];

workingimg = inimg;

[row,col] = size(workingimg(:,:,1));



derivXr = imfilter(workingimg(:,:,1), Gx,'conv');
derivYr = imfilter(workingimg(:,:,1), Gy,'conv');

gradmagR = sqrt(derivXr.^2 + derivYr.^2);

derivXg = imfilter(workingimg(:,:,2), Gx,'conv');
derivYg = imfilter(workingimg(:,:,2), Gy,'conv');

gradmagG = sqrt(derivXg.^2 + derivYg.^2);

derivXb = imfilter(workingimg(:,:,3), Gx,'conv');
derivYb = imfilter(workingimg(:,:,3), Gy,'conv');

gradmagB = sqrt(derivXb.^2 + derivYb.^2);


Energy = gradmagR + gradmagG + gradmagB;

% [row, col] = size(Energy);

scoreM = zeros(row, col);

scoreM(1,:) = Energy(1,:);

for i=2:1:row
    for j=1:1:col
        if (j==1)
            scoreM(i,j) = Energy(i,j)+ min(scoreM(i-1,j),scoreM(i-1,j+1));
        elseif (j==col)
            scoreM(i,j) = Energy(i,j)+ min(scoreM(i-1,j-1),scoreM(i-1,j));
        else
            scoreM(i,j) = Energy(i,j)+ min([scoreM(i-1,j),scoreM(i-1,j-1),scoreM(i-1,j+1)]);
        end
    end
end


% while(col > width)

    %traceback

    trace = zeros(row,1);
    [val,j] = min(scoreM(row,:));   % in rows?
    i = row;
    trace(i) = j;
    while (i > 1)
        i=i-1;
        if (j~=1) && (j~=col)
            if (scoreM(i,j) <= scoreM(i,j+1)) && (scoreM(i,j) <= scoreM(i,j-1))   % have to add <=; giving priority to straight up
                j = j;
            elseif (scoreM(i,j-1) < scoreM(i,j)) && (scoreM(i,j-1) < scoreM(i,j+1))
                j = j-1;
            else
                j = j+1;
            end
        elseif (j == 1)
            if (scoreM(i,j) <= scoreM(i,j+1)) 
                j = j;
            elseif (scoreM(i,j+1) < scoreM(i,j))
                j = j+1;
            end
        elseif (j == col)
            if (scoreM(i,j) <= scoreM(i,j-1))
                j = j;
            elseif (scoreM(i,j-1) < scoreM(i,j))
                j = j-1;
            end
        end 
        trace(i) = j;
    end

    for i=1:1:row
        workingimg(i,trace(i):col-1,:)=workingimg(i,trace(i)+1:col,:);      
    end
    col = col-1;
    outimg=workingimg(:,1:col,:);
    
    




end