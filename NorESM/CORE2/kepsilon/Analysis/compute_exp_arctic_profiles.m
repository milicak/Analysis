clear all
root_dir='/work/milicak/RUNS/noresm/CORE2/kepsilon/';
expid='NOIIA_T62_tn11_002'
%expid='NOIIA_T62_tn11_sr10m60d_01'

grdname='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';

lon=nc_varget(grdname,'plon');
lat=nc_varget(grdname,'plat');
area=nc_varget(grdname,'parea');
area=area(1:end-1,:);
depth2d=nc_varget(grdname,'pdepth');
depth2d=depth2d(1:end-1,:);
mask=nc_varget('../../../Arctic/Analysis/arctic_mask.nc','mask');
mask=mask(1:end-1,:);

year_ini=1;
year_end=100;
filenamet=[root_dir expid '_temperature_annual_' num2str(year_ini) '-' num2str(year_end) '.nc'];
filenames=[root_dir expid '_salinity_annual_' num2str(year_ini) '-' num2str(year_end) '.nc'];

savename=['matfiles/' expid '_basin_profiles_years_' num2str(year_ini) '_' num2str(year_end) '.mat'];

nx=size(lon,2);
ny=size(lon,1);
depth=nc_varget(filenamet,'depth'); 
nz=size(depth,1);
n=0;


area=repmat(area,[1 1 nz]);
area=permute(area,[2 1 3]);
depth3d=repmat(depth,[1 nx ny-1]);
depth3d=permute(depth3d,[2 3 1]);
depth3d_r=repmat(depth2d,[1 1 nz]);
depth3d_r=permute(depth3d_r,[2 1 3]); 
depth3d(depth3d>depth3d_r)=NaN;
area(isnan(depth3d)==1)=NaN;

%for year=year_ini:year_end
templvl=nc_varget(filenamet,'temp');
salnlvl=nc_varget(filenames,'saln');
%end

templvl=squeeze(nanmean(templvl,1));
salnlvl=squeeze(nanmean(salnlvl,1));
templvl=permute(templvl,[3 2 1]);
salnlvl=permute(salnlvl,[3 2 1]);

% Eurasian Basin ==1
dnm=mask;
dnm(mask~=1)=NaN;
dnm(mask==1)=1;
dnm=repmat(dnm,[1 1 nz]);
dnm=permute(dnm,[2 1 3]);
mask_eur=dnm;
temp_eurasian=templvl.*dnm;
salt_eurasian=salnlvl.*dnm;

dnm2=area.*mask_eur;
dnm2=nansum(dnm2,1);
dnm2=squeeze(nansum(dnm2,2));

dnm=temp_eurasian.*area;
dnm=nansum(dnm,1);
dnm=squeeze(nansum(dnm,2));
temp_eurasian_1D=dnm./dnm2;

dnm=salt_eurasian.*area;
dnm=nansum(dnm,1);
dnm=squeeze(nansum(dnm,2));
salt_eurasian_1D=dnm./dnm2;


% Canada Basin ==2
dnm=mask;
dnm(mask~=2)=NaN;
dnm(mask==2)=1;
dnm=repmat(dnm,[1 1 nz]);
dnm=permute(dnm,[2 1 3]);
mask_can=dnm;
temp_canada=templvl.*dnm;
salt_canada=salnlvl.*dnm;

dnm2=area.*mask_can;
dnm2=nansum(dnm2,1);
dnm2=squeeze(nansum(dnm2,2));

dnm=temp_canada.*area;
dnm=nansum(dnm,1);
dnm=squeeze(nansum(dnm,2));
temp_canada_1D=dnm./dnm2;

dnm=salt_canada.*area;
dnm=nansum(dnm,1);
dnm=squeeze(nansum(dnm,2));
salt_canada_1D=dnm./dnm2;


% Makarov Basin ==3
dnm=mask;
dnm(mask~=3)=NaN;
dnm(mask==3)=1;
dnm=repmat(dnm,[1 1 nz]);
dnm=permute(dnm,[2 1 3]);
mask_mak=dnm;
temp_makarov=templvl.*dnm;
salt_makarov=salnlvl.*dnm;

dnm2=area.*mask_mak;
dnm2=nansum(dnm2,1);
dnm2=squeeze(nansum(dnm2,2));

dnm=temp_makarov.*area;
dnm=nansum(dnm,1);
dnm=squeeze(nansum(dnm,2));
temp_makarov_1D=dnm./dnm2;

dnm=salt_makarov.*area;
dnm=nansum(dnm,1);
dnm=squeeze(nansum(dnm,2));
salt_makarov_1D=dnm./dnm2;


%save(savename,'salt_canada_1D','salt_eurasian_1D','salt_makarov_1D','salt_canada','salt_eurasian','salt_makarov', ...
%              'temp_canada_1D','temp_eurasian_1D','temp_makarov_1D','temp_canada','temp_eurasian','temp_makarov','depth')

save(savename,'salt_canada_1D','salt_eurasian_1D','salt_makarov_1D', ...
              'temp_canada_1D','temp_eurasian_1D','temp_makarov_1D','depth')

