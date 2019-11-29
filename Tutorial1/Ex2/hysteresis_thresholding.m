function [H] = hysteresis_thresholding(L,strongEdges)
    [h, w] = size(strongEdges);
    H = L;
    for i=1:h
        for j=1:w
            if(strongEdges(i,j)==1)
                H = connectWeakEdges(H,i,j);
            end
        end
    end
    
    for i=1:h
        for j=1:w
            if(H(i,j)~=1)
                H(i,j) = 0;
            end
        end
    end
end

function [H] = connectWeakEdges(H, row, col)
    for i=-3:1:3
        for j=-3:1:3
            if (row+i > 0) && (col+j > 0) && (row+i < size(H,1)) && (col+j < size(H,2))
                if (H(row+i,col+j) > 0) && (H(row+i,col+j) < 1)
                    H(row+i,col+j) = 1;
                    H = connectWeakEdges(H, row+i, col+j);
                end
            end
        end
    end
end

