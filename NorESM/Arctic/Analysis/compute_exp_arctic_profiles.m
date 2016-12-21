clear all

grdname='/home/fimm/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc';

lon=nc_varget(grdname,'plon');
lat=nc_varget(grdname,'plat');
area=nc_varget(grdname,'parea');
depth2d=nc_varget(grdname,'pdepth');
mask=nc_varget('arctic_mask.nc','mask');

%project_name='NOIIA_T62_tn11_sr10m60d_01';
%folder_name=['/hexagon/work/matsbn/archive/' project_name '/ocn/hist/']
%project_name='N1850AERCN_f19_tn11_002';
project_name='NOINY_T62_tn11_013';
folder_name=['/hexagon/work/milicak/archive/' project_name '/ocn/hist/']
prefix=[folder_name project_name '.micom.hm.'];

year_ini=1;
year_end=100;
savename=['matfiles/' project_name '_basin_profiles_years_' num2str(year_ini) '_' num2str(year_end) '.mat'];

datesep='-';
nx=size(lon,2);
ny=size(lon,1);
sdate=sprintf('%4.4d%c%2.2d',year_ini,datesep,1);
depth=nc_varget([prefix sdate '.nc'],'depth'); 
nz=size(depth,1);
n=0;
templvl=zeros(nx,ny,nz);
salnlvl=zeros(nx,ny,nz);

area=repmat(area,[1 1 nz]);
area=permute(area,[2 1 3]);
depth3d=repmat(depth,[1 nx ny]);
depth3d=permute(depth3d,[2 3 1]);
depth3d_r=repmat(depth2d,[1 1 nz]);
depth3d_r=permute(depth3d_r,[2 1 3]); 
depth3d(depth3d>depth3d_r)=NaN;
area(isnan(depth3d)==1)=NaN;

for year=year_ini:year_end
for month=1:12
n=n+1;
sdate=sprintf('%4.4d%c%2.2d',year,datesep,month);
disp(sdate)
templvl=templvl+ncgetvar([prefix sdate '.nc'],'templvl');
salnlvl=salnlvl+ncgetvar([prefix sdate '.nc'],'salnlvl');
uflxlvl=salnlvl+ncgetvar([prefix sdate '.nc'],'uflxlvl');
vflxlvl=salnlvl+ncgetvar([prefix sdate '.nc'],'vflxlvl');
end
end

templvl=templvl/n;
salnlvl=salnlvl/n;
uflxlvl=uflxlvl/n;
vflxlvl=vflxlvl/n;

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


save(savename,'salt_canada_1D','salt_eurasian_1D','salt_makarov_1D','salt_canada','salt_eurasian','salt_makarov', ...
              'temp_canada_1D','temp_eurasian_1D','temp_makarov_1D','temp_canada','temp_eurasian','temp_makarov','depth')


