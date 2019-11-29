lena = '..\originais\lena.jpg';

%img = 'C:\Users\luisj\Desktop\Luís Macedo\Programming\VC-Aulas\eight.png';
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

%figure('Name', 'Matlab');imshow(edge(I, 'Canny', [0.125,0.25], 1.4));