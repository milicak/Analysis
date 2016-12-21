% this module interpolates mom temp and salt values into 1 deg WOA grid
clear all

root_folder = ['/export/grunchfs/unibjerknes/milicak/bckup/mom/'];
project_name = ['om3_core3_ctrl'];
project_name1 = ['om3_core3_patchy_full_01'];
project_name2 = ['om3_core3_patchy_full_02'];
hist_folder = ['history_63-124years'];

filename = [root_folder project_name '/' hist_folder '/' '00630101.ocean_month.nc'];
%filename1 = [root_folder project_name '/' hist_folder '/' '00630101.ocean_month.nc'];
filename2 = [root_folder project_name2 '/' hist_folder '/' '00630101.ocean_month.nc'];

temp = ncgetvar(filename,'salt');
temp = squeeze(temp(:,:,:,361:end)); %30-62 years
temp = squeeze(nanmean(temp,4));

temp2 = ncgetvar(filename2,'salt');
temp2 = squeeze(temp2(:,:,:,361:end)); %30-62 years
temp2 = squeeze(nanmean(temp2,4));

%dz1 = ncgetvar(filename,'dht');
%dz1=squeeze(dz1(:,:,:,361:end)); %30-62 years

mask_file='/fimm/home/bjerknes/milicak/Analysis/mom/APE/SO/Analysis/grid_spec_v6_regMask.nc';
mask=ncgetvar(mask_file,'tmask');
depth_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','ZT');

% Old Levitus
%tempwoa=ncgetvar('levitus_ewg_temp_ANN.nc','TEMP');
% WOA09
tempwoa = ncgetvar('WOA09_ann_salinity_cm2m_extrap.nc','S_AN');
lon = ncgetvar('levitus_ewg_temp_salt_cm2m.nc','x_T');
lat = ncgetvar('levitus_ewg_temp_salt_cm2m.nc','y_T');

sss_bias=squeeze(temp(:,:,1)-tempwoa(:,:,1));
figure(1)
% sst bias of control
m_proj('Equidistant Cylindrical','lon',[-280 80],'lat',[-90 90]);
m_pcolor(lon,lat,sss_bias);shfn
caxis([-4 4])
m_coast('patch',[.7 .7 .7])
m_grid
colormap(bluewhitered(32))
printname='paperfigs/sss_bias_ctrl';
print(1,'-depsc2',printname)

sss_diff=squeeze(temp2(:,:,1)-temp(:,:,1));
figure(2)
% sst diff between patchy02 and control
m_proj('Equidistant Cylindrical','lon',[-280 80],'lat',[-90 90]);
m_pcolor(lon,lat,sss_diff);shfn
caxis([-4 4])
m_coast('patch',[.7 .7 .7])
m_grid
colormap(bluewhitered(32))
printname='paperfigs/sss_diff_patchy2_ctrl';
print(2,'-depsc2',printname)

