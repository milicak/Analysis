% this module interpolates mom temp and salt values into 1 deg WOA grid
clear all

mask_file='/fimm/home/bjerknes/milicak/Analysis/mom/APE/SO/Analysis/grid_spec_v6_regMask.nc';
mask=ncgetvar(mask_file,'tmask');
depth_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','ZT');

%for temperature for control 
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00010101.ocean_month.nc','temp');
temp1=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00110101.ocean_month.nc','temp');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00210101.ocean_month.nc','temp');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00410101.ocean_month.nc','temp');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
temp1=reshape(temp1,[360 200 50 12 size(temp1,4)/12]);
temp1=squeeze(nanmean(temp1,4));

temperature1st=temp1;
clear temp1 dnm

%for salinity for control 
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00010101.ocean_month.nc','salt');
temp1=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00110101.ocean_month.nc','salt');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00210101.ocean_month.nc','salt');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00410101.ocean_month.nc','salt');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
temp1=reshape(temp1,[360 200 50 12 size(temp1,4)/12]);
temp1=squeeze(nanmean(temp1,4));

salinity1st=temp1;
clear temp1 dnm

%for dht for control 
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00010101.ocean_month.nc','dht');
temp1=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00110101.ocean_month.nc','dht');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00210101.ocean_month.nc','dht');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00410101.ocean_month.nc','dht');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
temp1=reshape(temp1,[360 200 50 12 size(temp1,4)/12]);
temp1=squeeze(nanmean(temp1,4));

dz1st=temp1;
clear temp1 dnm

%save matfiles
save('matfiles/ctrl_temp_salt.mat','temperature1st','salinity1st','dz1st')


% patchy first cycle
%for temperature for control 
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_01/history_1-62years/00010101.ocean_month.nc','temp');
temp1=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_01/history_1-62years/00310101.ocean_month.nc','temp');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
temp1=reshape(temp1,[360 200 50 12 size(temp1,4)/12]);
temp1=squeeze(nanmean(temp1,4));

temperature1st=temp1;
clear temp1 dnm

%for salinity for control 
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_01/history_1-62years/00010101.ocean_month.nc','salt');
temp1=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_01/history_1-62years/00310101.ocean_month.nc','salt');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
temp1=reshape(temp1,[360 200 50 12 size(temp1,4)/12]);
temp1=squeeze(nanmean(temp1,4));

salinity1st=temp1;
clear temp1 dnm

%for salinity for control 
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_01/history_1-62years/00010101.ocean_month.nc','dht');
temp1=dnm;
dnm=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_01/history_1-62years/00310101.ocean_month.nc','dht');
temp1(:,:,:,end+1:end+size(dnm,4))=dnm;
temp1=reshape(temp1,[360 200 50 12 size(temp1,4)/12]);
temp1=squeeze(nanmean(temp1,4));

dz1st=temp1;
clear temp1 dnm
%save matfiles
save('matfiles/patchy_full_01_temp_salt.mat','temperature1st','salinity1st','dz1st')


break

% second cycle

salt1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00830101.ocean_month.nc','salt');
%temp1(:,:,:,end+1:end+1+239)=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/01030101.ocean_month.nc','temp');
%salt1(:,:,:,end+1:end+1+239)=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/01030101.ocean_month.nc','salt');
temp1(:,:,:,end+1:end+1+239)=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00630101.ocean_month.nc','temp');
salt1(:,:,:,end+1:end+1+239)=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00630101.ocean_month.nc','salt');
dz1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00830101.ocean_month.nc','dht');
dz1(:,:,:,end+1:end+1+239)=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/01030101.ocean_month.nc','dht');
end

%avg between 20 and 30 years
salt1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00210101.ocean_month.nc','salt');
dz1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00210101.ocean_month.nc','dht');
%temp1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00010101.ocean_month.nc','temp');
%salt1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00010101.ocean_month.nc','salt');
%dz1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_1-62years/00010101.ocean_month.nc','dht');
