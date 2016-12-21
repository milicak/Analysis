clear all

grid_file='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
topo_file='etopo5.nc';

if(topo_file=='etopo5.nc')
dy_deg2km=deg2km(5/60);  % because it is etopo5;
topo_lon=ncgetvar(topo_file,'topo_lon');
topo_lat=ncgetvar(topo_file,'topo_lat');
topo=ncgetvar(topo_file,'topo');
elseif(topo_file=='etopo2.nc')
dy_deg2km=deg2km(2/60);  % because it is etopo2;
topo_lon=ncgetvar(topo_file,'X_P1DEGREE');
topo_lat=ncgetvar(topo_file,'Y_P1DEGREE');
topo=ncgetvar(topo_file,'TOPO');
elseif(topo_file=='etopo1.nc')
dy_deg2km=deg2km(1/60);  % because it is etopo1;
end


Nx=size(topo,1);
Ny=size(topo,2);

wght=0.5; % weight for the shapiro filter

%100 times smoothing using 5 point interpolation
for k=1:100
for i=2:Nx-1
for j=2:Ny-1
topo(i,j)=wght*topo(i,j)+(1-wght)*0.25*(topo(i-1,j)+topo(i+1,j)+topo(i,j-1)+topo(i,j+1));
end
end
end

[lon lat]=meshgrid(topo_lon,topo_lat);
lon=lon';
lat=lat';

dx=zeros(Nx-1,Ny);
for j=1:Ny
dx(:,j)=m_lldist(lon(:,j),lat(:,j));
end
dx(end+1,:)=dx(1,:);
dy(1:Nx,1:Ny)=dy_deg2km; 

for i=2:Nx
for j=1:Ny
topo_dx(i,j)=(topo(i,j)-topo(i-1,j))/(dx(i,j)*1e3);
end
end
topo_dx(1,:)==(topo(1,:)-topo(Nx,:))/(dx(1,:)*1e3);

for i=1:Nx
for j=2:Ny
topo_dy(i,j)=(topo(i,j)-topo(i,j-1))/(dy(i,j)*1e3);
end
end
topo_dy(:,1)==(topo(:,2)-topo(:,1))./(dy(:,1)*1e3);

plon=ncgetvar(grid_file,'plon');
plat=ncgetvar(grid_file,'plat');
ulon=ncgetvar(grid_file,'ulon');
ulat=ncgetvar(grid_file,'ulat');
vlon=ncgetvar(grid_file,'vlon');
vlat=ncgetvar(grid_file,'vlat');
pmask=ncgetvar(grid_file,'pmask');
umask=ncgetvar(grid_file,'umask');
vmask=ncgetvar(grid_file,'vmask');
angle=ncgetvar(grid_file,'angle');

radian=57.295779513;
coriop=sin(plat./radian)*4.*pi/86164.;
L=8+4.*cos(2*plat./radian);
L=L.*1e3; %convert from km to m;

topo_micom=griddata(lon,lat,topo,plon,plat);
topo_dy_micom=griddata(lon,lat,topo_dy,plon,plat);
topo_dx_micom=griddata(lon,lat,topo_dx,plon,plat);

[xx yy]=find(isnan(topo_micom)==1);
for i=1:length(xx)
if(xx(i)>1 & yy(i)>1)
topo_micom(xx(i),yy(i))=topo_micom(xx(i)-1,yy(i)-1);
else
topo_micom(xx(i),yy(i))=topo_micom(xx(i)+1,yy(i)+1);
end
end
[xx yy]=find(isnan(topo_dy_micom)==1);
for i=1:length(xx)
if(xx(i)>1 & yy(i)>1)
topo_dy_micom(xx(i),yy(i))=topo_dy_micom(xx(i)-1,yy(i)-1);
else
topo_dy_micom(xx(i),yy(i))=topo_dy_micom(xx(i)+1,yy(i)+1);
end
end
[xx yy]=find(isnan(topo_dx_micom)==1);
for i=1:length(xx)
if(xx(i)>1 & yy(i)>1)
topo_dx_micom(xx(i),yy(i))=topo_dx_micom(xx(i)-1,yy(i)-1);
else
topo_dx_micom(xx(i),yy(i))=topo_dx_micom(xx(i)+1,yy(i)+1);
end
end

topo_micom=-topo_micom;
topo_min=topo_micom;
topo_min(:,:)=100.0; %100 meter
%compute neptune u-velocity
%u=-coriop.*L.*L.*topo_dy_micom./(max(topo_micom,topo_min));
u=-coriop.*L.*L.*topo_dy_micom./((topo_micom+topo_min));
%compute neptune v-velocity
%v= coriop.*L.*L.*topo_dx_micom./(max(topo_micom,topo_min));
v= coriop.*L.*L.*topo_dx_micom./((topo_micom+topo_min));

u(topo_micom<0)=NaN;
v(topo_micom<0)=NaN;

u(abs(u)>1)=1;
v(abs(v)>1)=1;
nx=size(u,1);
ny=size(u,2);
u1=u;
v1=v;

