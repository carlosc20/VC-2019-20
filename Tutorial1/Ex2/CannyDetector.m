lena = '..\originais\lena.jpg';
castle = '..\originais\castle.png';
baboon = '..\originais\baboon.png';
fourK = '..\originais\4k.jpg';

img=lena;

I=rgb2gray(imread(img));

m = 0.1;              %mean
var_gauss = 0.0;   %variance
N = imnoise(I,'gaussian',m,var_gauss);

img = split(img, '\');
img = split(img(size(img,1)), '.');
img = img{1};
img = strcat('Output/',img);

[G, T, H] = main_CannyDetector(I, img, [3, 1], [0.125, 0.25]);