clear all
grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
lon=ncgetvar(grid_file,'lon');
lat=ncgetvar(grid_file,'lat');

project_name = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';

av1=240; %240; %75;
av2=250; %250; %85;

fyear = 1;
lyear = 250;

filename = ['matfiles/' project_name '_mld_mean_' num2str(fyear) '_' num2str(lyear) '.mat']
load(filename)

%dnm=squeeze(nanmean(squeeze(MLDMarch(av1:av2,:,:)),1))*1e-2; %in meter
%dnm=squeeze(nanmean(squeeze(MLDmean(av1:av2,:,:)),1))*1e-2; %in meter
dnm=squeeze(nanmean(squeeze(MLDDJF(av1:av2,:,:)),1))*1e-2; %in meter

x=lon;                
x(x>320)=x(x>320)-360;

%for i=1:320;for j=1:384
%  if(x(i,j) > 180)
% 
%  end
%end;end
%xx=x(161:end,:)-360;     
%xx(161:320,:)=x(1:160,:);

figure
%m_projpolar
m_proj('stereographic','lat',80,'long',0,'radius',35);
%m_proj('stereographic','lat',90,'long',0,'radius',45);
%m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
%m_proj('Equidistant Cylindrical','lon',[0 360],'lat',[-90 90]);
m_pcolor(lon,lat,dnm);shfn
caxis([0 1500])
m_coast('patch',[.7 .7 .7])
m_grid
shading faceted
keyboard

break
printname=[project_name 'mldMarch_' num2str(av1) '_' num2str(av2) '_years']
print('-dpng',printname)



