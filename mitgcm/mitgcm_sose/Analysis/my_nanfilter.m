function [yy]=my_nanfilter(y,dn,method)
%
% MY_NANFILTER   
%
% function [yy]=my_nanfilter(y,dn,method)
%
% y  - input time series
%
% dn - length of filter
%
% method - the filter used
%          'box' - boxcar
%          'bar' - barlett    
%          'tri' - triangular - proper triangle for dn even
%
% tor.eldevik@gfi.uib.no  19/4/2012
%

if method == 'box'
  filter = ones(dn,1);
elseif method == 'bar'
  filter = bartlett(dn);
elseif method == 'tri'
  filter = triang(dn);
else
  'no valid filter prescribed'
  return 
end

ny=max(size(y));
dummy=NaN*ones(1,ny+dn-1);

if dn/2 == round(dn/2)
  dn0 = dn/2-1;
else
  dn0 = (dn-1)/2;
end

dummy(1+dn0:ny+dn0) = y;

for n = 1:ny;
  fy = dummy((1:dn)+(n-1)).*filter';
  II = find(~isnan(fy));
  wt0 = 1/mean(filter(II));
  yy(n) = wt0*mean(fy(II));
end
