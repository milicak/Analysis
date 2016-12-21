%This subroutine computes drake passage transport in GOLD in depth space
clear all

rho0=1027;
%%root_dir=['/net2/Robert.Hallberg/CM2G/Kd_sens/']
%root_dir=['/net2/Robert.Hallberg/CM2G/Kd_add/']
%root_dir=['/net2/rwh/CM2G/Kd_add/']
root_dir=['/archive/Bonnie.Samuels/fre/siena_201204/CM2G_LM3/18mar2013/']

project_name0='CM2G_LM3_1860_KDadd0_18mar2013'
project_name1='CM2G_LM3_1860_KDadd1_18mar2013'
project_name2='CM2G_LM3_1860_KDadd2_18mar2013'
project_name4='CM2G_LM3_1860_KDadd4_18mar2013'
project_name6='CM2G_LM3_1860_KDadd6_18mar2013'
project_name8='CM2G_LM3_1860_KDadd8_18mar2013'

filepath=['/gfdl.nescc-default-prod-openmp/pp/ocean/av/annual_100yr/'];
filename=['ocean.2501-2600.ann.nc'];

flname0=[root_dir project_name0 filepath filename];
flname1=[root_dir project_name1 filepath filename];
flname2=[root_dir project_name2 filepath filename];
flname4=[root_dir project_name4 filepath filename];
flname6=[root_dir project_name6 filepath filename];
flname8=[root_dir project_name8 filepath filename];
lon=nc_varget(flname0,'xh');
lat=nc_varget(flname0,'yh');

tau0=nc_varget(flname0,'taux');
tau1=nc_varget(flname1,'taux');
tau2=nc_varget(flname2,'taux');
tau4=nc_varget(flname4,'taux');
tau6=nc_varget(flname6,'taux');
tau8=nc_varget(flname8,'taux');

mask=double(nc_varget('/archive/gold/datasets/CM2G63L/tikal/mosaic.unpacked/basin.nc','basin'));
mask(mask~=1)=0; % 1 SO
grdname2=['/archive/m1i/gold/global/Exp01.0/RESTART/ocean_geometry.nc']
area=(nc_varget(grdname2,'Ah')); 
dx=(nc_varget(grdname2,'dxh')); 
dy=(nc_varget(grdname2,'dyh')); 
lat=(nc_varget(grdname2,'lath')); 
facc=(nc_varget(grdname2,'f')); 


dnm1=mask.*area;
dnm=tau0.*mask.*area;
taum0=nansum(dnm(:))./nansum(dnm1(:));
dnm=tau1.*mask.*area;
taum1=nansum(dnm(:))./nansum(dnm1(:));
dnm=tau2.*mask.*area;
taum2=nansum(dnm(:))./nansum(dnm1(:));
dnm=tau4.*mask.*area;
taum4=nansum(dnm(:))./nansum(dnm1(:));
dnm=tau6.*mask.*area;
taum6=nansum(dnm(:))./nansum(dnm1(:));
dnm=tau8.*mask.*area;
taum8=nansum(dnm(:))./nansum(dnm1(:));

% Ekman computed by max wind in SO
dnm=-tau0.*mask.*dx./(rho0*facc);
Tekmax(1)=max(nansum(dnm,2)*1e-6);
dnm=-tau1.*mask.*dx./(rho0*facc);
Tekmax(2)=max(nansum(dnm,2)*1e-6);
dnm=-tau2.*mask.*dx./(rho0*facc);
Tekmax(3)=max(nansum(dnm,2)*1e-6);
dnm=-tau4.*mask.*dx./(rho0*facc);
Tekmax(4)=max(nansum(dnm,2)*1e-6);
dnm=-tau6.*mask.*dx./(rho0*facc);
Tekmax(5)=max(nansum(dnm,2)*1e-6);
dnm=-tau8.*mask.*dx./(rho0*facc);
Tekmax(6)=max(nansum(dnm,2)*1e-6);

% Ekman computed by mean in the Drake passage
dnm=-tau0(22:28,:).*mask(22:28,:).*dx(22:28,:)./(rho0*facc(22:28,:));
Tek(1)=nanmean(nansum(dnm,2)*1e-6);
dnm=-tau1(22:28,:).*mask(22:28,:).*dx(22:28,:)./(rho0*facc(22:28,:));
Tek(2)=nanmean(nansum(dnm,2)*1e-6);
dnm=-tau2(22:28,:).*mask(22:28,:).*dx(22:28,:)./(rho0*facc(22:28,:));
Tek(3)=nanmean(nansum(dnm,2)*1e-6);
dnm=-tau4(22:28,:).*mask(22:28,:).*dx(22:28,:)./(rho0*facc(22:28,:));
Tek(4)=nanmean(nansum(dnm,2)*1e-6);
dnm=-tau6(22:28,:).*mask(22:28,:).*dx(22:28,:)./(rho0*facc(22:28,:));
Tek(5)=nanmean(nansum(dnm,2)*1e-6);
dnm=-tau8(22:28,:).*mask(22:28,:).*dx(22:28,:)./(rho0*facc(22:28,:));
Tek(6)=nanmean(nansum(dnm,2)*1e-6);

% SO wind stress
save('matfiles/wind_stress_SO.mat','tau0','tau1','tau2','tau4','tau6','tau8','taum0','taum1','taum2','taum4','taum6','taum8','mask','area','Tek','Tekmax')



