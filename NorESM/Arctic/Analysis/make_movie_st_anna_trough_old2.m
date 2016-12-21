clear all

warning off

%[X_st_anna Y_st_anna]=ginput;
%[lon_st_anna lat_st_anna]=m_xy2ll(X_st_anna,Y_st_anna)

lon=nc_varget('/home/uni/milicak/Analysis/NorESM/Arctic/Analysis/grid.nc','plon');
lat=nc_varget('/home/uni/milicak/Analysis/NorESM/Arctic/Analysis/grid.nc','plat');
load ~/Analysis/NorESM/Arctic/Analysis/matfiles/st_anna_section_lonlat.mat

%project_name='NOIIA_T62_tn11_sr10m60d_01';
%folder_name=['/work/matsbn/archive/' project_name '/ocn/hist/']
%project_name='NOIIA_T62_tn11_001';
project_name='NOINY_T62_tn11_001';
folder_name=['/work/milicak/archive/' project_name '/ocn/hist/']
prefix=[folder_name project_name '.micom.hm.'];

datesep='-';
year_ini=1;
year_end=100;
nx=size(lon,2);
ny=size(lon,1);
sdate=sprintf('%4.4d%c%2.2d',year_ini,datesep,1);
depth=nc_varget([prefix sdate '.nc'],'depth');
nz=size(depth,1);
timeind=0;

Nz=70;

iind(1,1:length(lon_st_anna))=0;
jind(1,1:length(lon_st_anna))=0;
kk=1;
for k=1:length(lon_st_anna)
for j=1:385;for i=1:360
if(abs(lat(j,i)-lat_st_anna(k))<=0.5)
if(abs(lon(j,i)-lon_st_anna(k))<=0.5)
iind(kk)=i;jind(kk)=j;               
end;end
end;end
if(iind(kk)==0)
for j=1:385;for i=1:360
if(abs(lat(j,i)-lat_st_anna(k))<=0.75)
if(abs(lon(j,i)-lon_st_anna(k))<=0.75)
iind(kk)=i;jind(kk)=j;               
end;end
end;end
end
if(iind(kk)==0)
for j=1:385;for i=1:360
if(abs(lat(j,i)-lat_st_anna(k))<=1.0)
if(abs(lon(j,i)-lon_st_anna(k))<=1.0)
iind(kk)=i;jind(kk)=j;               
end;end
end;end
end
kk=kk+1;
end %k

ind=1
for years=1:45
no = num2str(years,'%.4d');
for months=1:12
hhh=figure('Visible','off');
no2 = num2str(months,'%.2d');
%filename=['N1850AERCN_f19_tn11_011.micom.hm.' no '-' no2 '.nc'];
%filename=['NOIIA_T62_tn11_001.micom.hm.' no '-' no2 '.nc'];
filename=[folder_name  project_name '.micom.hm.' no '-' no2 '.nc'];
%h=nc_varget(filename,'dz');
templvl=nc_varget(filename,'templvl');
fice=nc_varget(filename,'fice'); 
zlvl=nc_varget(filename,'depth');
time=nc_varget(filename,'time');

for kk=1:length(iind)
dnm(:,kk)=squeeze(templvl(:,jind(kk),iind(kk)));
ice_st_anna_time(kk,ind)=fice(jind(kk),iind(kk));
end

temp_st_anna_time(:,:,ind)=dnm;
pcolor(lat_st_anna,-zlvl,dnm);shading flat;ylim([-4000 0]);colorbar
needJet2
caxis([-2 1])
ylim([-3000 0])
title(['Time = ' num2str(time/365) ' years'])
printno=num2str(ind,'%.4d');
printname=['gifs/st_anna_temp_vertical_section' printno];
print(hhh,'-dpng','-zbuffer',printname)
ind=ind+1
save st_anna_trough_time_ice temp_st_anna_time ice_st_anna_time
end
end

