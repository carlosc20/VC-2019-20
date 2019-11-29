function showPowerSpectrum(I)
    S = fftshift(log(1+abs(fft2(I))));
    imshow(S,[]);
end

