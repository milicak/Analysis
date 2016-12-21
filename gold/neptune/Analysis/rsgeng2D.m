function [f,x,y] = rsgeng2D(N,rL,h,clx,cly)
%
% [f,x,y] = rsgeng2D(N,rL,h,clx,cly) 
%
% generates a square 2-dimensional random rough surface f(x,y) with NxN 
% surface points. The surface has a Gaussian height distribution function 
% and Gaussian autocovariance functions (in both x and y), where rL is the 
% length of the surface side, h is the RMS height and clx and cly are the 
% correlation lengths in x and y. Omitting cly makes the surface isotropic.
%
% Input:    N   - number of surface points (along square side)
%           rL  - length of surface (along square side)
%           h   - rms height
%           clx, (cly)  - correlation lengths (in x and y)
%
% Output:   f  - surface heights
%           x  - surface points
%           y  - surface points
%
% Last updated: 2010-07-26 (David Bergström).  
%

format long;

x = linspace(-rL/2,rL/2,N); y = linspace(-rL/2,rL/2,N);
[X,Y] = meshgrid(x,y); 

Z = h.*randn(N,N); % uncorrelated Gaussian random rough surface distribution
                   % with mean 0 and standard deviation h

% isotropic surface
if nargin == 4
    
    % Gaussian filter
    F = exp(-((X.^2+Y.^2)/(clx^2/2)));

    % correlation of surface including convolution (faltung), inverse
    % Fourier transform and normalizing prefactors
    f = 2/sqrt(pi)*rL/N/clx*ifft2(fft2(Z).*fft2(F));
    
% non-isotropic surface
elseif nargin == 5
    
    % Gaussian filter
    F = exp(-(X.^2/(clx^2/2)+Y.^2/(cly^2/2)));

    % correlated surface generation including convolution (faltning) and inverse
    % Fourier transform and normalizing prefactors
    f = 2/sqrt(pi)*rL/N/sqrt(clx)/sqrt(cly)*ifft2(fft2(Z).*fft2(F));
    
end