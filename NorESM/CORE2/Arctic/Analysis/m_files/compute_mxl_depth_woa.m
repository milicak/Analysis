clear all
rho_cr=0.1;

grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/WOA09_salt.nc';
lon=ncgetvar(grid_file,'lon');
lat=ncgetvar(grid_file,'lat');
[lon lat]=meshgrid(lon,lat);
lon=lon';lat=lat';

filename_s='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/WOA09_salt.nc';
filename_t='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/WOA09_temp.nc';
salt=ncgetvar(filename_s,'s');
temp=ncgetvar(filename_t,'t');
zt=nc_varget(filename_t,'depth');

rho=sw_dens0(salt,temp);

Nx=size(rho,1);
Ny=size(rho,2);
Nz=size(rho,3);
ztref=0:1:max(zt);

for i=1:Nx
for j=1:Ny
  if(isnan(rho(i,j,1))==0)
    kind=1;
    %for k=2:Nz
    %  drho=rho(i,j,k)-rho(i,j,1);
    rhoref=interp1(zt,squeeze(rho(i,j,:)),ztref);
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

save('matfiles/woa_mxl_depth.mat','lon','lat','mxl')



