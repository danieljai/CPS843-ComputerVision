function [outimg, nextlast] = ExpandHelper2(inimg, lastmin,expand)

Gx = [1,0,-1;2,0,-2;1,0,-1];
Gy = [1,2,1;0,0,0;-1,-2,-1];

workingimg = inimg;

[row,col] = size(workingimg(:,:,1));

outimg = zeros(row,col+1,3);

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

    
    threshold = col/(2*expand);
    
    trace = zeros(row,1);
    
    if (size(lastmin) == 1)
        [~, tempcol] = min(scoreM(row,:));
        trace(row) = tempcol;
        nextlast = [lastmin;trace(row)];
    else
        sorted = sort(scoreM(row,:));
        foundmin = 0;
        
        j = 1;
        while (foundmin == 0)
            currmin = 0;
            for k=1:1:col
                if (sorted(j) == scoreM(row,k)) && (currmin ==0)
                    currmin = k;
                end
            end
            tooclose = 0;
            for count=1:1:size(lastmin)
                if (abs(currmin-lastmin(count)) < threshold)
                    tooclose = 1;
                end
            end
            if (tooclose == 0)
                foundmin = j;
            end
            j=j+1;
        end
       
        for j=1:1:col
            if (sorted(foundmin) == scoreM(row,j))   % in rows?
                trace(row) = j;
            end
        end

        nextlast = [lastmin;trace(row)];
    
    end
    
    j = trace(row);
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
        outimg(i,1:trace(i),:) = workingimg(i,1:trace(i),:);
        if (trace(i)==col)
            outimg(i,trace(i)+1,:) = workingimg(i,trace(i),:);
        else
            outimg(i,trace(i)+1,:) = 0.5*(workingimg(i,trace(i),:)+workingimg(i,trace(i)+1,:));
        end
        outimg(i,trace(i)+2:col+1,:)=workingimg(i,trace(i)+1:col,:);
        
    end
    

end