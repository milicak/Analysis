clear all

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

T0=nc_varget(flname0,'temp');
T1=nc_varget(flname1,'temp');
T2=nc_varget(flname2,'temp');
T4=nc_varget(flname4,'temp');
T6=nc_varget(flname6,'temp');
T8=nc_varget(flname8,'temp');

S0=nc_varget(flname0,'salt');
S1=nc_varget(flname1,'salt');
S2=nc_varget(flname2,'salt');
S4=nc_varget(flname4,'salt');
S6=nc_varget(flname6,'salt');
S8=nc_varget(flname8,'salt');

P2000=2000*ones(size(T0,1),size(T0,2),size(T0,3));

rho0=sw_dens(S0,T0,P2000); %sigma2
rho1=sw_dens(S1,T1,P2000); %sigma2
rho2=sw_dens(S2,T2,P2000); %sigma2
rho4=sw_dens(S4,T4,P2000); %sigma2
rho6=sw_dens(S6,T6,P2000); %sigma2
rho8=sw_dens(S8,T8,P2000); %sigma2

for i=1:size(T0,2);for j=1:size(T0,3)
% anand's domain -70 to -50, -40 to 40
%if(lon(j) >= -70 & lon(j) <= -50)
%if(lat(i) >= -40 & lat(i) <= 40) 
if(lon(j) >= -70 & lon(j) <= 0)
if(lat(i) >= -40 & lat(i) <= 40) 
mask(i,j)=1;
else
mask(i,j)=0;
end  
else
mask(i,j)=0;
end
end;end

topo=nc_varget('/archive/gold/datasets/CM2G63L/tikal/mosaic.unpacked/topog.nc','depth');
mask=nc_varget('/archive/gold/datasets/CM2G63L/tikal/mosaic.unpacked/basin.nc','basin');
%mask(mask~=2)=0; % 2 for Atlantic
mask(mask~=3)=0; % 3 for Pacific
mask(mask~=0)=1;

mask3d=repmat(mask,[1 1 size(T0,1)]);
mask3d=permute(mask3d,[3 1 2]);
m1=T0;
m1(isnan(m1)==0)=1;
mask3d=mask3d.*m1;

rho0=rho0.*mask3d;
rho1=rho1.*mask3d;
rho2=rho2.*mask3d;
rho4=rho4.*mask3d;
rho6=rho6.*mask3d;
rho8=rho8.*mask3d;


for kk=1:6
if(kk==1)
  rhotemp=rho0;
elseif(kk==2)
  rhotemp=rho1;
elseif(kk==3)
  rhotemp=rho2;
elseif(kk==4)
  rhotemp=rho4;
elseif(kk==5)
  rhotemp=rho6;
elseif(kk==6)
  rhotemp=rho8;
end
for i=1:size(T0,2);for j=1:size(T0,3)
  %if(mask3d(1,i,j)==1)
  if(mask3d(1,i,j)==1 & topo(i,j)>2500 )
    % down to 2500 meter to stay away from bottom topography
    kmax=min(max(find(isnan(rhotemp(:,i,j))==0)),42);
    dnm1=0;dnm2=0;
    for k=1:kmax
      dnm1=dnm1+(rhotemp(k,i,j)-rhotemp(kmax,i,j))*zt(k)*dz(k);
      dnm2=dnm2+(rhotemp(k,i,j)-rhotemp(kmax,i,j))*dz(k);
    end %k
    zpyc(i,j,kk)=2*dnm1/dnm2;
  else
    zpyc(i,j,kk)=NaN;
  end
end;end

end %kk

%save('matfiles/pycnocline_atlantic_depth.mat','zpyc')
save('matfiles/pycnocline_pacific_depth.mat','zpyc')

