clear all
expid='NOIIA_T62_tn11_003'
%expid='NOIIA_T62_tn11_sr10m60d_01';
fyear=1;
lyear=100;
fill_value=-1e33;

map_file='../../../climatology/Analysis/map_tnx1v1_to_woa09_aave_20120501.nc';
t_woa09_file='/bcmhsm/milicak/RUNS/noresm/CORE2/kepsilon/t00an1.nc';
s_woa09_file='/bcmhsm/milicak/RUNS/noresm/CORE2/kepsilon/s00an1.nc';
mask_woa09_file='../../../climatology/Analysis/atlantic_mask_v2.dat';

% Read WOA09 atlantic mask
fid=fopen(mask_woa09_file,'r');
nx=fscanf(fid,'%d',1);
ny=fscanf(fid,'%d',1);
mask_woa09=reshape(fscanf(fid,'%1d'),ny,nx)';
fclose(fid);

% Load WOA09 data
if exist(['woa09an1.mat'])
  load(['woa09an1.mat'])
else
  lat=ncgetvar(t_woa09_file,'lat');
  lon=ncgetvar(t_woa09_file,'lon');
  depth=ncgetvar(t_woa09_file,'depth');
  t=ncgetvar(t_woa09_file,'t');
  s=ncgetvar(s_woa09_file,'s');
  [nx ny nz]=size(t);
  p=reshape(ones(nx*ny,1)*depth',nx,ny,nz);
  ptmp=theta_from_t(s,t,p,zeros(nx,ny,nz));
  save('woa09an1.mat','nx','ny','nz','lat','lon','depth','t','s','ptmp');
end
nx_b=nx;
ny_b=ny;
nz_b=nz;
lon_woa09=lon;
lat_woa09=lat;
depth_woa09=depth;
t_woa09=t;
s_woa09=s;
ptmp_woa09=ptmp;
clear nx ny nz lon lat depth t s ptmp

% Load time averaged model data
%load([expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat'])
filename=['/bcmhsm/milicak/RUNS/noresm/CORE2/kepsilon/' expid '_salinity_annual_1-100.nc'];
saln=ncgetvar(filename,'saln');
saln=squeeze(nanmean(saln,4));
nx=size(saln,1);ny=size(saln,2);
depth=nc_varget(filename,'depth');
filename=['/bcmhsm/milicak/RUNS/noresm/CORE2/kepsilon/' expid '_temperature_annual_1-100.nc'];
temp=ncgetvar(filename,'temp');
temp=squeeze(nanmean(temp,4));

nx_a=nx;
ny_a=ny;
depth_a=depth;
nz_a=find(depth_woa09(end)==depth_a);
depth_a=depth_a(1:nz_a);

% Read interpolation indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);


% Create 3D masks for atlantic
mask_3d_woa09=reshape(reshape(mask_woa09,[],1)*ones(1,nz_b),nx_b,ny_b,nz_b);
mask_3d_woa09(find(isnan(t_woa09)|mask_3d_woa09~=2))=0;
mask_3d_woa09(find(mask_3d_woa09==2))=1;
mask_3d_dst=reshape(reshape(mask_woa09,[],1)*ones(1,nz_a),nx_b,ny_b,nz_a);
mask_3d_dst(find(mask_3d_dst~=2))=0;
mask_3d_dst(find(mask_3d_dst==2))=1;

% Interpolate model data to WOA09 grid
t_dst=zeros(nx_b,ny_b,nz_a);
s_dst=zeros(nx_b,ny_b,nz_a);
weight_dst=zeros(nx_b,ny_b,nz_a);
for k=1:nz_a
  t_src=reshape(temp(:,1:end,k),[],1);
  s_src=reshape(saln(:,1:end,k),[],1);
  mask_src=ones(size(t_src));
  mask_src(find(isnan(t_src)))=0;
  t_src(find(isnan(t_src)))=0;
  s_src(find(isnan(s_src)))=0;
  t_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b);
  s_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b);
  weight_dst(:,:,k)=reshape(S*mask_src,nx_b,ny_b);
end

