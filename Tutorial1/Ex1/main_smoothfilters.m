
function [noisy,smoothed] = main_smoothfilters(I,noiseType,noiseParams,filteringDomain,smoothingType,filterParams)

%%%%% noise
nargs = size(noiseParams,2);
switch noiseType
    case 'salt&pepper' 
         d = 0.05;      % default noise density, 
         if nargs > 0 
           d = noiseParams(1);
         end
         % adds salt and pepper noise, where d is the noise density. This affects approximately d*numel(I) pixels.
         noisy = imnoise(I,'salt & pepper',d);

    case 'gaussian'
         m = 0;                % default mean
         var_gauss = 0.01;     % default variance
         if nargs > 0
           m = noiseParams(1);
         end
         if nargs > 1
           var_gauss = noiseParams(2);
         end
         % adds Gaussian white noise with mean m and variance var_gauss
         noisy = imnoise(I,'gaussian',m,var_gauss);

    otherwise
        error('Unknown noise type');
end


%%%%% smooth
nargs = size(filterParams,2);
switch filteringDomain
    case 'spatial'
        
        hsize = 10;     % default kernel size
        if nargs > 0
            hsize = filterParams(1);
        end
        
        switch smoothingType
            case 'average'
                h = fspecial('average', hsize);
                smoothed = imfilter(noisy,h);

            case 'gaussian'
                sigma = 0.5;      % default standard deviation
                if nargs > 1
                    sigma = filterParams(2);
                end
                %h = fspecial('gaussian', hsize, sigma);
                %smoothed = imfilter(noisy,h);
                smoothed = imgaussfilt(noisy,sigma,'FilterSize',hsize,'FilterDomain','spatial'); % convolution

            case 'median'
                smoothed = medfilt2(noisy, [hsize hsize]);

            otherwise
                error('Unknown smoothing type (spatial filtering domain), options: average, gaussian, median');
        end

    case 'frequency'
            
        s = size(noisy);
        
        % Padding, centrar e DFT
        F = imgToDft(noisy,s);
        
        % Gerar o filtro
        
        hsize = 10;     % default kernel size
        if nargs > 0
            hsize = filterParams(1);
        end
        
        switch smoothingType
            case 'butterworth'
                n = 2;          % default order
                d0 = 15;        % default cutoff frequency
                if nargs > 1
                    n = filterParams(2);
                end
                if nargs > 2
                    d0 = filterParams(3);
                end
                H = butterworthFilter(hsize, n, d0);

            case 'gaussian'
                sigma = 5;      % default standard deviation
                if nargs > 1
                    sigma = filterParams(2);
                end
                H = fspecial('gaussian', hsize, sigma);
               
            otherwise
                error('Unknown smoothing type (frequency filtering domain), options: butterworth, gaussian');
        end
        
        % Padding, centrar e DFT do filtro
        H = imgToDft(H,2*s - size(H));
        
        % Multiplicar pelo filtro, G(u,v) = H(u,v)F(u,v)
        G = H .* F;

        % Inversa do DFT, descentrar e tirar padding
        smoothed = imgFromDft(G,s);
       
    otherwise
        error('Unknown filtering domain, options: spatial, frequency');
end
end


function B = imgFromDft(A,size)
    % gp(x,y) = {real{inverse DFT[G(u,v)]}(-1)^(x+y)
    C = real(ifft2(A));

    % Descentrar
    P = center(C);

    % Resultado final g(x,y) ao extrair a região M X N
    B = P(1:size(1),1:size(2));
end

function B = imgToDft(A,size)
    % Padding
    P = padarray(A, size, 0,'post');

    % Centrar, multiplicar a imagem por (-1)^(x+y)
    C = center(P);

    % Calcular DFT
    B = fft2(C);
end

function B = center(A)
    [l,c] = size(A);
    B = zeros(l,c);
    for i = 1:l
        for j = 1:c
            B(i,j) = A(i,j).*(-1).^(i + j);
        end
    end
end

% low pass butterworth
function h = butterworthFilter(hsize, n, d0)
    h = zeros(hsize, hsize);
    for u = 1:hsize
        for v = 1:hsize
            d = sqrt((u-(hsize+1)/2).^2 + (v-(hsize+1)/2).^2);
            h(u, v) = 1./(1 + (d/d0).^(2.*n));
        end
    end

end