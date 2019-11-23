

baboon = rgb2gray(imread('baboon.png'));
castle = rgb2gray(imread('castle.png'));
lena = rgb2gray(imread('lena.jpg'));


originalName = 'baboon';
filteringDomain = 'spatial';
smoothingType = 'gaussian';
filterParams = [20,2];
% outputName = originalName + '_' + filteringDomain + '_' + smoothingType + '_' + mat2str(filterParams) + '.png';

[noisy,smoothed] = main_smoothfilters(castle,'gaussian',[0,0.01],filteringDomain,smoothingType,filterParams);

figure('Name','smoothed');
imshow(smoothed);

imwrite(smoothed,'castle_spatial_gaussian_20_2.png');
%imwrite(noisy,'castle_gaussian_0_0,01.png');
%{
figure('Name','Resultado');
subplot(1,2,1), imshow(noisy); title('noisy');
subplot(1,2,2), imshow(smoothed); title('smoothed');
%}