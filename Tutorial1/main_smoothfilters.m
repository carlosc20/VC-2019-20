
% params:
% imgFileName - nome do ficheiro de imagem greyscale
function [noisy,smoothed] = main_smoothfilters(I,noiseType,noiseParams,filteringDomain,smoothingType,filterParams)

%%%%% noise
nargs = size(noiseParams,2);
switch noiseType
    case 'salt & pepper' 
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
         % adds Gaussian white noise with mean m and variance var_gauss.
         noisy = imnoise(I,'gaussian',m,var_gauss);

    otherwise
        error("Unknown noise type");
end


%%%%% smooth
nargs = size(filterParams,2);
switch filteringDomain
    case 'spatial'
        
        hsize = 10;     % kernel size
        if nargs > 0
            hsize = filterParams(1);
        end
        
        switch smoothingType
            case 'average'
                h = fspecial('average', hsize);
                smoothed = imfilter(noisy,h);

            case 'gaussian'
                sigma = 5;      % standard deviation
                if nargs > 1
                    sigma = filterParams(2);
                end
                h = fspecial('gaussian', hsize, sigma);
                smoothed = imfilter(noisy,h);
                
            case 'median'
                smoothed = medfilt2(noisy, [hsize hsize]);

            otherwise
                error("Unknown smoothing type (spatial filtering domain), options: average, gaussian, median");
        end

    case 'frequency'

        % Padding
        [m,n] = size(I);
        P = padarray(I, [m,n], 0,'post');
        
        % Centrar, multiplicar a imagem por (-1)^(x+y)
        p = m * 2;
        q = m * 2;
        C = zeros(p,q);
        for i = 1:p
            for j = 1:q
                C(i,j) = P(i,j).*(-1).^(i + j);
            end
        end
        
        
        % Calcular DFT
        F = fft2(C);
        
        % Gerar o filtro
        switch smoothingType
            case 'butterworth'
                % order e variance

            case 'gaussian'
                hsize = 10;             % kernel size
                sigma = 5;              % standard deviation
                
                if nargs > 0
                    hsize = filterParams(1);
                end
                
                if nargs > 1
                    sigma = filterParams(2);
                end
                
                % filtro
                H = fspecial('gaussian', hsize, sigma);
                H = padarray(H, [p,q] - size(H),'post');
               
            otherwise
                error("Unknown smoothing type (frequency filtering domain), options: butterworth, gaussian");
        end
        
        H = F.*H;
         
        H = fft2(H);
                
        % G(u,v) = H(u,v)F(u,v)
        G = H .* F;

        % gp(x,y) = {real{inverse DFT[G(u,v)]}(-1)^(x+y)
        G1 = real(ifft2(G));
        
        % Descentrar
        G2 = zeros(p,q);
        for i = 1:p
            for j = 1:q
                G2(i,j) = G1(i,j).*((-1).^(i+j));
            end
        end
       
        % Resultado final g(x,y) ao extrair a região M X N
        smoothed = G2(1:m,1:n);
        %{
        fftSize = size(P);

        smoothed = ifft2( fft2(P) .* fft2(H, fftSize(1), fftSize(2)), 'symmetric' );
        %}
        %smoothed = imgaussfilt(noisy,sigma,'FilterSize',hsize,'FilterDomain','frequency');
       
    otherwise
        error("Unknown filtering domain, options: spatial, frequency");
end

end
