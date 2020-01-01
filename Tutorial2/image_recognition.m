
%%%%%%%%%%%% parametros %%%%%%%%%%%%
% nome do ficheiro da imagem
fileName = 'coins2.jpg';

% gaussian ou salt-an-pepper
noiseType = 'gaussian'; 

% parametros do noise. Se for Gaussian, [media, variancia]. Se for Sal & Pepper, [ densidade ].
noiseParameters = [0,0.01];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% converte imagem para grayscale e double
image = rgb2gray(imread(fileName)); 
image = double(image)/255;


%% funcao:
[ preProcI, segI, segNoisyI, SNR, radii, coinCount ] = main_image_recognition( image, noiseType, noiseParameters );


%% resultados:

% signal to noise ratio da imagem com ruído
SNR

% imagem pre-processada
figure; imshow(preProcI);
title('Pre-processed image');

% imagens segmentadas
% segI, segNoisyI ???????????'

% histograma de raios das moedas
figure; histogram(radii);
title('Histogram of Coin Radii');
xlabel('radius');
ylabel('count');

% nr de moedas
coinCount


%% extras

% imhist(image)
