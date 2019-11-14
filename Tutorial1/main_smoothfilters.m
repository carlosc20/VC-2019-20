
% params:
% imgFileName - nome do ficheiro de imagem greyscale
function [noisy,smoothed] = main_smoothfilters(varargin)


% greyscale image
I = imread(varargin{1});

nargs = 0;

% noise
if nargin > 1
  if ~ischar(varargin{2})
    eid = sprintf('Images:%s:invalidNoiseType',mfilename);
    msg = 'TYPE must be a character string.';
    error(eid,'%s',msg);
  end
end
  
switch noiseType
    case 'salt & pepper'
         d = 0.05;      % default noise density, 

         if nargin > 2
           d = varargin{3};
           nargs = 4;
         end

         % adds salt and pepper noise, where d is the noise density. This affects approximately d*numel(I) pixels.
         noisy = imnoise(I,'salt & pepper',d);

    case 'gaussian'
         m = 0;                % default mean
         var_gauss = 0.01;     % default variance

         if nargin > 2
           m = varargin{3};
           nargs = 4;
         end

         if nargin > 3
           var_gauss = varargin{4};
           nargs = 5;
         end

         % adds Gaussian white noise with mean m and variance var_gauss.
        noisy = imnoise(I,'gaussian',m,var_gauss);

    otherwise
        error("Unknown noise type");
end

filteringDomain = varargin{nargs};
smoothingType = varargin{nargs + 1};

% correlation (imfilter(A,h))
% convolution (conv2)

switch filteringDomain
    case 'spatial'
        switch smoothingType
            case 'average'
                hsize = 10; %input
                h = ones(hsize) / hsize.^2;
                smoothed = imfilter(noisy,h);

            case 'gaussian'
                hsize = 10; %input
                sigma = 5; %input
                h = fspecial('gaussian', hsize, sigma);
                smoothed = imfilter(noisy,h);
                
            case 'median'
                hsize = 10; %input
                smoothed = medfilt2(noisy, [hsize hsize]); % default 3x3, passar altura/largura em separado?

            otherwise
                error("Unknown smoothing type (spatial filtering domain), options: average, gaussian, median");
        end

    case 'frequency'
        % Compute the Discrete Fast Fourier Transform (DFT)
        
        switch smoothingType
            case 'butterworth'
                % order e variance

            case 'gaussian'


            otherwise
                error("Unknown smoothing type (frequency filtering domain), options: butterworth, gaussian");
        end

    otherwise
        error("Unknown filtering domain, options: spatial, frequency");
end

end
