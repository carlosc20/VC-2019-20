function smoothed = Gaussian_smoothing(I,filterParams)
    I = double(I)/255;

    %%%%% smooth
    hsize = 10;     % kernel size
    sigma = 5;      % standard deviation
    
    nargs = size(filterParams,2);
    if nargs > 0
        hsize = filterParams(1);
    end
    if nargs > 1
        sigma = filterParams(2);
    end
    
    h = fspecial('gaussian', hsize, sigma);
    smoothed = imfilter(I,h);
end

