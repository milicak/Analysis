clear all
remap_grid_file='grids/remap_grid_noresm_tnx1v1_20130510.nc';

gridfile='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';

nx=360;
ny=384;
deg2rad=pi/180;
grid_center_lon=ncgetvar(gridfile,'plon');
grid_center_lon=grid_center_lon(:,1:end-1);
grid_center_lat=ncgetvar(gridfile,'plat');
grid_center_lat=grid_center_lat(:,1:end-1);
grid_corner_lon=ncgetvar(gridfile,'pclon');
grid_corner_lon=grid_corner_lon(:,1:end-1,:);
grid_corner_lat=ncgetvar(gridfile,'pclat');
grid_corner_lat=grid_corner_lat(:,1:end-1,:);
grid_corner_lon=permute(grid_corner_lon,[3 1 2]);
grid_corner_lat=permute(grid_corner_lat,[3 1 2]);
%grid_area=2*(sin(grid_corner_lat(4,1,:)*deg2rad) ...
%            -sin(grid_corner_lat(1,1,:)*deg2rad))*pi/nx;
%grid_area=ones(nx,1)*reshape(grid_area,1,[]);
grid_area=ncgetvar(gridfile,'parea');
grid_area=grid_area(:,1:end-1);
m2rad=distdim(1,'m','rad');
%convert m2 area to rad2
grid_area=grid_area.*m2rad.*m2rad;
grid_imask=ncgetvar(gridfile,'pmask');
grid_imask=grid_imask(:,1:end-1);

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

