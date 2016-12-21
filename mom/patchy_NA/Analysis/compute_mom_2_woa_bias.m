% this module interpolates mom temp and salt values into 1 deg WOA grid
clear all

year='13'; % 09 or 13 WOA
mask_file='/fimm/home/bjerknes/milicak/Analysis/mom/APE/SO/Analysis/grid_spec_v6_regMask.nc';
mask=ncgetvar(mask_file,'tmask');
depth_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','ZT');

if(year=='13')
  map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_mom_to_woa13_1deg_patch_.nc';
  woa_file_path='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/woa013/';
  twoa_file=[woa_file_path 'woa13_decav_ptemp_annual_01.nc'];
  swoa_file=[woa_file_path 'woa13_decav_s_annual_01.nc'];
  temp_an_woa=ncgetvar(twoa_file,'ptemp_an');
  salt_an_woa=ncgetvar(swoa_file,'s_an');
  depth=ncgetvar(swoa_file,'depth');
  lon=ncgetvar(twoa_file,'lon');
  lat=ncgetvar(twoa_file,'lat');
  d1=ncgetvar(twoa_file,'depth_bnds');
  dzwoa=d1(2,:)-d1(1,:);
  dzwoa=repmat(dzwoa,[360 1 180]);
  dzwoa=permute(dzwoa,[1 3 2]);
elseif(year=='09')
  map_file='/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/maps/map_mom_to_woa09_1deg_patch_.nc';
  woa_file_path='/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/';
  twoa_file=[woa_file_path 't00an1.nc'];
  swoa_file=[woa_file_path 's00an1.nc'];
  temp_an_woa=ncgetvar(twoa_file,'t');
  salt_an_woa=ncgetvar(swoa_file,'s');
  lon=ncgetvar(twoa_file,'lon');
  lat=ncgetvar(twoa_file,'lat');
  depth=ncgetvar(swoa_file,'depth');
end

nx_b=size(temp_an_woa,1);
ny_b=size(temp_an_woa,2);
nz_b=size(temp_an_woa,3);
nz_a=50;

% Read interpolation indexes and weights
n_a=ncgetdim(map_file,'n_a');
n_b=ncgetdim(map_file,'n_b');
S=sparse(ncgetvar(map_file,'row'),ncgetvar(map_file,'col'), ...
         ncgetvar(map_file,'S'),n_b,n_a);

if 1 
%ctrl 
%temp1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/ocean_month_1_62.nc','temp');
%salt1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/ocean_month_1_62.nc','salt');
%dz1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/ocean_month_1_62.nc','dht');
temp1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00630101.ocean_month.nc','temp');
salt1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00630101.ocean_month.nc','salt');
dz1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00630101.ocean_month.nc','dht');
temp1=squeeze(temp1(:,:,:,361:end)); %30-62 years
salt1=squeeze(salt1(:,:,:,361:end)); %30-62 years
dz1=squeeze(dz1(:,:,:,361:end)); %30-62 years

temp_mom=squeeze(nanmean(temp1,4));
salt_mom=squeeze(nanmean(salt1,4));
dz_mom=squeeze(nanmean(dz1,4));

% Interpolate model data to WOA grid
t_dst=zeros(nx_b,ny_b,nz_a);
s_dst=zeros(nx_b,ny_b,nz_a);
dz_dst=zeros(nx_b,ny_b,nz_a);
for k=1:nz_a
  t_src=reshape(temp_mom(:,:,k),[],1);
  s_src=reshape(salt_mom(:,:,k),[],1);
  dz_src=reshape(dz_mom(:,:,k),[],1);
  t_src(find(isnan(t_src)))=0;
  s_src(find(isnan(s_src)))=0;
  dz_src(find(isnan(dz_src)))=0;
  s_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b);
  t_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b);
  dz_dst(:,:,k)=reshape(S*dz_src,nx_b,ny_b);
end

%break
% upper 250m
temp_woa_250=temp_an_woa(:,:,1:27).*dzwoa(:,:,1:27);
temp_woa_250=squeeze(nansum(temp_woa_250,3))./262.5;
temp_mom_250=t_dst(:,:,1:25).*dz_dst(:,:,1:25);
temp_mom_250=squeeze(nansum(temp_mom_250,3))./squeeze(nansum(squeeze(dz_dst(:,:,1:25)),3));

