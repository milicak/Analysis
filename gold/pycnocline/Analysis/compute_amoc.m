%This subroutine computes AMOC in GOLD in depth space
clear all

if 1
%%root_dir=['/net2/Robert.Hallberg/CM2G/Kd_sens/']
%root_dir=['/net2/Robert.Hallberg/CM2G/Kd_add/']
root_dir=['/net2/rwh/CM2G/Kd_add/']
%project_name='CM2G_LM3_1990_G0_KDadd5'
project_name0='CM2G_LM3_1860_KDadd0'
project_name1='CM2G_LM3_1860_KDadd1'
project_name2='CM2G_LM3_1860_KDadd2'
project_name4='CM2G_LM3_1860_KDadd4'
project_name6='CM2G_LM3_1860_KDadd6'
project_name8='CM2G_LM3_1860_KDadd8'
%filepath=['/pp/ocean/av/annual_20yr/'];
filepath=['/pp/ocean_annual_z/av/annual_100yr/'];
%filename=['ocean_annual_z.2000-2019.ann.nc'];
filename=['ocean_annual_z.2501-2600.ann.nc'];
end
if 0
root_dir=['/archive/Bonnie.Samuels/fre/siena_201204/CM2G_LM3/18mar2013/']
project_name0='CM2G_LM3_1860_KDadd0_18mar2013'
project_name1='CM2G_LM3_1860_KDadd1_18mar2013'
project_name2='CM2G_LM3_1860_KDadd2_18mar2013'
project_name4='CM2G_LM3_1860_KDadd4_18mar2013'
project_name6='CM2G_LM3_1860_KDadd6_18mar2013'
project_name8='CM2G_LM3_1860_KDadd8_18mar2013'
filepath=['/gfdl.nescc-default-prod-openmp/pp/ocean_annual/av/annual_100yr/'];
filename=['ocean_annual.2501-2600.ann.nc'];
end
flname0=[root_dir project_name0 filepath filename];
flname1=[root_dir project_name1 filepath filename];
flname2=[root_dir project_name2 filepath filename];
flname4=[root_dir project_name4 filepath filename];
flname6=[root_dir project_name6 filepath filename];
flname8=[root_dir project_name8 filepath filename];

zt=nc_varget(flname0,'zt');
lon=nc_varget(flname0,'xh');
lat=nc_varget(flname0,'yh');

if 1
vh0=nc_varget(flname0,'vh');
vh1=nc_varget(flname1,'vh');
vh2=nc_varget(flname2,'vh');
vh4=nc_varget(flname4,'vh');
vh6=nc_varget(flname6,'vh');
vh8=nc_varget(flname8,'vh');
end
if 0
vh0=nc_varget(flname0,'vh_rho');
vh1=nc_varget(flname1,'vh_rho');
vh2=nc_varget(flname2,'vh_rho');
vh4=nc_varget(flname4,'vh_rho');
vh6=nc_varget(flname6,'vh_rho');
vh8=nc_varget(flname8,'vh_rho');
end

% Amoc at 26N
vh0n=squeeze(vh0(:,133,200:267));
vh1n=squeeze(vh1(:,133,200:267));
vh2n=squeeze(vh2(:,133,200:267));
vh4n=squeeze(vh4(:,133,200:267));
vh6n=squeeze(vh6(:,133,200:267));
vh8n=squeeze(vh8(:,133,200:267));

amoc0=nancumsum(squeeze(nansum(vh0n,2)))*1e-6;
amoc1=nancumsum(squeeze(nansum(vh1n,2)))*1e-6;
amoc2=nancumsum(squeeze(nansum(vh2n,2)))*1e-6;
amoc4=nancumsum(squeeze(nansum(vh4n,2)))*1e-6;
amoc6=nancumsum(squeeze(nansum(vh6n,2)))*1e-6;
amoc8=nancumsum(squeeze(nansum(vh8n,2)))*1e-6;

amoc_26=[max(amoc0) max(amoc1) max(amoc2) max(amoc4) max(amoc6) max(amoc8)];
amoc_26_0=max(amoc0);
amoc_26_1=max(amoc1);
amoc_26_2=max(amoc2);
amoc_26_4=max(amoc4);
amoc_26_6=max(amoc6);
amoc_26_8=max(amoc8);

save('matfiles/amoc_26.mat','amoc_26_0','amoc_26_1','amoc_26_2','amoc_26_4','amoc_26_6','amoc_26_8')

% Amoc 2d
mask=nc_varget('/archive/gold/datasets/CM2G63L/tikal/mosaic.unpacked/basin.nc','basin');
mask(mask==1)=2; % 1 SO
mask(mask~=2)=0; % 2 for Atlantic
mask(mask~=0)=1;
mask3d=repmat(mask,[1 1 size(vh0,1)]);
mask3d=permute(mask3d,[3 1 2]);
m1=sq(vh0);
m1(isnan(m1)==0)=1;
mask3d=mask3d.*m1;

vh0n=vh0.*mask3d;
vh1n=vh1.*mask3d;
vh2n=vh2.*mask3d;
vh4n=vh4.*mask3d;
vh6n=vh6.*mask3d;
vh8n=vh8.*mask3d;

amoc0=nancumsum(squeeze(nansum(vh0n,3)),1)*1e-6;
amoc1=nancumsum(squeeze(nansum(vh1n,3)),1)*1e-6;
amoc2=nancumsum(squeeze(nansum(vh2n,3)),1)*1e-6;
amoc4=nancumsum(squeeze(nansum(vh4n,3)),1)*1e-6;
amoc6=nancumsum(squeeze(nansum(vh6n,3)),1)*1e-6;
amoc8=nancumsum(squeeze(nansum(vh8n,3)),1)*1e-6;

save('matfiles/amoc.mat','amoc0','amoc1','amoc2','amoc4','amoc6','amoc8','lat','zt')

% Moc 
mask=nc_varget('/archive/gold/datasets/CM2G63L/tikal/mosaic.unpacked/basin.nc','basin');
mask(mask~=0)=1; % global
mask3d=repmat(mask,[1 1 size(vh0,1)]);
mask3d=permute(mask3d,[3 1 2]);
m1=sq(vh0);
m1(isnan(m1)==0)=1;
mask3d=mask3d.*m1;

vh0n=vh0.*mask3d;
vh1n=vh1.*mask3d;
vh2n=vh2.*mask3d;
vh4n=vh4.*mask3d;
vh6n=vh6.*mask3d;
vh8n=vh8.*mask3d;

moc0=nancumsum(squeeze(nansum(vh0n,3)),1)*1e-6;
moc1=nancumsum(squeeze(nansum(vh1n,3)),1)*1e-6;
moc2=nancumsum(squeeze(nansum(vh2n,3)),1)*1e-6;
moc4=nancumsum(squeeze(nansum(vh4n,3)),1)*1e-6;
moc6=nancumsum(squeeze(nansum(vh6n,3)),1)*1e-6;
moc8=nancumsum(squeeze(nansum(vh8n,3)),1)*1e-6;

save('matfiles/moc.mat','moc0','moc1','moc2','moc4','moc6','moc8','lat','zt')