% Create WOA09 zonal means
ptmp_zm_woa09=squeeze(nansum(ptmp_woa09.*mask_3d_woa09)./sum(mask_3d_woa09));
ptmp_zm_woa09_a=interp1(depth_woa09,ptmp_zm_woa09',depth_a)';
s_zm_woa09=squeeze(nansum(s_woa09.*mask_3d_woa09)./sum(mask_3d_woa09));
s_zm_woa09_a=interp1(depth_woa09,s_zm_woa09',depth_a)';
for j=1:ny_b
  k=find(isnan(ptmp_zm_woa09_a(j,:)),1,'first');
  if ~isempty(k)&&k>1
    ptmp_zm_woa09_a(j,k)=ptmp_zm_woa09_a(j,k-1);
    s_zm_woa09_a(j,k)=s_zm_woa09_a(j,k-1);
  end
end

% Create model zonal means
t_zm_dst=squeeze(nansum(t_dst.*mask_3d_dst)./sum(weight_dst.*mask_3d_dst));
s_zm_dst=squeeze(nansum(s_dst.*mask_3d_dst)./sum(weight_dst.*mask_3d_dst));

% Plot figures
%figure(1);clf
%pcolor(lat_woa09,-depth_a,(t_zm_dst-ptmp_zm_woa09_a)');shading flat;caxis([-5 5]);colorbar
%figure(2);clf
%pcolor(lat_woa09,-depth_a,(s_zm_dst-s_zm_woa09_a)');shading flat;caxis([-1 1]);colorbar
%figure(3);clf
%pcolor(lat_woa09,-depth_a,a_zm_dst');shading flat;caxis([0 300]);colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write netCDF files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tdiff=t_zm_dst-ptmp_zm_woa09_a;
tdiff(isnan(tdiff))=fill_value;
sdiff=s_zm_dst-s_zm_woa09_a;
sdiff(isnan(sdiff))=fill_value;
salt=s_zm_dst;
swoa=s_zm_woa09_a;
salt(isnan(salt))=fill_value;
swoa(isnan(swoa))=fill_value;
temp=t_zm_dst;
twoa=ptmp_zm_woa09_a;
temp(isnan(temp))=fill_value;
twoa(isnan(twoa))=fill_value;


% Create netcdf file.
ncid=netcdf.create(['/bcmhsm/milicak/RUNS/noresm/CORE2/kepsilon/' expid '_atlantic_zonalmean_timemean_' num2str(fyear) '-' num2str(lyear) '.nc'],'NC_CLOBBER');

% Define dimensions.
lat_dimid=netcdf.defDim(ncid,'lat',ny_b);
depth_dimid=netcdf.defDim(ncid,'depth',nz_a);

% Define variables and assign attributes
lat_varid=netcdf.defVar(ncid,'lat','float',lat_dimid);
netcdf.putAtt(ncid,lat_varid,'long_name','latitude');
netcdf.putAtt(ncid,lat_varid,'units','degrees');

depth_varid=netcdf.defVar(ncid,'depth','float',depth_dimid);
netcdf.putAtt(ncid,depth_varid,'long_name','depth');
netcdf.putAtt(ncid,depth_varid,'positive','down');
netcdf.putAtt(ncid,depth_varid,'units','m');

tdiff_varid=netcdf.defVar(ncid,'tdiff','float',[lat_dimid depth_dimid]);
netcdf.putAtt(ncid,tdiff_varid,'long_name','potential temperature difference from WOA09');
netcdf.putAtt(ncid,tdiff_varid,'units','K');
netcdf.putAtt(ncid,tdiff_varid,'_FillValue',single(fill_value));

tsim_varid=netcdf.defVar(ncid,'temp','float',[lat_dimid depth_dimid]);
netcdf.putAtt(ncid,tsim_varid,'long_name','potential temperature');
netcdf.putAtt(ncid,tsim_varid,'units','K');
netcdf.putAtt(ncid,tsim_varid,'_FillValue',single(fill_value));

twoa_varid=netcdf.defVar(ncid,'twoa','float',[lat_dimid depth_dimid]);
netcdf.putAtt(ncid,twoa_varid,'long_name','WOA09 potential temperature');
netcdf.putAtt(ncid,twoa_varid,'units','K');
netcdf.putAtt(ncid,twoa_varid,'_FillValue',single(fill_value));

sdiff_varid=netcdf.defVar(ncid,'sdiff','float',[lat_dimid depth_dimid]);
netcdf.putAtt(ncid,sdiff_varid,'long_name','salinity difference from WOA09');
netcdf.putAtt(ncid,sdiff_varid,'units','g kg-1');
netcdf.putAtt(ncid,sdiff_varid,'_FillValue',single(fill_value));

ssim_varid=netcdf.defVar(ncid,'salt','float',[lat_dimid depth_dimid]);
netcdf.putAtt(ncid,ssim_varid,'long_name','salinity');
netcdf.putAtt(ncid,ssim_varid,'units','g kg-1');
netcdf.putAtt(ncid,ssim_varid,'_FillValue',single(fill_value));

swoa_varid=netcdf.defVar(ncid,'swoa','float',[lat_dimid depth_dimid]);
netcdf.putAtt(ncid,swoa_varid,'long_name','WOA09 salinity');
netcdf.putAtt(ncid,swoa_varid,'units','g kg-1');
netcdf.putAtt(ncid,swoa_varid,'_FillValue',single(fill_value));


% Global attributes

% End definitions and leave define mode.
netcdf.endDef(ncid)

% Provide values for variables.
netcdf.putVar(ncid,lat_varid,single(lat_woa09));
netcdf.putVar(ncid,depth_varid,single(depth_a));
netcdf.putVar(ncid,tdiff_varid,single(tdiff));
netcdf.putVar(ncid,sdiff_varid,single(sdiff));
netcdf.putVar(ncid,ssim_varid,single(salt));
netcdf.putVar(ncid,swoa_varid,single(swoa));
netcdf.putVar(ncid,tsim_varid,single(temp));
netcdf.putVar(ncid,twoa_varid,single(twoa));

% Close netcdf file
netcdf.close(ncid)
