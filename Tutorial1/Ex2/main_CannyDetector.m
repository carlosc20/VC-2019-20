function [G, T, H] = main_CannyDetector(I,imgpath, smoothing, threshold)
    kernel = smoothing(1);
    sigma = smoothing(2);
    
    lowThreshold = threshold(1);
    highThreshold = threshold(2);
    
    S = Gaussian_smoothing(I, [kernel,sigma]);
    [G,O] = gradient(S);

    T = nonmax(G,O);
    
    %highThreshold = 0.25;
    %lowThreshold = 0.125;
    
    [L,strongEdges,~] = double_threshold(T, lowThreshold, highThreshold);

    H = hysteresis_thresholding(L,strongEdges);
    
    BeforeNonMax = strcat(imgpath, '_edge_canny_', num2str(kernel), '_', num2str(sigma), '.png');
    AfterNonMax = strcat(imgpath, '_edge_canny_nonmax_', num2str(kernel), '_', num2str(sigma), '.png');
    AfterHysteresis = strcat(imgpath, '_edge_canny_hysteresis_', num2str(kernel), '_', num2str(sigma), '.png');    
    
    imwrite(G, BeforeNonMax);
    imwrite(T, AfterNonMax);
    imwrite(H, AfterHysteresis);
    
    %figure('Name', 'Smooth');imshow(S);
    %figure('Name', 'Gradiente');imshow(G);
    %figure('Name', 'Orientation');imshow(O);
    %figure('Name', 'NonMax');imshow(T);
    %figure('Name', 'Double Thresh');imshow(L);
    figure('Name', 'Hysteresis');imshow(H);
end