sst_bias=sq(t_dst(:,:,1)-temp_an_woa(:,:,2));
sss_bias=sq(s_dst(:,:,1)-salt_an_woa(:,:,2));

figure
if(year=='13')
  m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
elseif(year=='09')
  m_proj('Equidistant Cylindrical','lon',[0 360],'lat',[-90 90]);
end
m_pcolor(lon,lat,sst_bias');shfn
caxis([-4 4])
m_coast('patch',[.7 .7 .7])
m_grid
colormap(bluewhitered(32))
%print('-depsc2','-r300','paperfigs/sst_bias_ctrl')
%close
end

% patchy
%temp2=ncgetvar('/hexagon/work/milicak/RUNS/mom/om3_core3_2/om3_core3/history/00630101.ocean_month.nc','temp');
%salt2=ncgetvar('/hexagon/work/milicak/RUNS/mom/om3_core3_2/om3_core3/history/00630101.ocean_month.nc','salt');
%dz2=ncgetvar('/hexagon/work/milicak/RUNS/mom/om3_core3_2/om3_core3/history/00630101.ocean_month.nc','dht');
temp2=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_02/history_63-124years/00630101.ocean_month.nc','temp');
salt2=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_02/history_63-124years/00630101.ocean_month.nc','salt');
dz2=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_02/history_63-124years/00630101.ocean_month.nc','dht');
%temp2=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_02/history/00010101.ocean_month.nc','temp');
%salt2=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_02/history/00010101.ocean_month.nc','salt');
%dz2=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_02/history/00010101.ocean_month.nc','dht');
temp2=squeeze(temp2(:,:,:,361:end)); %30-62 years
salt2=squeeze(salt2(:,:,:,361:end)); %30-62 years
dz2=squeeze(dz2(:,:,:,361:end)); %30-62 years

temp2_mom=squeeze(nanmean(temp2,4));
salt2_mom=squeeze(nanmean(salt2,4));
dz2_mom=squeeze(nanmean(dz2,4));

% Interpolate model data to WOA grid
t2_dst=zeros(nx_b,ny_b,nz_a);
s2_dst=zeros(nx_b,ny_b,nz_a);
dz2_dst=zeros(nx_b,ny_b,nz_a);
for k=1:nz_a
  t_src=reshape(temp2_mom(:,:,k),[],1);
  s_src=reshape(salt2_mom(:,:,k),[],1);
  dz_src=reshape(dz2_mom(:,:,k),[],1);
  t_src(find(isnan(t_src)))=0;
  s_src(find(isnan(s_src)))=0;
  dz_src(find(isnan(dz_src)))=0;
  s2_dst(:,:,k)=reshape(S*s_src,nx_b,ny_b);
  t2_dst(:,:,k)=reshape(S*t_src,nx_b,ny_b);
  dz2_dst(:,:,k)=reshape(S*dz_src,nx_b,ny_b);
end
temp2_mom_250=t2_dst(:,:,1:25).*dz2_dst(:,:,1:25);
temp2_mom_250=squeeze(nansum(temp2_mom_250,3))./squeeze(nansum(squeeze(dz2_dst(:,:,1:25)),3));

sst_diff=sq(t2_dst(:,:,1)-t_dst(:,:,1));
sss_diff=sq(s2_dst(:,:,1)-s_dst(:,:,1));

sst2_bias=sq(t2_dst(:,:,1)-temp_an_woa(:,:,2));
sss2_bias=sq(s2_dst(:,:,1)-salt_an_woa(:,:,2));

if 1
figure
m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
m_pcolor(lon,lat,sst2_bias');shfn
caxis([-4 4])
m_coast('patch',[.7 .7 .7])
colormap(bluewhitered(32))
m_grid
end

figure
m_proj('Equidistant Cylindrical','lon',[-180 180],'lat',[-90 90]);
m_pcolor(lon,lat,sst_diff');shfn
caxis([-2 2])
m_coast('patch',[.7 .7 .7])
colormap(bluewhitered(32))
m_grid
%print('-depsc2','-r300','paperfigs/sst_bias_ctrl_patchy')
