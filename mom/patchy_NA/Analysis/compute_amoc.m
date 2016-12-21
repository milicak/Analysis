% this module interpolates mom temp and salt values into 1 deg WOA grid
clear all
ntime = 744;
lat_cr = 26.5; %North 26.5 for amoc
depth_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','ZT');
lat = ncgetvar('levitus_ewg_temp_salt_cm2m.nc','y_T');
jindex = max(find(lat(1,:)<=lat_cr))+1;
mask_file='/fimm/home/bjerknes/milicak/Analysis/mom/APE/SO/Analysis/grid_spec_v6_regMask.nc';
mask=ncgetvar(mask_file,'tmask');
% Atlantic mask==2
mask(mask~=2)=NaN;
mask(mask==2)=1;
mask=repmat(mask,[1 1 50]);
mask4d=repmat(mask,[1 1 1 ntime*2]);

root_folder = ['/export/grunchfs/unibjerknes/milicak/bckup/mom/'];

%project_name = ['om3_core3_ctrl']
%project_name = ['om3_core3_patchy_full_01']
project_name = ['om3_core3_patchy_full_02']

hist_folder = ['history_63-124years'];
hist_folder0 = ['history_1-62years'];

filename0 = [root_folder project_name '/' hist_folder0 '/' '00010101.ocean_month.nc'];
filename = [root_folder project_name '/' hist_folder '/' '00630101.ocean_month.nc'];

temp = ncgetvar(filename0,'ty_trans');
amoc = temp;
temp = ncgetvar(filename,'ty_trans');
amoc(:,:,:,end+1:end+ntime) = temp;
temp = squeeze(temp(:,:,:,361:end)); %30-62 years
temp = squeeze(nanmean(temp,4));
temp = temp.*mask;
dnm = squeeze(nansum(temp,1));
dnm = cumsum(dnm,2);
amocmean = dnm;
amoc = amoc.*mask4d;
amoc = squeeze(nansum(amoc,1));
amoc = cumsum(amoc,2);
amoc = squeeze(amoc(jindex,:,:));
amoc = max(amoc,[],1);
amoc=amoc';

savename=['matfiles/' project_name '_amoc.mat']
save(savename,'amocmean','amoc');
