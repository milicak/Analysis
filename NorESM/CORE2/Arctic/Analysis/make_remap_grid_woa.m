clear all
%remap_grid_file='grids/remap_grid_woa09_1deg_20130510.nc';
remap_grid_file='grids/remap_grid_woa09_0_5deg_20130510.nc';

resolution=0.5; %1; %0.5;
nx=360*2;
ny=180*2;
deg2rad=pi/180;
%grid_center_lat=ones(nx,1)*(-89.5:resolution:89.5);
%grid_center_lon=(0.5:resolution:359.5)'*ones(1,ny);
grid_center_lat=ones(nx,1)*(-90+resolution*0.5:resolution:90-resolution*0.5);
grid_center_lon=(0+resolution*0.5:resolution:360-resolution*0.5)'*ones(1,ny);
grid_corner_lat=zeros(4,nx,ny);
grid_corner_lon=zeros(4,nx,ny);
grid_corner_lat(1,:,:)=grid_center_lat-0.5*resolution;
grid_corner_lat(2,:,:)=grid_center_lat-0.5*resolution;
grid_corner_lat(3,:,:)=grid_center_lat+0.5*resolution;
grid_corner_lat(4,:,:)=grid_center_lat+0.5*resolution;
grid_corner_lon(1,:,:)=grid_center_lon-0.5*resolution;
grid_corner_lon(2,:,:)=grid_center_lon+0.5*resolution;
grid_corner_lon(3,:,:)=grid_center_lon+0.5*resolution;
grid_corner_lon(4,:,:)=grid_center_lon-0.5*resolution;
grid_area=2*(sin(grid_corner_lat(4,1,:)*deg2rad) ...
            -sin(grid_corner_lat(1,1,:)*deg2rad))*pi/nx;
grid_area=ones(nx,1)*reshape(grid_area,1,[]);
grid_imask=ones(nx,ny);

% Create netcdf file.
ncid=netcdf.create(remap_grid_file,'NC_CLOBBER');

% Define dimensions.
grid_size_dimid=netcdf.defDim(ncid,'grid_size',nx*ny);
grid_rank_dimid=netcdf.defDim(ncid,'grid_rank',2);
grid_corners_dimid=netcdf.defDim(ncid,'grid_corners',4);

% Define variables and assign attributes
grid_dims_varid=netcdf.defVar(ncid,'grid_dims','int',grid_rank_dimid);

grid_center_lat_varid=netcdf.defVar(ncid,'grid_center_lat','double',grid_size_dimid);
netcdf.putAtt(ncid,grid_center_lat_varid,'units','degrees');

grid_center_lon_varid=netcdf.defVar(ncid,'grid_center_lon','double',grid_size_dimid);
netcdf.putAtt(ncid,grid_center_lon_varid,'units','degrees');

grid_area_varid=netcdf.defVar(ncid,'grid_area','double',grid_size_dimid);
netcdf.putAtt(ncid,grid_area_varid,'units','radians^2');

grid_imask_varid=netcdf.defVar(ncid,'grid_imask','int',grid_size_dimid);
netcdf.putAtt(ncid,grid_imask_varid,'units','unitless');

grid_corner_lat_varid=netcdf.defVar(ncid,'grid_corner_lat','double',[grid_corners_dimid grid_size_dimid]);
netcdf.putAtt(ncid,grid_corner_lat_varid,'units','degrees');

grid_corner_lon_varid=netcdf.defVar(ncid,'grid_corner_lon','double',[grid_corners_dimid grid_size_dimid]);
netcdf.putAtt(ncid,grid_corner_lon_varid,'units','degrees');

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for variables.
netcdf.putVar(ncid,grid_dims_varid,[nx ny]);
netcdf.putVar(ncid,grid_center_lat_varid,grid_center_lat);
netcdf.putVar(ncid,grid_center_lon_varid,grid_center_lon);
netcdf.putVar(ncid,grid_area_varid,grid_area);
netcdf.putVar(ncid,grid_imask_varid,grid_imask);
netcdf.putVar(ncid,grid_corner_lat_varid,grid_corner_lat);
netcdf.putVar(ncid,grid_corner_lon_varid,grid_corner_lon);

% Close netcdf file
netcdf.close(ncid)

