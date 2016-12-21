% computes vertical section of Fram Strait
clear all
warning off

filename_s='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/annual_tracers/ocean.1708-2007.salt.nc';
filename_t='/work/milicak/RUNS/noresm/CORE2/Arctic/DATA/gfdl-mom/annual_tracers/ocean.1708-2007.temp.nc';
salt=ncgetvar(filename_s,'salt');
temp=ncgetvar(filename_t,'temp');
lon=ncgetvar(filename_t,'geolon_c');
lat=ncgetvar(filename_t,'geolat_c');
zt=ncgetvar(filename_t,'st_ocean');

tmp=squeeze(temp(:,:,:,241:end)); %last cycle 
temp=squeeze(nanmean(tmp,4));
tmp=squeeze(salt(:,:,:,241:end)); %last cycle 
salt=squeeze(nanmean(tmp,4));
clear tmp

lon_fram=[-11.5 13];
lat_fram=[81.3 79.6];
Nsection=15;
[s,a1,a2]=m_idist(lon_fram(1),lat_fram(1),lon_fram(2),lat_fram(2));
dist=0:s/Nsection:s;
[lon2,lat2,a2new]=m_fdist(lon_fram(1),lat_fram(1),a1,dist);
lon2(lon2>=80)=lon2(lon2>=80)-360;

kk=1;
for i=1:size(lon,1)
for j=1:size(lon,2)
if(abs(lon(i,j)-lon_fram(end))<=0.5 & abs(lat(i,j)-lat_fram(end))<=0.5)
indx(kk)=i;indy(kk)=j;
kk=kk+1;
end
end
end
indsecx=indx-22:indx+2;
indsecy=repmat(indy,[1 size(indsecx,2)]);

lon2=lon(indsecx,indy);
lat2=lat(indy,indsecy);

for k=1:size(temp,3)
tempframlinear(:,k)=griddata(lon,lat,squeeze(temp(:,:,k)),lon2,lat2','linear');
tempframnearest(:,k)=griddata(lon,lat,squeeze(temp(:,:,k)),lon2,lat2','nearest');
end

figure(1)
pcolor(dist'./1e3,-zt,tempframlinear');shading flat;colorbar
ylim([-3250 0])
xlabel('Diistance [km]'); ylabel('Depth [m]');
caxis([-1.75 0.5])
printname=['paperfigs/gfdl_mom_temp_vertical_fram_section'];
print(1,'-depsc2','-r150',printname)
close all



