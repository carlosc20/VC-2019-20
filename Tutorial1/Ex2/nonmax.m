function I = nonmax(Magnitude, Orientation)
%   Rad to Degree
    O = rad2deg(Orientation);
%   Size of the image
    lines = size(O,1);
    cols = size(O,2);
    
    %Passar todos os angulos negativos ou maiores de 360 para maiores de 0
    %e menores de 360
    for i=1:lines
        for j=1:cols
            while O(i,j)<0
                O(i,j)=360+O(i,j);
            end
        end
    end
    
%   Usando a orientação, transforma anglos para 0º, 45º, 90º ou 135º
    angles = zeros(lines, cols);
    for i = 1  : lines
        for j = 1 : cols
            if ((O(i, j) >= 0  && O(i, j) < 22.5) || (O(i, j) >= 157.5 && O(i, j) < 202.5) || (O(i, j) >= 337.5 && O(i, j) <= 360))
                angles(i, j) = 0;
            elseif ((O(i, j) >= 22.5 && O(i, j) < 67.5) || (O(i, j) >= 202.5 && O(i, j) < 247.5))
                angles(i, j) = 45;
            elseif ((O(i, j) >= 67.5 && O(i, j) < 112.5) || (O(i, j) >= 247.5 && O(i, j) < 292.5))
                angles(i, j) = 90;
            elseif ((O(i, j) >= 112.5 && O(i, j) < 157.5) || (O(i, j) >= 292.5 && O(i, j) < 337.5))
                angles(i, j) = 135;
            end
        end
    end
    
%   Poem 0 onde deve ser 0 e poem 1 onde fica igual a Magnitude(i,j)
    I = zeros(lines,cols);
    for i=2:lines-1
        for j=2:cols-1
            if(angles(i,j)==0)
                I(i,j) = Magnitude(i,j) == max([Magnitude(i,j), Magnitude(i,j-1), Magnitude(i,j+1)]);
            elseif(angles(i,j)==45)
                I(i,j) = Magnitude(i,j) == max([Magnitude(i,j), Magnitude(i+1,j-1), Magnitude(i-1,j+1)]);
            elseif(angles(i,j)==90)
                I(i,j) = Magnitude(i,j) == max([Magnitude(i,j), Magnitude(i-1,j), Magnitude(i+1,j)]);
            elseif(angles(i,j)==135)
                I(i,j) = Magnitude(i,j) == max([Magnitude(i,j), Magnitude(i-1,j-1), Magnitude(i+1,j+1)]);
            end
        end
    end
    
%   Aplica I(i,j) = 0              ,se Magnitude(i,j) for menor a pelo menos um dos 2 vizinhos, dependendo da direçao
%                   Magnitude(i,j) ,else
    I = I.*Magnitude;
end

