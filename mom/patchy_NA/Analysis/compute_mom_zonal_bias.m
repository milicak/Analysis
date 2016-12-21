clear all

%load ctrl_patch_90_120_years_fields.mat
mask_file='/fimm/home/bjerknes/milicak/Analysis/mom/APE/SO/Analysis/grid_spec_v6_regMask.nc';
mask=ncgetvar(mask_file,'tmask');
area=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc','area_t');
lat=ncgetvar('/bcmhsm/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/grids_bathymetry/ocean.static.nc','geolat_t');

depth_mom=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/INPUT_initial/ocean_temp_salt.res.nc','ZT');
tempwoa=ncgetvar('levitus_ewg_temp_ANN.nc','TEMP');



%ctrl 
temp1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00630101.ocean_month.nc','temp');
salt1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00630101.ocean_month.nc','salt');
dz1=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_ctrl/history_63-124years/00630101.ocean_month.nc','dht');
temp1=squeeze(temp1(:,:,:,361:end)); %30 years
%salt1=squeeze(salt1(:,:,:,361:end)); %30 years
dz1=squeeze(dz1(:,:,:,361:end)); %30 years

temp_mom=squeeze(nanmean(temp1,4));
%salt_mom=squeeze(nanmean(salt1,4));
dz_mom=squeeze(nanmean(dz1,4));


%patchy
temp2=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_02/history_63-124years/00630101.ocean_month.nc','temp');
salt2=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_02/history_63-124years/00630101.ocean_month.nc','salt');
dz2=ncgetvar('/export/grunchfs/unibjerknes/milicak/bckup/mom/om3_core3_patchy_full_02/history_63-124years/00630101.ocean_month.nc','dht');
temp2=squeeze(temp2(:,:,:,361:end)); %30-62 years
%salt2=squeeze(salt2(:,:,:,361:end)); %30-62 years
dz2=squeeze(dz2(:,:,:,361:end)); %30-62 years

temp2_mom=squeeze(nanmean(temp2,4));
%salt2_mom=squeeze(nanmean(salt2,4));
dz2_mom=squeeze(nanmean(dz2,4));


maskAtl=mask;
maskAtl(maskAtl~=2)=NaN;
maskAtl(isnan(maskAtl)==0)=1;

area=repmat(area,[1 1 50]);
maskAtl=repmat(maskAtl,[1 1 50]);

tmp=tempwoa.*maskAtl;
vtmp=maskAtl;
tempwoa_zonal=squeeze(nanmean(tmp,1))./squeeze(nanmean(vtmp,1));

tmp=temp_mom.*dz_mom.*maskAtl;
vtmp=dz_mom.*maskAtl;
temp1_zonal=squeeze(nanmean(tmp,1))./squeeze(nanmean(vtmp,1));

tmp=temp2_mom.*dz2_mom.*maskAtl;
vtmp=dz2_mom.*maskAtl;
temp2_zonal=squeeze(nanmean(tmp,1))./squeeze(nanmean(vtmp,1));

save ctrl_patch_90_120_years_fields tempwoa_zonal temp1_zonal temp2_zonal depth_mom lat
%pcolor(lat(1,:),-depth_mom,temp1_zonal'-tempwoa_zonal');shf

if 0
for i=1:360
for j=1:180
  zwoa=squeeze(cumsum(dzwoa(i,j,:)));
  zmom=squeeze(cumsum(dz_dst(i,j,:)));
  for k=1:50
  tempwoa(i,j,k)=interp1(zwoa,squeeze(temp_an_woa(i,j,:)),zmom(k));
  end
end
end
end

