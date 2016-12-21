clear all
addpath('~/models/COAWST/Tools/mfiles/roms_clm/')
display('first run create_climatology_blacksea file')

roms_clm_name='BlackSea_clm.nc';
roms_grd_name='BlackSea_grd.nc';
clm_name='myocean_blacksea_tempsaltvel_01_01_2012_to_12_31_2012.nc';

lonclm=nc_varget(clm_name,'LON');
latclm=nc_varget(clm_name,'LAT');
depthclm=ncgetvar(clm_name,'Depth');
timeclm=ncgetvar(clm_name,'time');
[Nyclim Nxclim]=size(latclm);
depthclm3D=repmat(depthclm,[1 Nyclim Nxclim]);
Nzclim=length(depthclm);
lonclm3D=repmat(lonclm,[1 1 Nzclim]);
latclm3D=repmat(latclm,[1 1 Nzclim]);
lonclm3D=permute(lonclm3D,[3 1 2]);
latclm3D=permute(latclm3D,[3 1 2]);

lon_rroms=nc_varget(roms_grd_name,'lon_rho');
lat_rroms=nc_varget(roms_grd_name,'lat_rho');
lon_uroms=nc_varget(roms_grd_name,'lon_u');
lat_uroms=nc_varget(roms_grd_name,'lat_u');
lon_vroms=nc_varget(roms_grd_name,'lon_v');
lat_vroms=nc_varget(roms_grd_name,'lat_v');

nc=netcdf(roms_clm_name,'w');
nc{'lon_rho'}(:)=lon_rroms;
nc{'lat_rho'}(:)=lat_rroms;
nc{'lon_u'}(:)=lon_uroms;
nc{'lat_u'}(:)=lat_uroms;
nc{'lon_v'}(:)=lon_vroms;
nc{'lat_v'}(:)=lat_vroms;
close(nc)

S.N = 30;
S.NT = 2;
S.spherical = 1;
S.Vtransform = 1;
S.Vstretching = 4;
S.theta_s = 5.0;
S.theta_b = 0.4;
S.Tcline  = 10.0;
S.hc = S.Tcline;
disp('getting roms grid dimensions ...');
gn=roms_get_grid_mw(roms_grd_name,[S.theta_s S.theta_b S.Tcline S.N S.Vstretching]);
lon_rroms3d=repmat(lon_rroms,[1 1 gn.N]);
lat_rroms3d=repmat(lat_rroms,[1 1 gn.N]);
lon_rroms3d=permute(lon_rroms3d,[3 1 2]);
lat_rroms3d=permute(lat_rroms3d,[3 1 2]);
depthroms3d=permute(gn.z_r,[1 3 2]);
Hz=gn.z_w(2:end,:,:)-gn.z_w(1:end-1,:,:);


nc=netcdf(roms_clm_name,'w');
nc{'spherical'}(:)=S.spherical;
nc{'theta_b'}(:)=S.theta_b;
nc{'theta_s'}(:)=S.theta_s;
nc{'s_w'}(:)=gn.s_w;
nc{'s_rho'}(:)=gn.s_rho;
nc{'Cs_w'}(:)=gn.Cs_w;
nc{'Cs_r'}(:)=gn.Cs_r;
nc{'Tcline'}(:)=gn.Tcline;
nc{'Vstretching'}(:)=S.Vstretching;
nc{'Vtransform'}(:)=S.Vtransform;
nc{'h'}(:)=gn.h;
nc{'hc'}(:)=gn.hc;

close(nc)

for ind=1:length(timeclm)
tempclm=nc_varget(clm_name,'temp',[ind-1 0 0 0],[1 -1 -1 -1]);
saltclm=nc_varget(clm_name,'salt',[ind-1 0 0 0],[1 -1 -1 -1]);
uvelclm=nc_varget(clm_name,'uvel',[ind-1 0 0 0],[1 -1 -1 -1]);
vvelclm=nc_varget(clm_name,'vvel',[ind-1 0 0 0],[1 -1 -1 -1]);
sshclm=nc_varget(clm_name,'ssh',[ind-1 0 0],[1 -1 -1]);

% griddata ssh from climatology into roms ssh
sshroms=griddata(lonclm,latclm,sshclm,lon_rroms,lat_rroms);

% griddata temp from climatology into roms domain
%F_interp=TriScatteredInterp(lonclm3D(:),latclm3D(:),-depthclm3D(:),tempclm(:),'nearest');
%temproms=F_interp(lon_rroms3d,lat_rroms3d,depthroms3d,'nearest');
tempclm=permute(tempclm,[1 3 2]);
tempclm=flipdim(tempclm,1);
display('Run roms_from_stdlev_m BUT be careful Mehmet changed the subroutine')
temproms=roms_from_stdlev_mw(lonclm',latclm',-flipud(depthclm),tempclm,gn,'rho',1);

% griddata salt from climatology into roms domain
saltclm=permute(saltclm,[1 3 2]);
saltclm=flipdim(saltclm,1);
saltroms=roms_from_stdlev_mw(lonclm',latclm',-flipud(depthclm),saltclm,gn,'rho',1);

% griddata uvel from climatology into roms domain
uvelclm=permute(uvelclm,[1 3 2]);
uvelclm=flipdim(uvelclm,1);
uvelroms=roms_from_stdlev_mw(lonclm',latclm',-flipud(depthclm),uvelclm,gn,'u',1);
%nanmask(isnan(nanmask)

% griddata vvel from climatology into roms domain
vvelclm=permute(vvelclm,[1 3 2]);
vvelclm=flipdim(vvelclm,1);
vvelroms=roms_from_stdlev_mw(lonclm',latclm',-flipud(depthclm),vvelclm,gn,'v',1);

if 0
display('Additional filter for Black Sea only because of some points are less than climatological values')
kk=1;
for k=1:gn.N
for i=1:size(temproms,2)
for j=1:size(temproms,3)
if(temproms(k,i,j)<1e-4 & temproms(k,i,j)~=0)
indz(kk)=k;indx(kk)=i;indy(kk)=j;
kk=kk+1;
end
end
end
end
for kk=1:length(indz)
temproms(indz(kk),indx(kk),indy(kk))=temproms(indz(kk),indx(kk),indy(kk)+1);
saltroms(indz(kk),indx(kk),indy(kk))=saltroms(indz(kk),indx(kk),indy(kk)+1);
end
end

%write netcdf files
ncwrite(roms_clm_name,'zeta',sshroms',[1 1 ind]); 
ncwrite(roms_clm_name,'temp',permute(temproms,[2 3 1]),[1 1 1 ind]);
ncwrite(roms_clm_name,'salt',permute(saltroms,[2 3 1]),[1 1 1 ind]);
ncwrite(roms_clm_name,'u',permute(uvelroms,[2 3 1]),[1 1 1 ind]);
ncwrite(roms_clm_name,'v',permute(vvelroms,[2 3 1]),[1 1 1 ind]);
[ubar,vbar]=uv_barotropic(permute(uvelroms,[2 3 1]),permute(vvelroms,[2 3 1]),permute(Hz,[2 3 1]));
ncwrite(roms_clm_name,'ubar',ubar,[1 1 ind]); 
ncwrite(roms_clm_name,'vbar',vbar,[1 1 ind]); 
ind
end % ind




