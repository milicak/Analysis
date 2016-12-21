% this module interpolates mom temp and salt values into 1 deg WOA grid
% upper 800meter
clear all

index = 33; %728 meter
root_folder = ['/export/grunchfs/unibjerknes/milicak/bckup/mom/'];
project_name = ['om3_core3_ctrl'];
project_name1 = ['om3_core3_patchy_full_01'];
project_name2 = ['om3_core3_patchy_full_02'];
hist_folder = ['history_63-124years'];

filename = [root_folder project_name '/' hist_folder '/' '00630101.ocean_month.nc'];
%filename1 = [root_folder project_name '/' hist_folder '/' '00630101.ocean_month.nc'];
filename2 = [root_folder project_name2 '/' hist_folder '/' '00630101.ocean_month.nc'];

temp = ncgetvar(filename,'temp');
temp = squeeze(temp(:,:,:,361:end)); %30-62 years
temp = squeeze(nanmean(temp,4));
dz = ncgetvar(filename,'dht');
dz = squeeze(dz(:,:,:,361:end)); %30-62 years
dz = squeeze(nanmean(dz,4));

temp2 = ncgetvar(filename2,'temp');
temp2 = squeeze(temp2(:,:,:,361:end)); %30-62 years
temp2 = squeeze(nanmean(temp2,4));
dz2 = ncgetvar(filename2,'dht');
dz2 = squeeze(dz2(:,:,:,361:end)); %30-62 years
dz2 = squeeze(nanmean(dz2,4));


mask_file='/fimm/home/bjerknes/milicak/Analysis/mom/APE/SO/Analysis/grid_spec_v6_regMask.nc';
mask=ncgetvar(mask_file,'tmask');
depth_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','ZT');

% Old Levitus
%tempwoa=ncgetvar('levitus_ewg_temp_ANN.nc','TEMP');
% WOA09
tempwoa = ncgetvar('WOA09_ann_theta_cm2m_extrap.nc','POTENTIAL_TEMP');
dzwoa = ncgetvar('WOA09_ann_theta_cm2m_extrap.nc','DEPTH_bnds');
dzwoa = dzwoa(2,:)-dzwoa(1,:);
dzwoa = repmat(dzwoa,[360 1 200]);
dzwoa = permute(dzwoa,[1 3 2]);
lon = ncgetvar('levitus_ewg_temp_salt_cm2m.nc','x_T');
lat = ncgetvar('levitus_ewg_temp_salt_cm2m.nc','y_T');

tempwoa_dep=tempwoa(:,:,1:index).*dzwoa(:,:,1:index);
tempwoa_dep=squeeze(nansum(tempwoa_dep,3))./793.625;

tempmom_dep=temp(:,:,1:index).*dz(:,:,1:index);
tempmom_dep=squeeze(nansum(tempmom_dep,3))./squeeze(nansum(squeeze(dz(:,:,1:index)),3));
tempmom2_dep=temp2(:,:,1:index).*dz2(:,:,1:index);
tempmom2_dep=squeeze(nansum(tempmom2_dep,3))./squeeze(nansum(squeeze(dz2(:,:,1:index)),3));

temp_bias=squeeze(tempmom_dep(:,:)-tempwoa_dep(:,:));
figure(1)
% sst bias of control
m_proj('Equidistant Cylindrical','lon',[-280 80],'lat',[-90 90]);
m_pcolor(lon,lat,temp_bias);shfn
caxis([-5 5])
m_coast('patch',[.7 .7 .7])
m_grid
%colormap(bluewhitered(32))
printname=['paperfigs/temp_bias_ctrl_' num2str(index)];
print(1,'-depsc2',printname)

temp_diff=squeeze(tempmom2_dep(:,:)-tempmom_dep(:,:));
figure(2)
% sst diff between patchy02 and control
m_proj('Equidistant Cylindrical','lon',[-280 80],'lat',[-90 90]);
m_pcolor(lon,lat,temp_diff);shfn
caxis([-5 5])
m_coast('patch',[.7 .7 .7])
m_grid
%colormap(bluewhitered(32))
printname=['paperfigs/temp_diff_patchy2_ctrl_' num2str(index)];
print(2,'-depsc2',printname)

