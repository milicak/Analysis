function [t_zm_dst s_zm_dst ptmp_zm_woa09_a s_zm_woa09_a lat_woa09 depth_a]= ...
         general_diagnostics_upwelling_peru(filename,map_file,mask_index);

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

t_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/t00an1.nc';
s_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/s00an1.nc';
mask_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/general/Analysis/woa_mask.mat';

% Read WOA09 Southern Ocean mask
load([mask_woa09_file]);

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

xx=[ 280.9206
  275.4392
  277.1258
  278.9529
  279.5151
  280.3584
  280.9909
  281.7639
  282.1855
  282.6774
  283.6613
  284.0126
  284.6451
  285.0668
  285.2073
  285.0668
  285.2073
  285.1370
  285.4181
  294.1321
  295.3268
  289.0724
  280.9206];

yy=[-3.9186
   -4.0460
   -6.7847
   -8.9501
  -10.5424
  -11.7525
  -13.3447
  -14.6185
  -15.9560
  -17.6120
  -18.8221
  -19.6500
  -22.0703
  -25.3821
  -28.3119
  -31.1142
  -32.8976
  -34.8719
  -36.2731
  -36.3368
  -18.1852
   -7.5490
   -3.9186];


[lon lat]=meshgrid(lon_woa09,lat_woa09);
in=insphpoly(lon,lat,xx,yy,0,90);
in=double(in');
in(in==0)=NaN;
inwoa=repmat(in.*area,[1 1 33]);
inmicom=repmat(in.*area,[1 1 65]);


% Load time averaged model data
templvl=ncgetvar(filename,'templvl');
salnlvl=ncgetvar(filename,'salnlvl');
depth=ncgetvar(filename,'depth');
nx_a=size(templvl,1);
ny_a=size(templvl,2);
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
if(mask_index~=0)
  mask_3d_woa09(find(isnan(t_woa09)|mask_3d_woa09~=mask_index))=0;
  mask_3d_woa09(find(mask_3d_woa09==mask_index))=1;
  mask_3d_dst=reshape(reshape(mask_woa09,[],1)*ones(1,nz_a),nx_b,ny_b,nz_a);
  mask_3d_dst(find(mask_3d_dst~=mask_index))=0;
  mask_3d_dst(find(mask_3d_dst==mask_index))=1;
else
  mask_3d_woa09(find(mask_3d_woa09~=mask_index))=1;
  mask_3d_dst=reshape(reshape(mask_woa09,[],1)*ones(1,nz_a),nx_b,ny_b,nz_a);
  mask_3d_dst(find(mask_3d_dst~=mask_index))=1;
end

% Interpolate model data to WOA09 grid
t_dst=zeros(nx_b,ny_b,nz_a);
s_dst=zeros(nx_b,ny_b,nz_a);
weight_dst=zeros(nx_b,ny_b,nz_a);
for k=1:nz_a
  t_src=reshape(templvl(:,1:end-1,k),[],1);
  s_src=reshape(salnlvl(:,1:end-1,k),[],1);
  mask_src=ones(size(t_src));
  mask_src(find(isnan(t_src)))=0;
  t_src(find(isnan(t_src)))=0;
  s_src(find(isnan(s_src)))=0;
  t_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b);
  s_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b);
  weight_dst(:,:,k)=reshape(S*mask_src,nx_b,ny_b);
end

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
ptmp_zm_woa09_a=ptmp_zm_woa09_a';
s_zm_woa09_a=s_zm_woa09_a';

%keyboard
% Create model zonal means
t_zm_dst=squeeze(nansum(nansum(t_dst.*mask_3d_dst.*inmicom),2)./nansum(nansum(weight_dst.*mask_3d_dst.*inmicom),2));
s_zm_dst=squeeze(nansum(nansum(s_dst.*mask_3d_dst.*inmicom),2)./nansum(nansum(weight_dst.*mask_3d_dst.*inmicom),2));

