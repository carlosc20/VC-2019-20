function [ preProcNI, radii, centers, edgeI, radiiN, centersN, edgeNI, SNR ] = main_image_recognition( I, noiseType, noiseParams )
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

        F = imgaussfilt(noisyI, 0.5);
    end

    if strcmp( noiseType, 'salt & pepper' )
        d = 0.05;      % default noise density, 

        if nargs > 0 
            d = noiseParams(1);
        end

        noisyI = imnoise( I, 'salt & pepper', d );

        F = medfilt2(noisyI);
    end
    
    % Output: Signal-to-noise ratio of noisy image
    SNR = snr(I, noisyI - I);

    
    %% Pre-processing

    I = preproc(I);

    noisyI = preproc(F);

    % Output: Pre-processed image
    preProcNI = noisyI;


    %% Segmentation

    % Output: binary edges image, radii and centers of detected circles, with and without noise;
    [ radii, centers, edgeI ] = findCircles(I, [0.1 0.4], [50 150], 0.93);
    [ radiiN, centersN, edgeNI ] = findCircles(noisyI, [0.1 0.4], [50 150], 0.93);
end


function [ radii, centers, J ] = findCircles(I, threshold, radiusRange, sensitivity)
    % reduz resolu��o da imagem para facilitar o processamento
    while size(I,1) >= 1500 || size(I,2) >= 1500
        I = impyramid(I, 'reduce');
    end

    pcount = 0;
    while true
        E = edge(I,'Canny',[0.1 0.4]);
        [centers, radii] = imfindcircles(E,radiusRange,'ObjectPolarity','bright','Sensitivity',sensitivity);
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

    J = I;
end


function J = preproc( I )
    I = adapthisteq(I);

    se = strel('disk',25);
    I = imtophat(I,se);

    J = imadjust(I);
end


