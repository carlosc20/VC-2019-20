I=imread('..\lena.jpg');

G = imnoise(I,'gaussian');
imshow(G);

[N,S] = Gaussian_smoothing(I,[0 0.01],[10 5]);

figure;
imshow(S);