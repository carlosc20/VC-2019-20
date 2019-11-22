

baboon = rgb2gray(imread('baboon.png'));
castle = rgb2gray(imread('castle.png'));
lena = rgb2gray(imread('lena.jpg'));



[noisy,smoothed] = main_smoothfilters(baboon,'salt & pepper',0.05,'frequency','gaussian',5);

figure('Name','Resultado');
subplot(1,2,1), imshow(noisy); title('noisy');
subplot(1,2,2), imshow(smoothed); title('smoothed');