I=imread('..\lena.jpg');

m = 0;              %mean
var_gauss = 0.01;   %variance
noisy = imnoise(I,'gaussian',m,var_gauss);
imshow(G);

S = Gaussian_smoothing(I,[10 5]);

figure;
imshow(S);