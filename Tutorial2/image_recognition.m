
%%%%%%%%%%%% parametros %%%%%%%%%%%%
fileName = 'coins.jpg';
noiseType = 'gaussian'; % gaussian ou salt-an-pepper
noiseParameters = [0,0.01]; % parametros do noise. Se for Gaussian, [media, variancia]. Se for Sal & Pepper, [ densidade ].

image = rgb2gray(imread(fileName)); % imagem convertida para grayscale
image = double(image)/255; % Converte a imagem para doubles e os valores para o intervalo [0,1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% funcao:
[ preProcI, segI, segNoisyI, SNR, sizeHist, coinDist ] = main_image_recognition( image, noiseType, noiseParameters );
