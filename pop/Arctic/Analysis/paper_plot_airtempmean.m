clear all
grid_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/ncar-pop/areacello_fx_CCSM4_piControl_r0i0p0.nc';
lon=ncgetvar(grid_file,'lon');
lat=ncgetvar(grid_file,'lat');

project_name = 'B1850CN_f19_tn11_kdsens';

av1=240; %240; %40;
av2=250; %250; %50;

fyear = 1;
lyear = 250;

filename = ['matfiles/' project_name '_airtemp_mean_' num2str(fyear) '_' num2str(lyear) '.mat']
load(filename)

%dnm=squeeze(nanmean(squeeze(AIRTEMPwinter(40:50,:,:)),1));
dnm=squeeze(nanmean(squeeze(AIRTEMPTrefwinter(av1:av2,:,:)),1));
figure(1)
%m_projpolar
m_proj('stereographic','lat',90,'long',0,'radius',40);
m_pcolor(lon,lat,dnm');shfn
shading interp
%caxis([0 1])
%m_coast('patch',[.7 .7 .7])
m_coast('line','color','k','linewidth',2);
m_grid

printname=[project_name 'airtemp_' num2str(av1) '_' num2str(av2) '_years']
print('-dpng',printname)

break

project_name = 'B1850CN_f19_tn11_kdsens01';
%project_name = 'B1850CN_f19_tn11_kdsens02';
%project_name = 'B1850CN_f19_tn11_kdsens03';
filename = ['matfiles/' project_name '_airtemp_mean_' num2str(fyear) '_' num2str(lyear) '.mat']
out1=load(filename)

%dnm=squeeze(nanmean(squeeze(out1.AIRTEMPwinter(av1:av2,:,:)-AIRTEMPwinter(av1:av2,:,:)),1));
dnm=squeeze(nanmean(squeeze(out1.AIRTEMPTrefwinter(av1:av2,:,:)-AIRTEMPTrefwinter(av1:av2,:,:)),1));
figure(2)
%m_projpolar
m_proj('stereographic','lat',90,'long',0,'radius',40);
m_pcolor(lon,lat,dnm');shfn
shading interp
%caxis([0 1])
%m_coast('patch',[.7 .7 .7])
m_coast('line','color','k','linewidth',2);
m_grid

printname=[project_name 'airtemp_' num2str(av1) '_' num2str(av2) '_years']
print('-dpng',printname)




