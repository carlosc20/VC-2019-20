function [T,strongEdges,weakEdges] = double_threshold(L, T_Low, T_High)    
    [h, w]=size(L);
    
    T = L;
    
    strongEdges = zeros(h,w); % Keep track of the strong edge
    weakEdges = zeros(h,w);  % Keep track of the weak edge
    
    for i=2:h-1 % row
        for j=2:w-1 % col
            if T(i,j) > T_High      % Strong edge
                T(i,j) = 1;
                strongEdges(i,j) = 1;
            elseif T(i,j) < T_Low   % No edge
                T(i,j) = 0;
            else                    % Weak edge      
                T(i,j) = 0.5;
                weakEdges(i,j) = 1;
            end
        end
    end
end

