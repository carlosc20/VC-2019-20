function [ preProcI, segI, segNoisyI, SNR, sizeHist, coinDist ] = main_image_recognition( I, noiseType, noiseParams )

nargs = size(noiseParams,2);

%%% Introduce noise
if strcmp( noiseType, 'gaussian' )
    m = 0;                % default mean
    var_gauss = 0.01;     % default variance
    
    if nargs > 0
        m = noiseParams(1);
    end
    if nargs > 1
        var_gauss = noiseParams(2);
    end
    
    % adds Gaussian white noise with mean m and variance var_gauss
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



%%%%% Pre-processing
% Process  the  image,  when  necessary,  using  pre-processing  
% techniques,  such  as filtering methods, contrast equalization, 
% normalization, among other techniques. 



preProcI = 0;




%%%%% Segmentation
% Suggest and use a sequence of functions that solves the task of 
% segmenting all of the coins in the image. 

% convert image into binary form
% level = graythresh(I); % global Otsu bom no coins2?
level = adaptthresh(I,0.5,'ForegroundPolarity','dark'); % bom com coins3
BW = imbinarize(I,level);

imshowpair(I,BW,'montage')
% clean up the thresholded image

%{
SE = strel('disk',5); % raio
BW2 = imclose(BW, SE); % remove tiny regions

SE = strel('disk',10); % raio
BW3 = imclose(BW2, SE); % fills the gaps between regions

BW2 = bwmorph(BW,'thin');
BW2 = imfill(BW,'holes');


%}

% extract individual objects


%{
[centers, radii] = imfindcircles(BW,[275 325],'ObjectPolarity','dark');
viscircles(centers, radii,'EdgeColor','b');
centers
%}


% describe the objects

% Template Matching -> Hough transform




% Output: Segmented image with and without noise;
segI = 0;
segNoisyI = 0; 



%{

stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength')

stats = regionprops('table',BW,{'Area','Centroid'})
%percorrer prop.Area
%}


% Output: Number and type of coins available in the image; e total
coinDist = 0;

% Output: Histogram showing the distribution of object sizes; 
% Either area or radius could be used as a size measure
sizeHist = 0;


end

