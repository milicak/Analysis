%This subroutine computes AMOC in GOLD in depth space
clear all

if 0
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

if 1
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
lon=nc_varget(flname0,'xh');
lat=nc_varget(flname0,'yh');

vh0=nc_varget(flname0,'vhGM_rho');
vh1=nc_varget(flname1,'vhGM_rho');
vh2=nc_varget(flname2,'vhGM_rho');
vh4=nc_varget(flname4,'vhGM_rho');
vh6=nc_varget(flname6,'vhGM_rho');
vh8=nc_varget(flname8,'vhGM_rho');

% moc_GM
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

mocGM0=nancumsum(squeeze(nansum(vh0n,3)),1)*1e-6;
mocGM1=nancumsum(squeeze(nansum(vh1n,3)),1)*1e-6;
mocGM2=nancumsum(squeeze(nansum(vh2n,3)),1)*1e-6;
mocGM4=nancumsum(squeeze(nansum(vh4n,3)),1)*1e-6;
mocGM6=nancumsum(squeeze(nansum(vh6n,3)),1)*1e-6;
mocGM8=nancumsum(squeeze(nansum(vh8n,3)),1)*1e-6;

save('matfiles/mocGM.mat','mocGM0','mocGM1','mocGM2','mocGM4','mocGM6','mocGM8')

