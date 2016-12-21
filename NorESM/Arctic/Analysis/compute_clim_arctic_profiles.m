% this subroutine computes climatologic arctic temperature and salinity profiles
% for the makaroc, canada, eurasian basins

clear all

filename='../../climatology/Analysis/climatology_woa.nc'
savename='matfiles/clim_woa_basin_profiles.mat';

%filename='../../climatology/Analysis/climatology_phc.nc'
%savename='clim_phc_basin_profiles.mat';

lon=nc_varget('grid.nc','plon');
lat=nc_varget('grid.nc','plat');
area=nc_varget('grid.nc','parea');
depth2d=nc_varget('grid.nc','pdepth');
mask=nc_varget('arctic_mask.nc','mask');

nx=size(lon,2);
ny=size(lon,1);
depth=nc_varget(filename,'depth'); 
nz=size(depth,1);

area=repmat(area,[1 1 nz]);
area=permute(area,[3 1 2]);
depth3d=repmat(depth,[1 nx ny]);
depth3d=permute(depth3d,[1 3 2]);
depth3d_r=repmat(depth2d,[1 1 nz]);
depth3d_r=permute(depth3d_r,[3 1 2]); 
depth3d(depth3d>depth3d_r)=NaN;
area(isnan(depth3d)==1)=NaN;

templvl=nc_varget(filename,'temp');
salnlvl=nc_varget(filename,'saln');

% Eurasian Basin ==1
dnm=mask;
dnm(mask~=1)=NaN;
dnm(mask==1)=1;
dnm=repmat(dnm,[1 1 nz]);
dnm=permute(dnm,[3 1 2]);
mask_eur=dnm;
temp_eurasian=templvl.*dnm;
salt_eurasian=salnlvl.*dnm;

dnm2=area.*mask_eur;
dnm2=nansum(dnm2,3);
dnm2=squeeze(nansum(dnm2,2));

dnm=temp_eurasian.*area;
dnm=nansum(dnm,3);
dnm=squeeze(nansum(dnm,2));
temp_eurasian_1D=dnm./dnm2;

dnm=salt_eurasian.*area;
dnm=nansum(dnm,3);
dnm=squeeze(nansum(dnm,2));
salt_eurasian_1D=dnm./dnm2;

% Canada Basin ==2
dnm=mask;
dnm(mask~=2)=NaN;
dnm(mask==2)=1;
dnm=repmat(dnm,[1 1 nz]);
dnm=permute(dnm,[3 1 2]);
mask_can=dnm;
temp_canada=templvl.*dnm;
salt_canada=salnlvl.*dnm;

dnm2=area.*mask_can;
dnm2=nansum(dnm2,3);
dnm2=squeeze(nansum(dnm2,2));

dnm=temp_canada.*area;
dnm=nansum(dnm,3);
dnm=squeeze(nansum(dnm,2));
temp_canada_1D=dnm./dnm2;

dnm=salt_canada.*area;
dnm=nansum(dnm,3);
dnm=squeeze(nansum(dnm,2));
salt_canada_1D=dnm./dnm2;

% Makarov Basin ==3
dnm=mask;
dnm(mask~=3)=NaN;
dnm(mask==3)=1;
dnm=repmat(dnm,[1 1 nz]);
dnm=permute(dnm,[3 1 2]);
mask_mak=dnm;
temp_makarov=templvl.*dnm;
salt_makarov=salnlvl.*dnm;

dnm2=area.*mask_mak;
dnm2=nansum(dnm2,3);
dnm2=squeeze(nansum(dnm2,2));

dnm=temp_makarov.*area;
dnm=nansum(dnm,3);
dnm=squeeze(nansum(dnm,2));
temp_makarov_1D=dnm./dnm2;

dnm=salt_makarov.*area;
dnm=nansum(dnm,3);
dnm=squeeze(nansum(dnm,2));
salt_makarov_1D=dnm./dnm2;

save(savename,'salt_canada_1D','salt_eurasian_1D','salt_makarov_1D','salt_canada','salt_eurasian','salt_makarov', ...
              'temp_canada_1D','temp_eurasian_1D','temp_makarov_1D','temp_canada','temp_eurasian','temp_makarov','depth')


