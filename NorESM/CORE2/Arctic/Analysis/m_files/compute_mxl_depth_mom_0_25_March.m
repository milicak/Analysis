clear all
rho_cr=0.125;

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mom0.25/ocean.salt.March_avg.last_cycle_COREyr1948_2007.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mom0.25/ocean.temp.March_avg.last_cycle_COREyr1948_2007.nc';
gridfile='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/mom0.25/ocean.static.nc';
salt=ncgetvar(filename_s,'salt');
temp=ncgetvar(filename_t,'temp');
lon=ncgetvar(filename_t,'geolon_t');
lat=ncgetvar(filename_t,'geolat_t');
zt=ncgetvar(filename_t,'st_ocean');

temp=squeeze(nanmean(temp,4)); %last cycle 
salt=squeeze(nanmean(salt,4)); %last cycle 

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

save('matfiles2/mom_0_25_march_mxl_depth.mat','lon','lat','mxl')



