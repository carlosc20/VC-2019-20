function [ preProcI, segI, segNoisyI, SNR, sizeHist, coinDist ] = main_image_recognition( I, noiseType, noiseParams )

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

% Output: Signal-to-noise ratio
SNR = snr(I, noisyI - I);



%% Pre-processing

I = adapthisteq(I);
preProcI = I;
         

%% Segmentation
%{
%%% Convert the image into binary form 
% adaptive thresholding
level = adaptthresh(I,0.5,'ForegroundPolarity','dark');
BW = imcomplement(imbinarize(I,level));

%%% Clean up the thresholded image
% morphological operators
SE = strel('disk',10); % disco com raio 10
BW2 = imclose(BW, SE); % fills the gaps between regions

BW3 = imfill(BW2,'holes'); % region filling
imshowpair(BW2,BW3,'montage')

BW3 = impyramid(impyramid(BW3, 'reduce'), 'reduce');
%BW3 = imresize(BW3, 0.25);

imshow(BW3);
axis on;
[centers, radii] = imfindcircles(BW3,[30 90],'ObjectPolarity','bright');
%[centers, radii] = imfindcircles(BW3,[30 75],'ObjectPolarity','bright');
viscircles(centers, radii,'EdgeColor','r','LineWidth',4);
centers
radii

% BW4 = bwmorph(BW3,'remove');
%}

%

% reduz resolução da imagem para facilitar o processamento
while size(I,1) >= 1500 || size(I,2) >= 1500
    I = impyramid(I, 'reduce');
end

pcount = 0;

while true
    E = edge(I,'Canny', [0.1 0.4]);
    [centers, radii] = imfindcircles(E,[50 150],'ObjectPolarity','bright','Sensitivity',0.91);
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

figure('Name','Edge'); imshow(I); axis on;
viscircles(centers, radii,'EdgeColor','r','LineWidth',2);


%


% Output: Segmented image with and without noise;
segI = 0;
segNoisyI = 0; 


%% Result analysis
%{

stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength')

stats = regionprops('table',BW,{'Area','Centroid'})
%percorrer prop.Area
%}


% Output: Number and type of coins available in the image e total
coinDist = size(centers,1);

% Output: Histogram showing the distribution of object sizes
% Either area or radius could be used as a size measure
sizeHist = histogram(radii);
xlabel('raio');
ylabel('número');

end

