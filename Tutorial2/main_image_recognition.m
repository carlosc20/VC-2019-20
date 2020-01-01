function [ preProcI, segI, segNoisyI, SNR, coinRadii, coinCount ] = main_image_recognition( I, noiseType, noiseParams )

nargs = size(noiseParams,2);

%% Introduce noise
if strcmp( noiseType, 'gaussian' )
    m = 0;                % default mean
    var_gauss = 0.01;     % default variance
    
    if nargs > 0
        m = noiseParams(1);
    end
    if nargs > 1
        var_gauss = noiseParams(2);
    end
    
    noisyI = imnoise( I, 'gaussian', m, var_gauss );
end

if strcmp( noiseType, 'salt & pepper' )
    d = 0.05;      % default noise density, 
    
    if nargs > 0 
        d = noiseParams(1);
    end
    
    noisyI = imnoise( I, 'salt & pepper', d );
end

% Output: Signal-to-noise ratio of noisy image
SNR = snr(I, noisyI - I);


%% Pre-processing

I = adapthisteq(I);

se = strel('disk',25);
I = imtophat(I,se);

I = imadjust(I);
figure; imshow(I);  

% Output: Pre-processed image
preProcI = I;


%% Segmentation

% reduz resolução da imagem para facilitar o processamento
while size(I,1) >= 1500 || size(I,2) >= 1500
    I = impyramid(I, 'reduce');
end

pcount = 0;
while true
    E = edge(I,'Canny', [0.1 0.4]);
    figure; imshow(E);  
    [centers, radii] = imfindcircles(E,[50 150],'ObjectPolarity','bright','Sensitivity',0.93);
    count = size(centers,1);

    if count < pcount
      centers = pcenters;
      radii = pradii;
      I = pI;
      break;
    end

    if size(I,1) <= 600 || size(I,2) <= 600
    break;
    end

    pcenters = centers;
    pradii = radii;
    pcount = count;
    pI = I;

    I = impyramid(I, 'reduce');
end


% edge + posição circulos
figure('Name','Edge'); imshow(I); axis on;
viscircles(centers, radii,'EdgeColor','r','LineWidth',2);

% Output: Segmented image with and without noise;
segI = 0;
segNoisyI = 0; 


%% Result analysis

% Output: Total number of coins
coinCount = size(centers,1);

% Output: Coins radii
coinRadii = radii;


end

