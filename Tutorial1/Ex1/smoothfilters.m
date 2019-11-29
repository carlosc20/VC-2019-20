
%%%%%%%%%%%% parametros %%%%%%%%%%%%
originalName = 'baboon';
fileName = 'baboon.png';

noiseType = 'salt&pepper';
noiseParams = 0.05;

filteringDomain = 'frequency';
smoothingType = 'butterworth';
filterParams = [5,2,1.2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% funcao:
image = rgb2gray(imread(fileName)); % imagem convertida para grayscale
[noisy,smoothed] = main_smoothfilters(image,noiseType,noiseParams,filteringDomain,smoothingType,filterParams);


% output:
d = '_';

params = strrep(regexprep(num2str(filterParams),'\s+',d),'.',',');
output = strcat(originalName,d,filteringDomain,d,smoothingType,d,params,'.png');
imwrite(smoothed,output);

params = strrep(regexprep(num2str(noiseParams),'\s+',d),'.',',');
output = strcat(originalName,d,noiseType,d,params,'.png');
imwrite(noisy,output);


% show
figure('Name','Resultado');
subplot(1,2,1), imshow(noisy); title('noisy');
subplot(1,2,2), imshow(smoothed); title('smoothed');
