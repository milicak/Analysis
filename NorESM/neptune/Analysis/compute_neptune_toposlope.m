%clear all

grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
topo_file='etopo5.nc';

if(topo_file=='etopo5.nc')
    topo_file='/fimm/home/bjerknes/milicak/matlab/matlib/rgrd/etopo5.nc';
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
for k=1:25
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
pmask = ncgetvar(grid_file,'pmask');

%method = 'nearest';
%method = 'cubic';
method = 'linear';
topo_dy_micom=griddata(lon,lat,topo_dy,plon,plat,method);
topo_dx_micom=griddata(lon,lat,topo_dx,plon,plat,method);

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

%save neptune_velocity_toposlope topo_dx_micom topo_dy_micom
%break
topo_dx_micom(pmask==0)=0;
topo_dy_micom(pmask==0)=0;

[nx ny] = size(plon);

%fill_value=-1e33;
fill_value=0;
% Create netcdf file.
ncid=netcdf.create(['neptune_velocity_toposlopes.nc'],'NC_CLOBBER');

% Define dimensions.
ni_dimid=netcdf.defDim(ncid,'ni',nx);
nj_dimid=netcdf.defDim(ncid,'nj',ny);

tlon_varid=netcdf.defVar(ncid,'TLON','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlon_varid,'long_name','T grid center longitude');
netcdf.putAtt(ncid,tlon_varid,'units','degrees_east');
netcdf.putAtt(ncid,tlon_varid,'bounds','lont_bounds');

tlat_varid=netcdf.defVar(ncid,'TLAT','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,tlat_varid,'long_name','T grid center latitude');
netcdf.putAtt(ncid,tlat_varid,'units','degrees_north');
netcdf.putAtt(ncid,tlat_varid,'bounds','latt_bounds');

uneptune_varid=netcdf.defVar(ncid,'topo_slope_x','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,uneptune_varid,'long_name','Topo_slope in x-direction');
netcdf.putAtt(ncid,uneptune_varid,'units','m/m');
netcdf.putAtt(ncid,uneptune_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,uneptune_varid,'coordinates','TLON TLAT');

vneptune_varid=netcdf.defVar(ncid,'topo_slope_y','float',[ni_dimid nj_dimid]);
netcdf.putAtt(ncid,vneptune_varid,'long_name','Topo_slope in y-direction');
netcdf.putAtt(ncid,vneptune_varid,'units','m/m');
netcdf.putAtt(ncid,vneptune_varid,'_FillValue',single(fill_value));
netcdf.putAtt(ncid,vneptune_varid,'coordinates','TLON TLAT');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,tlon_varid,single(plon));
netcdf.putVar(ncid,tlat_varid,single(plat));

topo_dx_micom(isnan(topo_dx_micom))=fill_value;
topo_dy_micom(isnan(topo_dy_micom))=fill_value;

netcdf.putVar(ncid,uneptune_varid,single(topo_dx_micom));
netcdf.putVar(ncid,vneptune_varid,single(topo_dy_micom));

% Close netcdf file
netcdf.close(ncid)


