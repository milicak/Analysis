clear all
grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
lon=ncgetvar(grid_file,'lon');
lat=ncgetvar(grid_file,'lat');

project_name_ctrl = 'B1850CN_f19_tn11_kdsens';
%project_name = 'B1850CN_f19_tn11_kdsens';
project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';

av1=240; %240; %75;
av2=250; %250; %85;

fyear = 1;
lyear = 250;

filename = ['matfiles/' project_name '_icearea_mean_' num2str(fyear) '_' num2str(lyear) '.mat']
load(filename)

filename2 = ['matfiles/' project_name_ctrl '_icearea_mean_' num2str(fyear) '_' num2str(lyear) '.mat']
out=load(filename2)

%dnm=squeeze(nanmean(squeeze(ICEareamean(av1:av2,:,:)),1));
dnm=squeeze(nanmean(squeeze(ICEareaMarch(av1:av2,:,:)),1));
%dnm=squeeze(nanmean(squeeze(ICEareaDJF(av1:av2,:,:)),1));
dnm2=squeeze(nanmean(squeeze(out.ICEareaMarch(av1:av2,:,:)),1));

dnm=dnm*100;
dnm2=dnm2*100;

if 0
figure
%m_projpolar
m_proj('stereographic','lat',90,'long',0,'radius',40);
m_pcolor(lon,lat,dnm);shfn
caxis([20 100])
m_coast('patch',[.7 .7 .7])
m_grid
printname=[project_name 'icefraci_March_' num2str(av1) '_' num2str(av2) '_years']
print('-dpng',printname)
end
figure
m_proj('stereographic','lat',90,'long',0,'radius',40);
m_pcolor(lon,lat,dnm-dnm2);shfn
caxis([-50 50])
m_coast('patch',[.7 .7 .7])
m_grid
printname=[project_name 'icefrac_diff_March_' num2str(av1) '_' num2str(av2) '_years']
print('-dpng',printname)

