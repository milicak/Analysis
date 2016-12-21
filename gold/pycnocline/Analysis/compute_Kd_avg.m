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
filepath=['/gfdl.nescc-default-prod-openmp/pp/ocean/av/annual_100yr/'];
filename=['ocean.2501-2600.ann.nc'];
end

flname0=[root_dir project_name0 filepath filename];
flname1=[root_dir project_name1 filepath filename];
flname2=[root_dir project_name2 filepath filename];
flname4=[root_dir project_name4 filepath filename];
flname6=[root_dir project_name6 filepath filename];
flname8=[root_dir project_name8 filepath filename];
zt=nc_varget(flname0,'zt');
zw=nc_varget(flname0,'zw');
dz=zw(2:end)-zw(1:end-1);
lon=nc_varget(flname0,'xh');
lat=nc_varget(flname0,'yh');

Kd0=nc_varget(flname0,'Kd');
Kd1=nc_varget(flname1,'Kd');
Kd2=nc_varget(flname2,'Kd');
Kd4=nc_varget(flname4,'Kd');
Kd6=nc_varget(flname6,'Kd');
Kd8=nc_varget(flname8,'Kd');

%area1=nc_varget('/archive/gold/datasets/CM2G63L/tikal/mosaic.unpacked/ocean_hgrid.nc','area');
%for i=1:2:420;for j=1:2:720
%area((i+1)/2,(j+1)/2)=area1(i,j)+area1(i+1,j)+area1(i,j+1)+area1(i+1,j+1);
%end;end
grdname2=['/archive/m1i/gold/global/Exp01.0/RESTART/ocean_geometry.nc']
area=(nc_varget(grdname2,'Ah')); 
area3d=repmat(area,[1 1 size(Kd0,1)]);
area3d=permute(area3d,[3 1 2]);
area3d(isnan(Kd1))=NaN;  

kind=15;
dnm=Kd0(kind:end,:,:).*area3d(kind:end,:,:);
dnm1=area3d(kind:end,:,:);
Kd0avg=nansum(dnm(:))./nansum(dnm1(:));
dnm=Kd1(kind:end,:,:).*area3d(kind:end,:,:);
Kd1avg=nansum(dnm(:))./nansum(dnm1(:));
dnm=Kd2(kind:end,:,:).*area3d(kind:end,:,:);
Kd2avg=nansum(dnm(:))./nansum(dnm1(:));
dnm=Kd4(kind:end,:,:).*area3d(kind:end,:,:);
Kd4avg=nansum(dnm(:))./nansum(dnm1(:));
dnm=Kd6(kind:end,:,:).*area3d(kind:end,:,:);
Kd6avg=nansum(dnm(:))./nansum(dnm1(:));
dnm=Kd8(kind:end,:,:).*area3d(kind:end,:,:);
Kd8avg=nansum(dnm(:))./nansum(dnm1(:));
Kdavg=[Kd0avg Kd1avg Kd2avg Kd4avg Kd6avg Kd8avg]

save('matfiles/Kd_avg_global.mat','Kd0avg','Kd1avg','Kd2avg','Kd4avg','Kd6avg','Kd8avg')




