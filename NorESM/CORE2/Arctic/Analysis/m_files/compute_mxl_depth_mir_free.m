clear all
rho_cr=0.1;

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/salinity_pentadal.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-free/temperature_pentadal.nc';

salt=ncgetvar(filename_s,'s');
temp=ncgetvar(filename_t,'temp');
temp=squeeze(temp(:,:,:,end)); %last 5 year
salt=squeeze(salt(:,:,:,end)); %last 5 year
%gridfile='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mir-data/lonlat_t.nc';
%lon=ncgetvar(gridfile,'longitude');
%lat=ncgetvar(gridfile,'latitude');
out=load('matfiles/mir_free_fresh_water_content.mat');
lon=out.lon;
lat=out.lat;
zt=ncgetvar(filename_t,'level'); %convert cm to meter
temp(temp<-100)=NaN;
salt(salt<-100)=NaN;
rho=sw_dens0(salt,temp);

Nx=size(rho,1);
Ny=size(rho,2);
Nz=size(rho,3);

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

save('matfiles/mir_free_mxl_depth.mat','lon','lat','mxl')



