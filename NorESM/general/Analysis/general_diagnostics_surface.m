function [sst_data sss_data sst_woa09 sss_woa09]= general_diagnostics_surface(map_file,expid,fyear,lyear,low)

%low=false;

if(low)
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
else %high resolution woa
  t_woa09_file='/export/grunchfs/unibjerknes/milicak/bckup/OISST/woa13_decav_t00_04v2.nc';
  s_woa09_file='/export/grunchfs/unibjerknes/milicak/bckup/OISST/woa13_decav_s00_04v2.nc';
  % Load WOA09 data
  if exist(['woa09an1_04.mat'])
    load(['woa09an1_04.mat'])
  else
    lat=ncgetvar(t_woa09_file,'lat');
    lon=ncgetvar(t_woa09_file,'lon');
    depth=ncgetvar(t_woa09_file,'depth');
    t=ncgetvar(t_woa09_file,'t_an');
    s=ncgetvar(s_woa09_file,'s_an');
    [nx ny nz]=size(t);
    p=reshape(ones(nx*ny,1)*depth',nx,ny,nz);
    ptmp=theta_from_t(s,t,p,zeros(nx,ny,nz));
    save('woa09an1_04.mat','nx','ny','nz','lat','lon','depth','t','s','ptmp');
  end
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
  sst_woa09=ptmp(:,:,1);
  sss_woa09=s(:,:,1);
  clear nx ny nz lon lat depth t s ptmp
% Load time averaged model data
load(['matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat']);
%load(['/export/grunchfs/unibjerknes/milicak/bckup/Analysis/NorESM/general/Analysis/matfiles/' expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat']);
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

% Interpolate model data to WOA09 grid
t_dst=zeros(nx_b,ny_b);
s_dst=zeros(nx_b,ny_b);
%surface values
t_src=reshape(templvl(:,1:end-1,1),[],1);
s_src=reshape(salnlvl(:,1:end-1,1),[],1);
t_src(find(isnan(t_src)))=0;
s_src(find(isnan(s_src)))=0;
t_dst(:,:)=reshape(S*t_src,nx_b,ny_b);
s_dst(:,:)=reshape(S*s_src,nx_b,ny_b);

if(low)

else
  dd(1:720,:)=t_dst(721:1440,:);
  dd(721:1440,:)=t_dst(1:720,:);
  t_dst=dd;
  dd(1:720,:)=s_dst(721:1440,:);
  dd(721:1440,:)=s_dst(1:720,:);
  s_dst=dd;
end

sst_data=t_dst;
sss_data=s_dst;
