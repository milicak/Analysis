% compute zonal mean sigma
clear all

%expid='NOINY_T62_tn11_002'
expid='NOINY_T62_g16_001'
datesep='-';
fyear=1;
lyear=25;
fill_value=-1e33;
map_file='/home/fimm/bjerknes/milicak/matlab/tools/map_gx1v6_to_woa09_aave_20120516.nc';
%mask_file='/home/nersc/matsbn/NorClim/diag/CORE2/SO/mask/tnx1v1/world_ocean_mask.dat';
mask_file=['/hexagon/work/milicak/noresm/' expid '/run/ipwocn.nc'];
prefix=['/hexagon/work/milicak/archive/' expid '/ocn/hist/' expid '.micom.hm.'];

% Get dimensions and time attributes and read depths
sdate=sprintf('%4.4d%c%2.2d',fyear,datesep,1);
nx_a=ncgetdim([prefix sdate '.nc'],'x');
ny_a=ncgetdim([prefix sdate '.nc'],'y');
nz_a=ncgetdim([prefix sdate '.nc'],'depth');
%ny_a=ny_a-1;
time_long_name=ncgetatt([prefix sdate '.nc'],'long_name','time');
time_units=ncgetatt([prefix sdate '.nc'],'units','time');
time_calendar=ncgetatt([prefix sdate '.nc'],'calendar','time');
depth_a=ncgetvar([prefix sdate '.nc'],'depth');
depth_bounds_a=ncgetvar([prefix sdate '.nc'],'depth_bnds');

% Read regrid indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);

% Get dimensions, longitude and latitude of WOA09 grid
dst_grid_dims=ncgetvar(map_file,'dst_grid_dims');
nx_b=dst_grid_dims(1);
ny_b=dst_grid_dims(2);
lon_b=reshape(ncgetvar(map_file,'xc_b'),nx_b,ny_b);
lat_b=reshape(ncgetvar(map_file,'yc_b'),nx_b,ny_b);
lon_b=lon_b(:,1);
lat_b=lat_b(1,:)';

% Read world ocean mask of destination grid
%fid=fopen(mask_file,'r');
%nx=fscanf(fid,'%d',1);
%ny=fscanf(fid,'%d',1);
%world_ocean_mask_a=reshape(fscanf(fid,'%1d'),ny,nx)';
%fclose(fid);
world_ocean_mask_a=ncgetvar(mask_file,'ipwocn');
world_ocean_mask_a(find(world_ocean_mask_a>1))=0;
%world_ocean_mask_a=world_ocean_mask_a(:,1:end-1);

% Create netcdf file.
ncid=netcdf.create([expid '_zonal_mean_sigma_annual_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
lat_dimid=netcdf.defDim(ncid,'lat',ny_b);
depth_dimid=netcdf.defDim(ncid,'depth',nz_a);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
nbounds_dimid=netcdf.defDim(ncid,'nbounds',2);

% Define variables and assign attributes
time_varid=netcdf.defVar(ncid,'time','double',time_dimid);
netcdf.putAtt(ncid,time_varid,'long_name',time_long_name);
netcdf.putAtt(ncid,time_varid,'units',time_units);
netcdf.putAtt(ncid,time_varid,'calendar',time_calendar);

lat_varid=netcdf.defVar(ncid,'lat','double',lat_dimid);
netcdf.putAtt(ncid,lat_varid,'long_name','latitude');
netcdf.putAtt(ncid,lat_varid,'units','degrees_north');

depth_varid=netcdf.defVar(ncid,'depth','double',depth_dimid);
netcdf.putAtt(ncid,depth_varid,'long_name','depth');
netcdf.putAtt(ncid,depth_varid,'units','m');
netcdf.putAtt(ncid,depth_varid,'bounds','depth_bounds');

depth_bounds_varid=netcdf.defVar(ncid,'depth_bounds','double',[nbounds_dimid depth_dimid]);
netcdf.putAtt(ncid,depth_bounds_varid,'long_name','depth boundaries');
netcdf.putAtt(ncid,depth_bounds_varid,'units','m');

szm_varid=netcdf.defVar(ncid,'sigma','float',[lat_dimid depth_dimid time_dimid]);
netcdf.putAtt(ncid,szm_varid,'long_name','potential density referenced to 2000 db');
netcdf.putAtt(ncid,szm_varid,'units','kg m-3');
netcdf.putAtt(ncid,szm_varid,'_FillValue',single(fill_value));

% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for time invariant variables.
netcdf.putVar(ncid,lat_varid,lat_b);
netcdf.putVar(ncid,depth_varid,depth_a);
netcdf.putVar(ncid,depth_bounds_varid,depth_bounds_a);

% Retrieve zonal potential density and write to netcdf variables
t_b=zeros(nx_b,ny_b,nz_a);
weight_b=zeros(nx_b,ny_b,nz_a);
n=0;
for year=fyear:lyear
  n=n+1;
  % Create annual mean
  sigmalvl=zeros(nx_a,ny_a,nz_a);
  time=0;
  for month=1:12
    sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
    disp(sdate)
    tmp1=ncgetvar([prefix sdate '.nc'],'templvl');
    tmp2=ncgetvar([prefix sdate '.nc'],'salnlvl');
    tmp1=rho(2000,tmp1,tmp2)-1000;
%    sigmalvl=sigmalvl+tmp1(:,1:end-1,:);
    sigmalvl=sigmalvl+tmp1;
    tmp=ncgetvar([prefix sdate '.nc'],'time');
    time=time+tmp;
  end
  sigmalvl=sigmalvl/12;
  time=time/12;
  % Interpolate model data to WOA09 grid
  for k=1:nz_a
    s_a=reshape(sigmalvl(:,:,k),[],1);
    mask_a=reshape(world_ocean_mask_a,[],1);
    mask_a(find(isnan(s_a)))=0;
    s_a(find(mask_a==0))=0;
    s_b(:,:,k)=reshape(S*s_a,nx_b,ny_b);
    weight_b(:,:,k)=reshape(S*mask_a,nx_b,ny_b);
  end
  % Create model zonal means
  szm=squeeze(nansum(s_b)./sum(weight_b));
  szm(isnan(szm))=fill_value;
  netcdf.putVar(ncid,time_varid,n-1,1,time);
  netcdf.putVar(ncid,szm_varid,[0 0 n-1],[ny_b nz_a 1],single(szm));
end

% Close netcdf file
netcdf.close(ncid)
