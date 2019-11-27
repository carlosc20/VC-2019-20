I=imread('..\originais\lena.jpg');

m = 0;              %mean
var_gauss = 0.01;   %variance

N = imnoise(I,'gaussian',m,var_gauss);

S = Gaussian_smoothing(I, [10,3]);

[G,O] = gradient(S);

T = nonmax(G,O);