function [t_zm_dst s_zm_dst ptmp_zm_woa09_a s_zm_woa09_a ]= ...
         general_diagnostics_depth_bias(map_file,expid,fyear,lyear,mask_index,root_folder,depth_cri)

fill_value=-1e33;

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

% Load time averaged model data
load([root_folder expid '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat'])
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
difdia_dst=zeros(nx_b,ny_b,nz_a);
difiso_dst=zeros(nx_b,ny_b,nz_a);
weight_dst=zeros(nx_b,ny_b,nz_a);
for k=1:nz_a
  t_src=reshape(templvl(:,1:end-1,k),[],1);
  s_src=reshape(salnlvl(:,1:end-1,k),[],1);
  difiso_src=reshape(difisolvl(:,1:end-1,k),[],1);
  difdia_src=reshape(difdialvl(:,1:end-1,k),[],1);
  mask_src=ones(size(t_src));
  mask_src(find(isnan(t_src)))=0;
  t_src(find(isnan(t_src)))=0;
  s_src(find(isnan(s_src)))=0;
  difiso_src(find(isnan(difiso_src)))=0;
  difdia_src(find(isnan(difdia_src)))=0;
  t_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b);
  s_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b);
  difiso_dst(:,:,k)=reshape(S*difiso_src,nx_b,ny_b);
  difdia_dst(:,:,k)=reshape(S*difdia_src,nx_b,ny_b);
  weight_dst(:,:,k)=reshape(S*mask_src,nx_b,ny_b);
end

if(depth_cri == 500)
  kindexwoa=14;
  kindexmdl=27;
elseif(depth_cri == 1000)
  kindexwoa=19;
  kindexmdl=37;
elseif(depth_cri == 2000)
  kindexwoa=26;
  kindexmdl=51;
end

t_zm_dst=t_dst(:,:,kindexmdl); 
s_zm_dst=s_dst(:,:,kindexmdl);
ptmp_zm_woa09_a=ptmp_woa09(:,:,kindexwoa); 
s_zm_woa09_a=s_woa09(:,:,kindexwoa);

figure
%pcolor(lon_woa09,lat_woa09,sq(t_dst(:,:,kindexmdl)-ptmp_woa09(:,:,kindexwoa))');shfn;caxis([-2 2])
pcolor(lon_woa09,lat_woa09,sq(s_dst(:,:,kindexmdl)-s_woa09(:,:,kindexwoa))');shfn;caxis([-2 2])
