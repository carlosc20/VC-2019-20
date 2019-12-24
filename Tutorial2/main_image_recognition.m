function [ preProcI, segI, segNoisyI, SNR, sizeHist, coinDist ] = main_image_recognition( I )



%%% Introduce noise
m = 0;
var_gauss = 0.01;
noisyI = imnoise(I,'gaussian',m,var_gauss);

% Output: Signal-to-noise ratio
SNR = snr(I, noisyI - I);



%%% Pre-processing
% Process  the  image,  when  necessary,  using  pre-processing  
% techniques,  such  as filtering methods, contrast equalization, 
% normalization, among other techniques. 

% isto é preproc ou segmentation?
level = graythresh(I); % Thresholding: Otsu
BW = imbinarize(I,level); % horrivel


imshowpair(I,BW,'montage')

% Output: Pre-processed image
preProcI = 0;



%%% Segmentation
% Suggest and use a sequence of functions that solves the task of 
% segmenting all of the coins in the image. 

% Template Matching -> Hough transform



% Output: Segmented image with and without noise;
segI = 0;
segNoisyI = 0; 


% Output: Number and type of coins available in the image; e total
coinDist = 0;


% Output: Histogram showing the distribution of object sizes; 
% Either area or radius could be used as a size measure
sizeHist = 0;


end

