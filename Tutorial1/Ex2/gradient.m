function [Gradient, Orientation] = gradient(I)
    SobelH = [ 1  2  1 
               0  0  0
              -1 -2 -1];
    SobelV = [-1 0 1
              -2 0 2
              -1 0 1];
    
    Gh = im2double(imfilter(I,SobelH));
    Gv = im2double(imfilter(I,SobelV));
    
    Gv = Gv.*(-1);
    
    Gradient = sqrt((Gh.^2)+(Gv.^2));
    Orientation = atan2(Gh,Gv);

end