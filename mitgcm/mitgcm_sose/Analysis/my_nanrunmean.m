function [yy]=my_nanrunmean(y,dn)
% NANRUNMEAN   running mean
% centered mean of with 2*dn+1 over the uniform time series 'y' (accepting NaNs) 
%
% tor.eldevik@nersc.no  21/9/2007

ny=max(size(y));
dummy=NaN*ones(1,ny+2*dn);ddummy=dummy;

dummy(1+dn:end-dn)=y;

ii=find(~isnan(dummy));i0=min(ii);i1=max(ii);

for i=i0:i1
  ddummy(i)=nanmean(dummy(i-dn:i+dn));
end

yy=ddummy(1+dn:end-dn);
  

