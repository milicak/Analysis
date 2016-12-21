clear all

folder_name='/export/grunchfs/unibjerknes/milicak/bckup/Analysis/NorESM/general/Analysis/matfiles/';

%map_file = '/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/map_tnx1v1_to_woa09_aave_20120501.nc'; %1 degree
map_file = '/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/map_noresm_tnx0.25v1_to_woa09_1deg_aave_.nc'; %0.25 degree

% tripolar 1degree grid
%grid_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';
% tripolar 0.25degree grid
grid_file = '/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/maps/grid_0_25degree.nc';

pclon=reshape(ncgetvar(grid_file,'pclon'),[],4)';
pclat=reshape(ncgetvar(grid_file,'pclat'),[],4)';

project_name='NOIIA_T62_tn025_001'
%project_name='NOIIA_T62_tn11_sr10m60d_01'

fyear=100;
lyear=120;

filename=[folder_name project_name '_timemean_' num2str(fyear) '_' num2str(lyear) '.mat']
load(filename)

lonpts=[-32.5 -21.5 -10.5 -2.5 3.5 11.5 10.5];
latpts=[52.5 53.5 58.5 60.5 63.5 68.5 76.5];


t_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/t00an1.nc';
s_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/s00an1.nc';
mask_woa09_file='/fimm/home/bjerknes/milicak/Analysis/NorESM/general/Analysis/woa_mask.mat';

% Read WOA09 Southern Ocean mask
load([mask_woa09_file]);
% Load WOA09 data
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
sst_woa09=ptmp(:,:,1);
sss_woa09=s(:,:,1);
clear nx ny nz lon lat depth t s ptmp


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

sst_data=t_dst;
sss_data=s_dst;


figure(1)
dnm=sst_data-sst_woa09;
dd=dnm(181:end,:);dd(181:360,:)=dnm(1:180,:);
dnm=dd;
m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
m_pcolor(lon_woa09-180,lat_woa09,dnm');
shf
colormap(rainbow)
caxis([-6 6])
xlabel('Lon')
ylabel('Lat')
%     m_gshhs_l('patch',[.7 .7 .7]);
m_coast('patch',[.7 .7 .7]);
m_grid

printname=['paperfigs/' project_name '_sst_bias.eps']
print(1,'-depsc2','-r300',printname)

%close

