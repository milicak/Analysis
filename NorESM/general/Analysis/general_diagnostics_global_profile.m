function [Tglobal Sglobal Kdglobal Ahglobal depth]=general_diagnostics_global_profile(grid_file,expid,fyear,lyear)

area=ncgetvar(grid_file,'parea');

% Load time averaged model data
load(['matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat']);

Nz=length(depth);
area=repmat(area,[1 1 Nz]);
area(isnan(templvl)==1)=NaN;

for k=1:Nz
  dnm=squeeze(templvl(:,:,k)).*squeeze(area(:,:,k));
  Tglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(area(:,:,k))));
  dnm=squeeze(salnlvl(:,:,k)).*squeeze(area(:,:,k));
  Sglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(area(:,:,k))));
  dnm=squeeze(difdialvl(:,:,k)).*squeeze(area(:,:,k));
  Kdglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(area(:,:,k))));
  dnm=squeeze(difisolvl(:,:,k)).*squeeze(area(:,:,k));
  Ahglobal(k)=nansum(dnm(:))/nansum(nansum(squeeze(area(:,:,k))));
end

