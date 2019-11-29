
%%%%%%%%%%%% parametros %%%%%%%%%%%%
originalName = 'castle';
fileName = 'castle.png';

noiseType = 'gaussian';
noiseParams = [0,0.01];

filteringDomain = 'frequency';
smoothingType = 'butterworth';
filterParams = [5,2,0.4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% funcao:
image = rgb2gray(imread(fileName)); % imagem convertida para grayscale
image = double(image)/255;
[noisy,smoothed] = main_smoothfilters(image,noiseType,noiseParams,filteringDomain,smoothingType,filterParams);

% output:
d = '_';

params = strrep(regexprep(num2str(filterParams),'\s+',d),'.',',');
output = strcat(originalName,d,filteringDomain,d,smoothingType,d,params,'.png');
imwrite(smoothed,output);

params = strrep(regexprep(num2str(noiseParams),'\s+',d),'.',',');
output = strcat(originalName,d,noiseType,d,params,'.png');
imwrite(noisy,output);


% mostra imagens
figure('Name','Resultado');
subplot(1,3,1), imshow(image); title('original');
subplot(1,3,2), imshow(noisy); title('noisy');
subplot(1,3,3), imshow(smoothed); title('smoothed');


% mostra espetro
%{
fig = figure('Name','Espetro');
subplot(1,3,1), showPowerSpectrum(image); title('original');
subplot(1,3,2), showPowerSpectrum(noisy); title('noisy');
subplot(1,3,3), showPowerSpectrum(smoothed); title('smoothed');
saveas(fig,'espetros.png');
%}
% mostra linha
%{
row = 256;
a = plot(noisy(row,:)); title('noisy');
saveas(a,'noisy.png');
b = plot(smoothed(row,:)); title('smoothed');
saveas(b,'smoothed.png');
c = plot(image(row,:)); title('original');
saveas(c,'original.png');
%}

% testa tempo de execução
%{
N = 100;  
elapsed_time = zeros(N,1);
for i = 1:N
    t = tic;
    [noisy,smoothed] = main_smoothfilters(image,noiseType,noiseParams,filteringDomain,smoothingType,filterParams);
    t = toc(t);
    elapsed_time(i) = t;
end
time_avg = mean(elapsed_time)
%}

