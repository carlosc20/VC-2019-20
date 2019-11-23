function [noisy,smoothed] = Gaussian_smoothing(I,noiseParams,filterParams)
    I = double(I)/255;

    %%%%% noise
    m = 0;                % default mean
    var_gauss = 0.01;     % default variance
    
    nargs = size(noiseParams,2);
    if nargs > 0
        m = noiseParams(1);
    end
    if nargs > 1
        var_gauss = noiseParams(2);
    end
    
    % adds Gaussian white noise with mean m and variance var_gauss.
    noisy = imnoise(I,'gaussian',m,var_gauss);


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
    smoothed = imfilter(noisy,h);
end

