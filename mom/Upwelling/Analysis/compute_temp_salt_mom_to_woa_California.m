clear all
fyear=1;lyear=100;

resolution=1; %1; %0.5;
nx=360;
ny=180;
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
% convert to km^2
area=grid_area*6371*6371;

temp_initial_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','temp');
salt_initial_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','salt');
area_mom=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc','area_t');

map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_mom_to_woa09_1deg_aave_.nc';
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

filename_s='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/annual_tracers/ocean.1708-2007.salt.nc';
filename_t='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/annual_tracers/ocean.1708-2007.temp.nc';
salt=ncgetvar(filename_s,'salt');
temp=ncgetvar(filename_t,'temp');
lon_woa=ncgetvar(filename_t,'geolon_c');
lat_woa=ncgetvar(filename_t,'geolat_c');
zt=ncgetvar(filename_t,'st_ocean');
nz_a=size(zt,1);
depth_a=zt;

mask_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/general/Analysis/woa_mask.mat';
% Read WOA09 Southern Ocean mask
load([mask_woa09_file]);


load(['/fimm/home/bjerknes/milicak/Analysis/NorESM/general/Analysis/woa09an1.mat'])
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

mask_index=0;
% Create 3D masks for atlantic
mask_3d_woa09=reshape(reshape(mask_woa09,[],1)*ones(1,nz_b),nx_b,ny_b,nz_b);
mask_3d_woa09(find(mask_3d_woa09~=mask_index))=1;
mask_3d_dst=reshape(reshape(mask_woa09,[],1)*ones(1,nz_a),nx_b,ny_b,nz_a);
mask_3d_dst(find(mask_3d_dst~=mask_index))=1;

% new one up to 42N
xx=[243.6613
  241.9747
  240.5411
  239.1075
  237.8848
  236.5355
  235.3549
  234.8489
  234.3008
  233.7105
  233.2888
  233.1623
  233.0358
  232.9937
  231.9817
  233.9213
  237.3366
  240.2881
  243.6613];

yy=[33.1694
   32.8586
   32.8586
   32.8240
   33.0313
   33.5839
   34.2401
   35.0000
   35.8635
   36.7960
   38.0394
   39.0065
   40.0772
   40.9407
   42.0460
   42.7022
   42.7022
   41.1825
   33.1694];

[lon lat]=meshgrid(lon_woa09,lat_woa09);
in=insphpoly(lon,lat,xx,yy,0,90);
in=double(in');
in(in==0)=NaN;
inwoa_1=repmat(in.*area,[1 1 33]);
inmom_1=repmat(in.*area,[1 1 50]);

if 0
% drift from initial conditions of mom
timeind=1;
in=insphpoly(lon_mom,lat_mom,xx,yy,0,90);
in=double(in);
in(in==0)=NaN;
inmom2=repmat(in.*area_mom,[1 1 50]);
for time=1:100
  tmom=squeeze(temp(:,:,:,time));
  smom=squeeze(salt(:,:,:,time));
  tbias=tmom-temp_initial_mom;
  sbias=smom-salt_initial_mom;
  t_zm_dst_in(timeind,:)=squeeze(nansum(nansum(tbias.*inmom2),2)./nansum(nansum(inmom2),2));
  s_zm_dst_in(timeind,:)=squeeze(nansum(nansum(sbias.*inmom2),2)./nansum(nansum(inmom2),2));
  timeind=timeind+1
end %time
end %

% Interpolate model data to WOA09 grid
timeind=1;
for time=fyear:lyear
  tmom=squeeze(temp(:,:,:,time));
  smom=squeeze(salt(:,:,:,time));
  weight_dst=zeros(nx_b,ny_b,nz_a);
for k=1:size(smom,3)
  t_src=reshape(tmom(:,:,k),[],1);
  mask_src=ones(size(t_src));
  mask_src(find(isnan(t_src)))=0;
  s_a=reshape(smom(:,:,k),[],1);
  s_b(:,:,k)=reshape(S*s_a,nx_b,ny_b);
  t_a=reshape(tmom(:,:,k),[],1);
  t_b(:,:,k)=reshape(S*t_a,nx_b,ny_b);
  weight_dst(:,:,k)=reshape(S*mask_src,nx_b,ny_b);
end

inmom=inmom_1;
inmom(t_b==0)=NaN;
inwoa=inwoa_1;
inwoa(isnan(ptmp_woa09)==1)=NaN;

% Create WOA09 zonal means
ptmp_zm_woa09=squeeze(nansum(nansum(ptmp_woa09.*mask_3d_woa09.*inwoa),2)./nansum(nansum(mask_3d_woa09.*inwoa),2));
ptmp_zm_woa09_a=interp1(depth_woa09,ptmp_zm_woa09',depth_a)';
s_zm_woa09=squeeze(nansum(nansum(s_woa09.*mask_3d_woa09.*inwoa),2)./nansum(nansum(mask_3d_woa09.*inwoa),2));
s_zm_woa09_a=interp1(depth_woa09,s_zm_woa09',depth_a)';
for j=1:1
  k=find(isnan(ptmp_zm_woa09_a(j,:)),1,'first');
  if ~isempty(k)&&k>1
    ptmp_zm_woa09_a(j,k)=ptmp_zm_woa09_a(j,k-1);
    s_zm_woa09_a(j,k)=s_zm_woa09_a(j,k-1);
  end
end
ptmp_zm_woa09_time(timeind,:)=ptmp_zm_woa09_a';
s_zm_woa09_time(timeind,:)=s_zm_woa09_a';

%keyboard
% Create model zonal means
t_zm_dst(timeind,:)=squeeze(nansum(nansum(t_b.*mask_3d_dst.*inmom),2)./nansum(nansum(weight_dst.*mask_3d_dst.*inmom),2));
s_zm_dst(timeind,:)=squeeze(nansum(nansum(s_b.*mask_3d_dst.*inmom),2)./nansum(nansum(weight_dst.*mask_3d_dst.*inmom),2));
timeind=timeind+1

end %time

% save(['matfiles/MOM_PeruUpwell_tempsalt_' num2str(fyear) '_' num2str(lyear) '.mat'],'depth_a','ptmp_zm_woa09_a','t_zm_dst','s_zm_dst','s_zm_woa09_a')
% pcolor(1:50,-depth_a,t_zm_dst'-ptmp_zm_woa09_time');shfn
