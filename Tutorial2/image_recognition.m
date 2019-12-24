
%%%%%%%%%%%% parametros %%%%%%%%%%%%
fileName = 'coins.jpg';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% funcao:
image = rgb2gray(imread(fileName)); % imagem convertida para grayscale
image = double(image)/255;
[ preProcI, segI, segNoisyI, SNR, sizeHist, coinDist ] = main_image_recognition( image );
