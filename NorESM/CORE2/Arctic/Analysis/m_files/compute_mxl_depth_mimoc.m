clear all
march=1;
%rho_cr=0.1;
rho_cr=0.125;

zt=ncgetvar('MIMOC_Z_GRID_v2.2_PT_S_month03.nc','PRESSURE');
lon=ncgetvar('MIMOC_Z_GRID_v2.2_PT_S_month03.nc','LONGITUDE');
lat=ncgetvar('MIMOC_Z_GRID_v2.2_PT_S_month03.nc','LATITUDE');
[lon lat]=meshgrid(lon,lat);
lon=lon';lat=lat';

days=[31 28 31 30 31 30 31 31 30 31 30 31];
dysw=days./365;

temp=zeros(720,341,81);
salt=zeros(720,341,81);

for i=1:12
  month=sprintf('%2.2d',i);
  filename=['MIMOC_Z_GRID_v2.2_PT_S_month' month '.nc'];
  temp=temp+dysw(i)*ncgetvar(filename,'POTENTIAL_TEMPERATURE');
  salt=salt+dysw(i)*ncgetvar(filename,'SALINITY');
end

if(march==1)
  clear temp salt
  i=3
  month=sprintf('%2.2d',i);
  filename=['MIMOC_Z_GRID_v2.2_PT_S_month' month '.nc'];
  temp=ncgetvar(filename,'POTENTIAL_TEMPERATURE');
  salt=ncgetvar(filename,'SALINITY');
end


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
    %for k=2:Nz
    %  drho=rho(i,j,k)-rho(i,j,1);
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

if(march==1)
  save('matfiles/mimoc_03_mxl_depth.mat','lon','lat','mxl')
else
  save('matfiles/mimoc_annual_mxl_depth.mat','lon','lat','mxl')
end


