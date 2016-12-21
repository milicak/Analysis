clear all

warning off

lon=nc_varget('/home/uni/milicak/Analysis/NorESM/Arctic/Analysis/grid.nc','plon');
lat=nc_varget('/home/uni/milicak/Analysis/NorESM/Arctic/Analysis/grid.nc','plat');

%project_name='NOIIA_T62_tn11_sr10m60d_01';
%folder_name=['/work/matsbn/archive/' project_name '/ocn/hist/']
%project_name='NOIIA_T62_tn11_001';
project_name='N1850AERCN_f19_tn11_001';
folder_name=['/work/milicak/archive/' project_name '/ocn/hist/']
prefix=[folder_name project_name '.micom.hm.'];

datesep='-';
year_ini=1;
year_end=45;
Nz=70;
nx=size(lon,2);
ny=size(lon,1);
sdate=sprintf('%4.4d%c%2.2d',year_ini,datesep,1);
depth=nc_varget([prefix sdate '.nc'],'depth');
nz=size(depth,1);
timeind=0;

%Denmark Strait i-indices
a=[78;79;80;81;82;83;84;85;86;86];
%Denmark Strait j-indices
b=[323;323;323;323;323;323;323;323;322;322];

years=15
months=10

no = num2str(years,'%.4d');
no2 = num2str(months,'%.2d');

%filename=['N1850AERCN_f19_tn11_011.micom.hm.' no '-' no2 '.nc'];
%filename=['NOIIA_T62_tn11_001.micom.hm.' no '-' no2 '.nc'];
filename=[folder_name project_name '.micom.hm.' no '-' no2 '.nc'];

%h=nc_varget(filename,'dz');
templvl=nc_varget(filename,'templvl');
salnlvl=nc_varget(filename,'salnlvl');
vflxlvl=nc_varget(filename,'vflxlvl');
zlvl=nc_varget(filename,'depth');
for k=1:10
temp_denmark(:,k)=squeeze(templvl(:,b(k),a(k)));
salt_denmark(:,k)=squeeze(salnlvl(:,b(k),a(k)));
vflx_denmark(:,k)=squeeze(vflxlvl(:,b(k),a(k)))*1e-9;
end

% Denmark Strait Overflow sigma_theta>27.85
dens_denmark_overflow=sw_pden(salt_denmark,temp_denmark,pres_denmark,0)-1e3;
dens_denmark_overflow(dens_denmark_overflow<27.85)=NaN;


% nansum(vflx_denmark(23:32,7))

%for k=1:Nz
%dnm(:,k)=griddata(lon,lat,squeeze(templvl(k,:,:)),lon_denmark,lat_denmark,'linear');
%end

pcolor(1:10,-zlvl,temp_denmark');shading flat;ylim([-4000 0]);colorbar
needJet2
caxis([-2 1])

