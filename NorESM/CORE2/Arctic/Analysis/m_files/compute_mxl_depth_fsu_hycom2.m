clear all
rho_cr=0.1;

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/TSuv_pentadals_cyc5_fsu-hycom2.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/fsu-hycom2/TSuv_pentadals_cyc5_fsu-hycom2.nc';
salt=ncgetvar(filename_s,'salinity');
temp=ncgetvar(filename_t,'temperature');
lon=ncgetvar(filename_t,'Longitude');
lat=ncgetvar(filename_t,'Latitude');
zt=ncgetvar(filename_t,'Depth');
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/NorESM/NOIIA_T62_tn11_sr10m60d_01_temperature_pendatal_1-300.nc';
ztref=ncgetvar(filename_t,'depth');
ztref=ztref(2:end);Nz=size(ztref,1);

timeind=1
for Time=12:12 %last cycle
for i=1:size(temp,1)
for j=1:size(temp,2)
temp1=squeeze(temp(i,j,:,Time));
salt1=squeeze(salt(i,j,:,Time));
zt1=squeeze(zt(i,j,:,Time));
zt1(temp1<-100)=[];
temp1(temp1<-100)=[];
salt1(salt1<-100)=[];
if(isempty(zt1)~=1)
[B I]=unique(zt1);
zt1=zt1(I);
temp1=temp1(I);
salt1=salt1(I);
T1(i,j,1:Nz,timeind)=interp1(zt1,temp1,ztref);
S1(i,j,1:Nz,timeind)=interp1(zt1,salt1,ztref);
else
T1(i,j,1:Nz,timeind)=NaN;
S1(i,j,1:Nz,timeind)=NaN;
end
end
end
timeind=timeind+1
end

temp=T1;
salt=S1;


rho=sw_dens0(salt,temp);

Nx=size(rho,1);
Ny=size(rho,2);
Nz=size(rho,3);

zt=ztref;
ztref=0:1:max(zt);

for i=1:Nx
for j=1:Ny
  if(isnan(rho(i,j,1))==0)
    kind=1;
    rhoref=interp1(zt,squeeze(rho(i,j,:)),ztref);
    if(isnan(rhoref(1))==1)
      ind1=min(find(isnan(rhoref)==0));
      rhoref(1:ind1-1)=rhoref(ind1);
    end
%    for k=2:Nz
%      drho=rho(i,j,k)-rho(i,j,1);
    for k=2:length(rhoref)
      drho=rhoref(k)-rhoref(1);
      if(drho<=rho_cr)
        kind=k;
      end
    end
    %mxl(i,j)=zt(kind);
    mxl(i,j)=ztref(kind);
  else
    mxl(i,j)=NaN;
  end
end
end

save('matfiles/fsu_hycom2_mxl_depth.mat','lon','lat','mxl')



