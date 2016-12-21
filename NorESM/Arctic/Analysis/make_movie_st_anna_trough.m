clear all

warning off

%[X_st_anna Y_st_anna]=ginput;
%[lon_st_anna lat_st_anna]=m_xy2ll(X_st_anna,Y_st_anna)

lon=nc_varget('/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc','plon');
lat=nc_varget('/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc','plat');
topo=nc_varget('/fimm/home/bjerknes/milicak/Analysis/NorESM/climatology/Analysis/grid.nc','pdepth');
load ~/Analysis/NorESM/Arctic/Analysis/matfiles/st_anna_section_lonlat.mat


%project_name='N1850_f19_tn11_01_default'
%project_name='NOIIA_T62_tn11_sr10m60d_01';
project_name='N1850_f19_tn11_005'
%folder_name=['/work/matsbn/archive/' project_name '/ocn/hist/']
%project_name='NOIIA_T62_tn11_001';
%project_name='NOINY_T62_tn11_001';
%folder_name=['/work/milicak/archive/' project_name '/ocn/hist/']
%folder_name='/work-common/shared/bjerknes/milicak/mnt/norstore/NS2345K/noresm/cases/';
folder_name='/work-common/shared/bjerknes/milicak/mnt/norstore/NS9998K/noresm/cases/';
prefix=[folder_name '/' project_name '/'  project_name '.micom.hm.'];

datesep='-';
year_ini=1;
year_end=100;
nx=size(lon,2);
ny=size(lon,1);
sdate=sprintf('%4.4d%c%2.2d',year_ini,datesep,1);
timeind=0;


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

%iind=129:-1:107;
iind=129:-1:85;
jind=385*ones(1,length(iind));


for years=1:45
no = num2str(years,'%.4d');
for months=1:12
hhh=figure('Visible','off');
no2 = num2str(months,'%.2d');
%filename=['N1850AERCN_f19_tn11_011.micom.hm.' no '-' no2 '.nc'];
%filename=['NOIIA_T62_tn11_001.micom.hm.' no '-' no2 '.nc'];
filename=[folder_name '/' project_name '/ocn/hist/'  project_name '.micom.hm.' no '-' no2 '.nc'];
filename2=[folder_name '/' project_name '/ice/hist/'  project_name '.cice.h.' no '-' no2 '.nc'];
%h=nc_varget(filename,'dz');
temp=nc_varget(filename,'temp');
fice=nc_varget(filename2,'aice'); 
kd=nc_varget(filename,'difdia');
zlvl=nc_varget(filename,'dz');
time=nc_varget(filename,'time');

for k=1:length(iind)
tempsec(:,k)=temp(:,jind(k),iind(k));
Kdsec(:,k)=kd(:,jind(k),iind(k));
dzsec(:,k)=zlvl(:,jind(k),iind(k));
end
%figure
set(gcf, 'units', 'centimeters', 'pos', [0 0 40 20])
subplot(1,2,1)
m_proj('stereographic','lat',90,'long',0,'radius',30)
m_pcolor(lon(1:end-1,:),lat(1:end-1,:),fice);shfn
m_coast('patch',[.7 .7 .7])
m_grid
subplot(222) 
gcolor(tempsec,dzsec);shading flat;ylim([-4000 0]);colorbar
needJet2
caxis([-2 1])
ylim([-1500 0])
title(['Year = ' num2str(years) ' ; month = ' num2str(months)])
subplot(224)
gcolor(Kdsec,dzsec);shading flat;ylim([-4000 0]);colorbar
needJet2
caxis([-5 -1])
ylim([-1500 0])
printno=num2str(ind,'%.4d');
printname=['gifs/st_anna_temp_vertical_section' printno];
print(hhh,'-dpng','-zbuffer',printname)
ind=ind+1
end %months
end %years