for k=1:10
for i=2:nx-1
for j=2:ny-1
if(isnan(u(i,j))==0)
u(i,j)=wght*u(i,j)+(1-wght)*nanmean([u(i-1,j) u(i+1,j) u(i,j-1) u(i,j+1)]);
%u(i,j)=wght*u(i,j)+(1-wght)*0.25*(u(i-1,j)+u(i+1,j)+u(i,j-1)+u(i,j+1));
end
if(isnan(v(i,j))==0)
v(i,j)=wght*v(i,j)+(1-wght)*nanmean([v(i-1,j) v(i+1,j) v(i,j-1) v(i,j+1)]);
%v(i,j)=wght*v(i,j)+(1-wght)*0.25*(v(i-1,j)+v(i+1,j)+v(i,j-1)+v(i,j+1));
end
end
end
end


%%%%%%% Need to rotate velocities using angle
unew=u.*cos(angle)+v.*sin(angle);
vnew=-u.*sin(angle)+v.*cos(angle);
u1new=u1.*cos(angle)+v1.*sin(angle);
v1new=-u1.*sin(angle)+v1.*cos(angle);

unew_u=griddata(plon,plat,unew,ulon,ulat,'nearest');
u1new_u=griddata(plon,plat,u1new,ulon,ulat,'nearest');
vnew_v=griddata(plon,plat,vnew,vlon,vlat,'nearest');
v1new_v=griddata(plon,plat,v1new,vlon,vlat,'nearest');

unew_u(umask==0)=NaN; 
vnew_v(vmask==0)=NaN;
u1new_u(umask==0)=NaN;
v1new_v(vmask==0)=NaN;

%fill_value=-1e33;
fill_value=0;
% Create netcdf file.
ncid=netcdf.create(['neptune_velocity_rotated.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
nj_dimid=netcdf.defDim(ncid,'nj',ny);

ulon_varid=netcdf.defVar(ncid,'ULON','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,ulon_varid,'long_name','U grid center longitude');
netcdf.putAtt(ncid,ulon_varid,'units','degrees_east');
netcdf.putAtt(ncid,ulon_varid,'bounds','lont_bounds');

ulat_varid=netcdf.defVar(ncid,'ULAT','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,ulat_varid,'long_name','U grid center latitude');
netcdf.putAtt(ncid,ulat_varid,'units','degrees_north');
netcdf.putAtt(ncid,ulat_varid,'bounds','latt_bounds');

vlon_varid=netcdf.defVar(ncid,'VLON','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,vlon_varid,'long_name','V grid center longitude');
netcdf.putAtt(ncid,vlon_varid,'units','degrees_east');
netcdf.putAtt(ncid,vlon_varid,'bounds','lont_bounds');

vlat_varid=netcdf.defVar(ncid,'VLAT','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,vlat_varid,'long_name','V grid center latitude');
netcdf.putAtt(ncid,vlat_varid,'units','degrees_north');
netcdf.putAtt(ncid,vlat_varid,'bounds','latt_bounds');

uneptune_varid=netcdf.defVar(ncid,'u_neptune','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,uneptune_varid,'long_name','Neptune velocity u-component');
netcdf.putAtt(ncid,uneptune_varid,'units','m/s');
netcdf.putAtt(ncid,uneptune_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,uneptune_varid,'coordinates','ULON ULAT');

uneptuneraw_varid=netcdf.defVar(ncid,'u_neptuneraw','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,uneptuneraw_varid,'long_name','Neptune raw velocity u-component');
netcdf.putAtt(ncid,uneptuneraw_varid,'units','m/s');
netcdf.putAtt(ncid,uneptuneraw_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,uneptuneraw_varid,'coordinates','ULON ULAT');

vneptune_varid=netcdf.defVar(ncid,'v_neptune','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,vneptune_varid,'long_name','Neptune velocity v-component');
netcdf.putAtt(ncid,vneptune_varid,'units','m/s');
netcdf.putAtt(ncid,vneptune_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,vneptune_varid,'coordinates','VLON VLAT');

vneptuneraw_varid=netcdf.defVar(ncid,'v_neptuneraw','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,vneptuneraw_varid,'long_name','Neptune raw velocity v-component');
netcdf.putAtt(ncid,vneptuneraw_varid,'units','m/s');
netcdf.putAtt(ncid,vneptuneraw_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,vneptuneraw_varid,'coordinates','VLON VLAT');

% Global attributes
% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,ulon_varid,single(ulon));
netcdf.putVar(ncid,ulat_varid,single(ulat));
netcdf.putVar(ncid,vlon_varid,single(vlon));
netcdf.putVar(ncid,vlat_varid,single(vlat));

unew_u(isnan(unew_u))=fill_value;
u1new_u(isnan(u1new_u))=fill_value;
vnew_v(isnan(vnew_v))=fill_value;
v1new_v(isnan(v1new_v))=fill_value;

netcdf.putVar(ncid,uneptune_varid,single(unew_u));
netcdf.putVar(ncid,uneptuneraw_varid,single(u1new_u));
netcdf.putVar(ncid,vneptune_varid,single(vnew_v));
netcdf.putVar(ncid,vneptuneraw_varid,single(v1new_v));

% Close netcdf file
netcdf.close(ncid)


