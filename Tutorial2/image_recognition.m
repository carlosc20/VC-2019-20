
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
[ preProcNI, radii, centers, edgeI, radiiN, centersN, edgeNI, SNR ] = main_image_recognition( image, noiseType, noiseParameters );


%% resultados:

% signal to noise ratio da imagem com ruído
SNR

% imagem pre-processada
figure; imshow(preProcNI);
title('Pre-processed image');

% imagens segmentadas
% sem ruído
figure; imshow(edgeI); axis on;
viscircles(centers, radii,'EdgeColor','r','LineWidth',2);
title('Segmented coins');

% com ruído
figure; imshow(edgeNI); axis on;
viscircles(centersN, radiiN,'EdgeColor','r','LineWidth',2);
title('Segmented coins, noisy');


% histograma de raios das moedas
figure; histogram(radiiN);
title('Histogram of Coin Radii');
xlabel('radius');
ylabel('count');

% nr de moedas
coins = size(centersN,1)


%% extras

% imhist(image)
