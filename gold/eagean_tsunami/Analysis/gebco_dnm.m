function [map]=gebco_dnm(m)
if nargin < 1, m = size(get(gcf,'colormap'),1); end
    n=(0:m-1)'/(m-1);
    x=(0:6)'/7;
    x=[x; 13/14; 34/35; 1];

    map=[interp1q(x,[0 35 90 140 165 195 210 230 235 235]'/255,n) ...
         interp1q(x,[16/17 1 1 1 1 1 1 1 1 1]',n) ...
              interp1q(x,[255 255 255 230 215 215 215 240 255 255]'/255,n)];

              % fix out-of-bounds due to interpolation
              map(map<0)=0;
              map(map>1)=1;

          end
